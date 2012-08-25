// XQGame.cpp: implementation of the CXQGame class.
//
//////////////////////////////////////////////////////////////////////
//#ifdef WIN32
//#include "stdAfx.h"
//#endif	// 如果此处编译出错，请将“预编译头”关掉；或者将#ifdef ... #endif注释掉（原因：预编译头#include前面的任何内容被忽略了）


#include <math.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <iostream>
#include "xqgame.h"
#include <vector>

	
#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

#ifndef min
#define min(a,b) (((a) < (b)) ? (a) : (b))
#endif

#ifndef max
#define max(a,b) (((a) > (b)) ? (a) : (b))
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

#ifdef LOGGER
IMPL_LOGGER(CXQGame)
#endif

template<class T> bool VectorHasSameElement(std::vector<T>& v1, std::vector<T>& v2)
{
    if(v1.size() != v2.size())
    {
        return false;
    }
	size_t i, j;
    for(i = 0; i < v1.size(); i++)
    {
        for(j = 0 ; j < v2.size(); j++ )
        {
            if(v1[i] == v2[j])
                break;
        }

        if(j == v2.size())
            return false;
    }

    return true;
}

CXQGame::CXQGame()
{
	m_bMyTurn = false;
	m_Side = RED_SIDE;
	m_GameState = GAME_UNKNOWN;
	m_nStepCount = 0;
}

CXQGame::~CXQGame()
{
}

//初始化棋盘
void CXQGame::InitGame(int nSideFlag)
{
	m_Side = (nSideFlag == 0)? RED_SIDE : BLACK_SIDE;

	for(int i=0; i<32; ++i)
	{
		m_piecePos[i].x = _defaultPos[0][i];
		m_piecePos[i].y = _defaultPos[1][i];
	}

	FillChessMap(m_chessmap, m_piecePos);
	m_GameState = GAME_STARTED;
	m_nStepCount = 0;
}

//将32颗棋填充到棋盘矩阵中
void CXQGame::FillChessMap(int _map[10][9], CPoint manpoint[32])
{
	ResetChessMap(_map);	// 将_map全部置为-1

	CPoint* pman = manpoint;
	for(int i=0; i<32; ++i, ++pman)
	{
		if(pman->x >= 0)		// 棋子的x坐标为-1时，表示该子被吃掉了
			_map[pman->y][pman->x]=i;
	}
}

//判断走子是否符合规则
bool CXQGame::canMove(const CPoint &from, const CPoint &to)
{
#ifdef LOGGER
	LOG_DEBUG("[CnChess]:canMove(), from ("<<from.x<<", "<<from.y<<"), to ("<<to.x<<", "<<to.y<<")");
#endif
	if(!( m_GameState==GAME_STARTED && IsMyPiece(from) && !IsMyPiece(to) && IsValidPos(from, to)))	//这个棋子不能放在目标位置
		return false;

	int i,j;
	bool rtn = true;
	//以下是各棋子的规则：（兵、仕、将均为一步一步走，不考虑阻挡）
	switch(GetChessTypeFromPoint(from))	
	{
	case RED_B:
		if( (to.y < from.y)								// 兵不回头：红的只能向下走
			||(abs(to.y-from.y) + abs(to.x-from.x) != 1))	// 兵只走一步直线
			rtn = false;
		break;

	case BLACK_B:
		if( (to.y > from.y)								// 卒不回头：黑的只能向上走
			||(abs(to.y-from.y) + abs(to.x-from.x) != 1))	// 卒只走一步直线
			rtn = false;
		break;

	case RED_S:
	case BLACK_S:
		if( abs(to.y-from.y) != 1 || abs(to.x-from.x) != 1)	//士走斜线一步:
			rtn = false;
		break;

	case RED_K:
	case BLACK_K:
		if(abs(to.y-from.y)+abs(to.x-from.x) != 1)	//将帅只走一步直线:
			rtn = false;
		break;

	case RED_X:
	case BLACK_X:
		j = (to.x+from.x)/2;
		i = (to.y+from.y)/2;
		if( (abs(to.x-from.x) != 2) || (abs(to.y-from.y) != 2)	// 相走田:
			||(m_chessmap[i][j] >= 0))								// 相心有子；阻挡
			rtn = false;
		break;

	case RED_M:
	case BLACK_M:
		if(!((abs(to.x-from.x)==1&&abs(to.y-from.y)==2)	|| (abs(to.x-from.x)==2&&abs(to.y-from.y)==1)))	//马走日:
		{
			rtn = false;
			break;
		}

		// 找马脚:
		if	   (to.x-from.x==2){j=from.x+1;i=from.y;}
		else if(from.x-to.x==2){j=from.x-1;i=from.y;}
		else if(to.y-from.y==2){j=from.x;i=from.y+1;}
		else if(from.y-to.y==2){j=from.x;i=from.y-1;}

		if(m_chessmap[i][j]>=0)	// 绊马脚；阻挡
			rtn = false;
		break;

	case RED_J:
	case BLACK_J:
		if(from.x!=to.x && from.y!=to.y)	// 车只能走直线:
		{
			rtn = false;
			break;
		}

		// 车经过的路线中不能有棋子；阻挡
		if(from.y==to.y)
		{
			j = min(to.x, from.x);
			i = max(to.x, from.x);
			for(j=j+1; j<i; ++j)
			{
				if(m_chessmap[to.y][j]>=0)
				{
					rtn = false;
					break;
				}
			}
		}
		else
		{
			i = min(to.y, from.y);
			j = max(to.y, from.y);
			for(i=i+1; i<j; ++i)
			{
				if(m_chessmap[i][to.x]>=0)
				{
					rtn = false;
					break;
				}
			}
		}
		break;

	case RED_P:
	case BLACK_P:
		if(from.y!=to.y && from.x!=to.x)	// 炮只能走直线:
		{
			rtn = false;
			break;
		}

		//炮不吃子时经过的路线中不能有棋子；阻挡
		if(m_chessmap[to.y][to.x]<0)
		{
			if(from.y==to.y)
			{
				j = min(to.x, from.x);
				i = max(to.x, from.x);
				for(j=j+1; j<i; ++j)
				{
					if(m_chessmap[to.y][j]>=0)
					{
						rtn = false;
						break;
					}
				}
			}
			else
			{
				i = min(to.y, from.y);
				j = max(to.y, from.y);
				for(i=i+1; i<j; ++i)
				{
					if(m_chessmap[i][to.x]>=0)
					{
						rtn = false;
						break;
					}
				}
			}
		}
		//以上是炮不吃子
		//吃子时:=======================================
		else
		{
			int count=0;
			if(from.y==to.y)
			{
				j = min(to.x, from.x);
				i = max(to.x, from.x);
				for(j=j+1; j<i; ++j)
				{
					if(m_chessmap[to.y][j]>=0)
						++count;
				}
			}
			else
			{
				i = min(to.y, from.y);
				j = max(to.y, from.y);
				for(i=i+1; i<j; ++i)
				{
					if(m_chessmap[i][to.x]>=0)
						++count;
				}
			}
			if(count != 1)
				rtn = false;
		}
		//以上是炮吃子时================================
		break;	

	default:
		rtn = false;
		break;
	}

	return rtn;	// 上面的规则检验完毕
}

//客户端走子
int CXQGame::MovedAPiece_Client(const CPoint &from, const CPoint &to, const char nSide, const char bCheck)
{
	int i = -1;
	if( m_GameState == GAME_STARTED && CheckPieceSide(from, SideFlag(nSide)))
	{
		i = MoveAPiece(from, to, nSide, bCheck);
	}

	return i;
}

//服务器端走子
int CXQGame::MovedAPiece_Svr(const CPoint &from, const CPoint &to, const char nSide, char &bCheck)
{
	int i = -1;
	m_Side = SideFlag(nSide);
	if( canMove(from, to) && CheckViolation(from, to) > 0)
	{
		i = MoveAPiece(from, to, nSide, char(-1));
		bCheck = canKillRivalKing() ? 1 : 0;
		GetNthStep(m_nStepCount-1)._check = bCheck;
	}

	return i;
}

//走子
int CXQGame::MoveAPiece(const CPoint &from, const CPoint &to, const char nSide, const char bCheck)
{
	ChessStep stepT;

	stepT._man = GetPieceIndex(from);
	stepT._eaten = GetPieceIndex(to);
	stepT._RoundSide = nSide;
	stepT._check = bCheck;
	stepT._SourcePos.x = char(from.x);
	stepT._SourcePos.y = char(from.y);
	stepT._DestPos.x = char(to.x);
	stepT._DestPos.y = char(to.y);

	sprintf(m_DescribeStr, "%ld,%ld", from.x+from.y*9, to.x+to.y*9);						// 移动前后的位置
	sprintf(m_DescribeStr+strlen(m_DescribeStr), "|%d,%ld", stepT._man, to.x+to.y*9);	// 移动的棋子的新位置
	
	
	//m_DescribeVec.clear();
	//m_DescribeVec.push_back(from.x+from.y*9);
	//NSLog(@"m_DescribeVec[0] = %d, from.x+from.y*9 = %d", m_DescribeVec[0], from.x+from.y*9);
	//m_DescribeVec.push_back(to.x+to.y*9);
	//NSLog(@"m_DescribeVec[1] = %d, to.x+to.y*9 = %d", m_DescribeVec[1], to.x+to.y*9);
	
	
	//m_DescribeVec.push_back(stepT._man);
	//NSLog(@"m_DescribeVec[2] = %d, stepT._man = %d", m_DescribeVec[2], stepT._man);
	//m_DescribeVec.push_back(to.x+to.y*9);
	//NSLog(@"m_DescribeVec[3] = %d, to.x+to.y*9 = %d", m_DescribeVec[3], to.x+to.y*9);
	
	//NSLog(@"m_DescribeStr = %s", m_DescribeStr);
	//NSLog(@"m_DescribeVec = %d, %d, %d, %d", m_DescribeVec[0], m_DescribeVec[1], m_DescribeVec[2], m_DescribeVec[3]);

	
	int rtn = 0;
	if(stepT._eaten >= 0)
	{
		//如果目标点已经有棋子，则是吃子，将目标点原来的棋子的x位置置为-1，表示该字被吃掉了
		m_piecePos[stepT._eaten].x = -1;
		sprintf(m_DescribeStr+strlen(m_DescribeStr), "|%d,%d", stepT._eaten, -1);		// 被吃的子，坐标为-1，表示隐藏
		
		//m_DescribeVec.push_back(stepT._eaten);
		//m_DescribeVec.push_back(-1);
		
		// 如果被吃掉的是将帅，游戏结束
		PIECETYPE eaten = GetChessTypeFromPoint(to);
		if(eaten == RED_K ||eaten == BLACK_K)
		{
			m_GameState = GAME_OVER;
			rtn = (eaten == BLACK_K) ? 1: 2;
		}
	}

	++m_nStepCount;
	GetNthStep(m_nStepCount - 1) = stepT;
	RecordCurrentStep();
	
	// 将棋子放到新的位置，更新棋盘
	m_piecePos[stepT._man] = to;
	FillChessMap(m_chessmap, m_piecePos);
	return rtn;
}

bool CXQGame::RetractMoves(int n)
{
	if(!(n==1 || n==2) || (m_nStepCount-n)<3)
	{
		return false;
	}
    
    return retractmoves(n);
}
//悔棋
bool CXQGame::retractmoves(int n)
{

    ChessPoint from, to;
    const ChessStep &s = GetNthStep(m_nStepCount - n - 1);
    from = s._SourcePos;
    to = s._DestPos;
    sprintf(m_DescribeStr, "%d,%d", from.x+from.y*9, to.x+to.y*9);	// 悔棋后，上一次有效移动的前后位置
	//m_DescribeVec.clear();
	//m_DescribeVec.push_back(from.x+from.y*9);
	//m_DescribeVec.push_back(to.x+to.y*9);
	
    for(int i=0; i<n; ++i)
    {
        const ChessStep a_step = GetNthStep(m_nStepCount - 1);
        from = a_step._SourcePos;				// 移动的那个子
        m_piecePos[a_step._man ].x = from.x;		// 还原移动的那个子的位置
        m_piecePos[a_step._man ].y = from.y;

        sprintf(m_DescribeStr+strlen(m_DescribeStr), "|%d,%d", a_step._man, from.x+from.y*9);	// 移动的棋子的原位置
        //m_DescribeVec.push_back(a_step._man);
		//m_DescribeVec.push_back(from.x+from.y*9);
		
		if (a_step._eaten != NO_CHESS )
        {
            to = a_step._DestPos;	// 被吃的那个子，如果有的话
            m_piecePos[a_step._eaten].x = to.x;
            m_piecePos[a_step._eaten].y = to.y;
            sprintf(m_DescribeStr+strlen(m_DescribeStr), "|%d,%d", a_step._eaten, to.x+to.y*9);	// 被吃棋子的原位置
			//m_DescribeVec.push_back(a_step._eaten);
			//m_DescribeVec.push_back(to.x+to.y*9);
		
		}
        --m_nStepCount;
    }
    // 更新棋盘
    FillChessMap(m_chessmap, m_piecePos);

    return true;
}

// 判断此步棋是否将军
bool CXQGame::canKillRivalKing()
{
	CPoint *pFrom = NULL;
	CPoint to;
	int nOff = 0;
	if(m_Side == RED_SIDE)
	{
		nOff = 0;
		to = m_piecePos[BLACK_KING_POS];
	}
	else
	{
		nOff = 16;
		to = m_piecePos[RED_KING_POS];
	}
	pFrom = m_piecePos + nOff;

	bool rtn = false;
	for(int i=0; i<16 && !rtn; ++i)
	{
		if(pFrom[i].x < 0)
			continue;
		rtn = canMove(pFrom[i], to);
	}

	return rtn;
}




bool CXQGame::IsValidPos(const CPoint &from, const CPoint &to)
{
	bool rtn = true;
	switch(GetChessTypeFromPoint(from))
	{
	case RED_K:	
		if( to.x<3|| to.x>5 || to.y<0 || to.y>2)	// 帅不能在红方宫外:
			rtn = false; 
		break;

	case RED_S:	
		if(!(( to.x==3&& to.y==0)||	// 仕只能在宫内特定点:
			( to.x==3&& to.y==2)||
			( to.x==4&& to.y==1)||
			( to.x==5&& to.y==2)||
			( to.x==5&& to.y==0)))
			rtn = false;
		break;

	case RED_X:
		if(!(( to.x==0&& to.y==2)||	// 七个相位:
			( to.x==2&& to.y==0)||
			( to.x==2&& to.y==4)||
			( to.x==4&& to.y==2)||
			( to.x==6&& to.y==4)||
			( to.x==6&& to.y==0)||
			( to.x==8&& to.y==2)))
			rtn = false;
		break;

	case RED_B:
		if( (to.y<3) ||				// 兵不能在兵位后:
			( to.y<5 && to.x%2!=0))	// 兵过河前不能左右移动:
			rtn = false;
		break;

	case BLACK_K:
		if( to.x<3 || to.x>5 || to.y<7 || to.y>9)	// 帅不能在黑方宫外:
			rtn = false;
		break;

	case BLACK_S:
		if(!(( to.x==3&& to.y==7)||	// 仕只能在宫内特定点:
			( to.x==3&& to.y==9)||
			( to.x==4&& to.y==8)||
			( to.x==5&& to.y==9)||
			( to.x==5&& to.y==7)))
			rtn = false;
		break;

	case BLACK_X:
		if(!(( to.x==0&& to.y==7)||	// 七个相位:
			( to.x==2&& to.y==9)||
			( to.x==2&& to.y==5)||
			( to.x==4&& to.y==7)||
			( to.x==6&& to.y==5)||
			( to.x==6&& to.y==9)||
			( to.x==8&& to.y==7)))
			rtn = false;
		break;

	case BLACK_B:
		if( (to.y>6)||				// 兵不能在兵位后:
			(to.y>4&& to.x%2!=0))	// 兵过河前不能左右移动:
			rtn = false;
		break;

	default:
		break;
	}
	return rtn;
}

bool CXQGame::PrintAllPiecesPos(int side, ChessStep *stepArr, int stepCount, char *pBuff, int len)
{
	CPoint piecePos[32];		// 初始化开始时棋子的位置
	for(int i=0; i<32; ++i)
	{
		piecePos[i].x = _defaultPos[0][i];
		piecePos[i].y = _defaultPos[1][i];
	}
	sprintf(pBuff, "%d", side);					// 我是红色，还是黑色

	int sideIndex = 0;
	int nStep = 0;
	char tempBuff[512];

	// 依次描述每步棋后，各个棋子的位置
	for(int i=0; i<stepCount; ++i)
	{
		char *pTermDesc = GetTermDescr(sideIndex, nStep, stepArr[i]._man, stepArr[i]._SourcePos.x, stepArr[i]._SourcePos.y, stepArr[i]._DestPos.x, stepArr[i]._DestPos.y);
		sprintf(tempBuff, "_%s", pTermDesc);	// 这步棋的术语描述

		sprintf(tempBuff+strlen(tempBuff), "|%d,%d,%d,%d", stepArr[i]._SourcePos.x, stepArr[i]._SourcePos.y, stepArr[i]._DestPos.x, stepArr[i]._DestPos.y);									// 移动的光标
		piecePos[stepArr[i]._man].x = stepArr[i]._DestPos.x;
		piecePos[stepArr[i]._man].y = stepArr[i]._DestPos.y;
		if(stepArr[i]._eaten >= 0)
		{
			piecePos[stepArr[i]._eaten].x = -1;
		}
		for(int i=0; i<32; ++i)
		{
			sprintf(tempBuff+strlen(tempBuff), "|%ld,%ld", piecePos[i].x, piecePos[i].y);
		}

		sprintf(pBuff+strlen(pBuff), "%s", tempBuff);
		sideIndex = 1 - sideIndex;
		if(sideIndex == 0)
		{
			++nStep;
		}
	}
	return true;
}

char* CXQGame::GetTermDescr(int side, int step, int nMan, int fromX, int fromY, int toX, int toY)
{
	const static char* sideName[] = {"红", "黑"};
	const static char* sideNum[] = {"一", "二", "三", "四", "五", "六", "七", "八", "九", 
		" 1", " 2", " 3", " 4", " 5", " 6", " 7", " 8", " 9"};
	const static char* typeName[] = {"帅", "仕", "相", "马", "車", "炮", "兵",
		"  ", "  ", "  ",
		"将", "士", "象", "马", "车", "炮", "卒"};
	const static char* moveName[] = {"进", "退", "平"};
	if(side != 0)
	{
		fromX = 8 - fromX;
		fromY = 9 - fromY;
		toX = 8 - toX;
		toY = 9 - toY;
	}
	int nMove = 0, nTo = 0;
	if(toY > fromY)
	{
		nMove = 0;
		if(pieceType[nMan]==RED_S || pieceType[nMan]==RED_X || pieceType[nMan]==RED_M || 
			pieceType[nMan]==BLACK_S || pieceType[nMan]==BLACK_X || pieceType[nMan]==BLACK_M)
		{
			nTo = toX;
		}
		else
		{
			nTo = toY - fromY - 1;
		}
	}
	else if(toY < fromY)
	{
		nMove = 1;
		if(pieceType[nMan]==RED_S || pieceType[nMan]==RED_X || pieceType[nMan]==RED_M || 
			pieceType[nMan]==BLACK_S || pieceType[nMan]==BLACK_X || pieceType[nMan]==BLACK_M)
		{
			nTo = toX;
		}
		else
		{
			nTo = fromY - toY - 1;
		}
	}
	else
	{
		nMove = 2;
		nTo = toX;
	}
	static char buff[32];
	sprintf(buff, "%s%3.1d: %s%s%s%s", sideName[side], step+1, typeName[int(pieceType[nMan])], sideNum[side*9+fromX], moveName[nMove], sideNum[side*9+nTo]);

	return buff;
}

/////////////////////////
int CXQGame::GetStepArrMaxLen()
{
	return min(m_nStepCount, STEP_RECORD_LENGTH + STEP_BUFF_LENGTH);
}

void CXQGame::GetGameData(char *pPosArr, ChessStep *pStepArr)
{
	for(int i=0; i<32; ++i)
	{
		pPosArr[i*2] = char(m_piecePos[i].x);
		pPosArr[i*2+1] = char(m_piecePos[i].y);
	}

	int nStepRecordLen = min(m_nStepCount, STEP_RECORD_LENGTH);
	int nStepBuffLen = min(m_nStepCount-nStepRecordLen, STEP_BUFF_LENGTH);

	memcpy(pStepArr, m_ChessStepRecord, sizeof(ChessStep) * nStepRecordLen);
	for(int i=0; i<nStepBuffLen; ++i)
	{
		pStepArr[nStepRecordLen+i] = GetNthStep(m_nStepCount-nStepBuffLen+i);
	}
}

void CXQGame::SetGameData(char *pPosArr, ChessStep *pStepArr, int nStepCount)
{
	for(int i=0; i<32; ++i)
	{
		m_piecePos[i].x = int(pPosArr[i*2]);
		m_piecePos[i].y = int(pPosArr[i*2+1]);
	}

	m_nStepCount = nStepCount;
	
	int nEnd = min(nStepCount, STEP_RECORD_LENGTH+STEP_BUFF_LENGTH);
	int nStepRecordLen = min(nStepCount, STEP_RECORD_LENGTH);
	int nStepBuffLen = min(nStepCount, STEP_BUFF_LENGTH);
	memcpy(m_ChessStepRecord, pStepArr, sizeof(ChessStep) * nStepRecordLen);
	for(int i=0; i<nStepBuffLen; ++i)
	{
		GetNthStep(m_nStepCount-nStepBuffLen+i) = pStepArr[nEnd-nStepBuffLen+i];
	}

	FillChessMap(m_chessmap, m_piecePos);
}

char* CXQGame::GetCompleteDescribeOfCurPos()
{
	int from = -1, to = -1;
	if(m_nStepCount > 0)
	{
		const ChessStep &step = GetNthStep(m_nStepCount - 1);
		from = step._SourcePos.x + step._SourcePos.y*9;
		to = step._DestPos.x + step._DestPos.y*9;
	}
	sprintf(m_DescribeStr, "%d,%d", from, to);	// 本次移动的前后位置
	//m_DescribeVec.clear();
	//m_DescribeVec.push_back(from);
	//m_DescribeVec.push_back(to);
	
	int n = -1;
	for(int i=0; i<32; ++i)
	{
		n = m_piecePos[i].x;
		if(n >= 0)
		{
			n += m_piecePos[i].y*9;
		}
		sprintf(m_DescribeStr+strlen(m_DescribeStr), "|%d,%d", i, n);	// 第i颗棋子的位置
		//m_DescribeVec.push_back(i);
		//m_DescribeVec.push_back(n);
	}

	return m_DescribeStr;
}

int CXQGame::CheckViolation(const CPoint &from, const CPoint &to, BOOL bWarn)
{
	int code = 0;




	if(WillKingsMeet(from, to))
	{
		code = 1;
	}
    /* 暂时去掉循环走的判断
	else if(IsLoopCycle(from, to))
	{
		code = 2;
	}*/
    else if(IsLoopCheck(from, to))
    {
        code = 3;
    }
    else if(IsLoopSnatch(from, to))
    {
        code = 4;
    }
    /*
    else if(bWarn && ShouldShowWarning(from, to))
    {
        code = -1;
    }*/    
    /*
	else if(WillBeInCheck(from, to))
	{
	    code = -2;
	}*/
	return code;
}

bool CXQGame::WillKingsMeet(const CPoint &from, const CPoint &to)
{
	int i,j;
	int manmap[10][9];
	FillChessMap(manmap, m_piecePos);

	// 判断走动后，是否会造成将帅照面
	// 假定移动棋子
	i = manmap[from.y][from.x];
	j = manmap[to.y][to.x];				// 此处的子可能被吃
	manmap[to.y][to.x] = i;
	manmap[from.y][from.x] = -1;

	// 判断将帅是否在一条线上
	CPoint redKing = m_piecePos[RED_KING_POS];		// 正常情况下红、黑将的位置
	CPoint blackKing = m_piecePos[BLACK_KING_POS];

	if(i== RED_KING_POS)							// 如果当前要移动的是将，则红（或黑）将的位置将变为新的位置
		redKing = to;
	else if(i== BLACK_KING_POS)
		blackKing = to;

	bool rtn = false;
	// 现在判断将帅是否碰面就没问题了；不在一竖线，或将被吃的话，直接返回
	if(redKing.x == blackKing.x && j != RED_KING_POS && j != BLACK_KING_POS)
	{
		rtn = true;
		i = redKing.y;		// 红的在上，小
		j = blackKing.y;	// 黑的在下，大

		for(i=i+1; i<j && rtn; ++i)
		{
			if(manmap[i][redKing.x] >= 0)	// 中间至少有一颗子
				rtn = false;
		}
	}
	return rtn;
}

bool CXQGame::IsLoopCycle(const CPoint &from, const CPoint &to)
{
	if(m_nStepCount < 1 || GetNthStep(m_nStepCount-1)._check != 0)
	{
		return false;
	}

	bool rtn = false;
	int nStep1 = 0;
	int nStep2 = 0;
	int nStep3 = 0;
	for(int i=2; i<3 && !rtn; ++i)
	{
		if(m_nStepCount < 3*2*i)
			break;

		nStep1 = m_nStepCount - 1*2*i;
		nStep2 = m_nStepCount - 2*2*i;
		nStep3 = m_nStepCount - 3*2*i;
		bool bViolation = true;
		ChessStep &step = GetNthStep(nStep1);
		if( GetPieceIndex(from) != step._man || 
			char(to.x) != step._DestPos.x || char(to.y) != step._DestPos.y)
		{
			bViolation = false;
		}
		for(int j=0; j<2*i && bViolation; ++j)
		{
			if((GetNthStep(nStep1+j) != GetNthStep(nStep2+j)) || (GetNthStep(nStep2+j) != GetNthStep(nStep3+j)))
			{
				bViolation = false;
			}
		}
		rtn = bViolation;
	}

	return rtn;
}

bool CXQGame::IsLoopSnatch(const CPoint& from, const CPoint &to)
{
    //LOG_TRACE("[CXQGame::IsLoopSnatch] enter");
    if(m_nStepCount < 12)
    {
        return false;
    }
    
    if(GetPieceIndex(from) != GetNthStep(m_nStepCount - 2)._man)
    {
        return false;
    }


    int nBeginStep = m_nStepCount - 12;
    int StepIndex = 0;

   

    for(StepIndex = nBeginStep; StepIndex < m_nStepCount; StepIndex++)
    {
        ChessStep& step = GetNthStep(StepIndex);
        if(step._eaten != -1 || step._check)
        {
            // 有子力变化则不算
            //LOG_TRACE("[CXQGame::IsLoopSnatch] someone eat chess");
            return false;
        }
    }


    // 如果一方走的不是同一个子
    for(StepIndex = nBeginStep + 2; StepIndex < m_nStepCount;  StepIndex += 2)
    {
        ChessStep& step = GetNthStep(StepIndex);
        if(step._man != GetNthStep(nBeginStep)._man)
        {
            //LOG_TRACE("[CXQGame::IsLoopSnatch] not the same chess1");
            return false;
        }
    }

    // 如果一方走的不是同一个子
    for(StepIndex = nBeginStep + 3; StepIndex < m_nStepCount;  StepIndex += 2)
    {
        ChessStep& step = GetNthStep(StepIndex);
        if(step._man != GetNthStep(nBeginStep + 1)._man)
        {
            //LOG_TRACE("[CXQGame::IsLoopSnatch] not the same chess2");
            return false;
        }
    }


    CXQGame temp;
    memcpy(&temp, this, sizeof(temp));
    temp.MovedAPiece_Client(from, to, temp.m_Side, 0);
    CPoint srcPoint, destPoint;
    destPoint.x = GetNthStep(m_nStepCount-1)._DestPos.x;
    destPoint.y = GetNthStep(m_nStepCount-1)._DestPos.y;
    if(!temp.canMove(to, destPoint))
    {
        //LOG_TRACE("[CXQGame::IsLoopSnatch] !temp.canMove(to, GetNthStep(m_nStepCount-2)._DestPos)");
        return false;
    }

    // 判断是否总吃子
    int i;
    for(i = 0; i < 6; i++)
    {
        ChessStep& MyStep = GetNthStep(nBeginStep + i*2);
        ChessStep& RivalStep = GetNthStep(nBeginStep + i*2 +1);

        memcpy(&temp, this, sizeof(temp));

        // 悔棋悔到该位置
        int RetractSteps = 5 - i;
        while(RetractSteps-- > 0)
        {
            temp.RetractMoves(2);
        }


        temp.RetractMoves(1);
        //temp.m_Side =  (temp.m_Side == BLACK_SIDE) ? RED_SIDE : BLACK_SIDE;

        srcPoint.x = MyStep._DestPos.x;
        srcPoint.y = MyStep._DestPos.y;
        destPoint.x = RivalStep._SourcePos.x;
        destPoint.y = RivalStep._SourcePos.y;
 
        if(!temp.canMove(srcPoint, destPoint))        
        {
            //LOG_TRACE("[CXQGame::IsLoopSnatch] can not kill");
            return false;
        }
        //LOG_TRACE("[CXQGame::IsLoopSnatch] can move");
    }


    // 判断是否相互捉
    for(i = 0; i < 6; i++)
    {
        ChessStep& MyStep = GetNthStep(nBeginStep + i*2);
        ChessStep& RivalStep = GetNthStep(nBeginStep + i*2 + 1);
        

        memcpy(&temp, this, sizeof(temp));

        // 悔棋悔到该位置
        int RetractSteps = 5 - i;
        while(RetractSteps-- > 0)
        {
            temp.RetractMoves(2);
        }

        temp.m_Side =  (temp.m_Side == BLACK_SIDE) ? RED_SIDE : BLACK_SIDE;

        srcPoint.x = RivalStep._DestPos.x;
        srcPoint.y = RivalStep._DestPos.y;
        destPoint.x = MyStep._DestPos.x;
        destPoint.y = MyStep._DestPos.y;

        if(temp.canMove(srcPoint, destPoint))        
        {
            //LOG_TRACE("[CXQGame::IsLoopSnatch] can  kill22222");
            return false;
        }
        //LOG_TRACE("[CXQGame::IsLoopSnatch] can not move222");
    }

    
    //LOG_TRACE("[CXQGame::IsLoopSnatch] is loop snatch!!!!!");
    return true;

}

bool CXQGame::IsLoopCheck(const CPoint& from, const CPoint& to)
{
    //LOG_TRACE("CXQGame::IsLoopCheck entry");

    if(m_nStepCount < 12)
    {
        //LOG_TRACE("CXQGame::IsLoopCheck if(m_nStepCount < 12)");
        return false;
    }

    int nStep1 = 0;
    int nStep2 = 0;
    int nStep3 = 0;
    int nStep4 = 0;
    int nStep5 = 0;
    


  
    nStep1 = m_nStepCount - 2;
    nStep2 = m_nStepCount - 4;
    nStep3 = m_nStepCount - 6;
    nStep4 = m_nStepCount - 8;
    nStep5 = m_nStepCount - 10;

    ChessStep step1 = GetNthStep(nStep1);
    ChessStep step2 = GetNthStep(nStep2);
    ChessStep step3 = GetNthStep(nStep3);
    ChessStep step4 = GetNthStep(nStep4);
    ChessStep step5 = GetNthStep(nStep5);

    // 没有长将
    if(!step1._check || !step2._check || !step3._check || !step4._check || !step5._check)
    {
        //LOG_TRACE("CXQGame::IsLoopCheck (!step1._check || !step2._check || !step3._check || !step4._check || !step5._check");
        return false;
    }

    // 子力发生变化， 不算长将
    if(step1._eaten != -1 || step2._eaten != -1 || step3._eaten != -1 || step4._eaten != -1 || step5._eaten != -1)
    {
        //LOG_TRACE("CXQGame::IsLoopCheck step1._eaten != -1 || step2._eaten != -1 || step3._eaten != -1 || step4._eaten != -1 || step5._eaten != -1");
        return false;
    }

    // 如果目标位置有一颗棋子， 则可能发生子力变化， 因此不应判断为长将
    if(GetPieceIndex(to) != -1)
    {
        return false;
    }

    static CXQGame temp;
    memcpy( &temp, this, sizeof(temp));
    if(!temp.canMove(from, to))
    {
        //LOG_TRACE("CXQGame::IsLoopCheck if(!temp.canMove(from, to))");
        return false;
    }
    temp.MovedAPiece_Client(from, to, temp.m_Side, 0);
    if(!temp.canKillRivalKing())
    {
        return false;
    }
    
    for(int tmpstepid = m_nStepCount - 9; tmpstepid < m_nStepCount; tmpstepid+=2)
    {
        // 如果在这个过程中我也有被将过
        if(GetNthStep(tmpstepid)._check)
        {
            //LOG_TRACE("CXQGame::IsLoopCheck GetNthStep(tmpstepid)._check");
            return false;
        }
    }

    if( (step1._man != step3._man || step3._man != step5._man)  )
        return false;

    if( step2._man !=  step4._man)
        return false;

    //LOG_TRACE("CXQGame::IsLoopCheck GetNthStep true");
    return true;
}

bool CXQGame::ShouldDraw()
{
    //LOG_TRACE("[CXQGame::ShouldDraw] enter");
    if(m_nStepCount < 120)
        return false;

    int nBeginStep = m_nStepCount - 120;
    int StepIndex = 0;

    for(StepIndex = nBeginStep; StepIndex < m_nStepCount; StepIndex++)
    {
        ChessStep& step = GetNthStep(StepIndex);
        if(step._eaten >= 0)
        {
            // 有子力变化则不算
            //LOG_TRACE("[CXQGame::ShouldDraw] someone eat chess");
            return false;
        }
    }

    //LOG_TRACE("[CXQGame::ShouldDraw] should draw!!!!!!");
    return true;
}


// 判断是否能吃掉某个子
bool CXQGame::canKillChess(const CPoint& to)
{
    CPoint *pFrom = NULL;
    int nOff = 0;
    if(m_Side == RED_SIDE)
    {
        nOff = 0;
    }
    else
    {
        nOff = 16;
    }
    pFrom = m_piecePos + nOff;

    bool rtn = false;
    for(int i=0; i<16 && !rtn; ++i)
    {
        if(pFrom[i].x < 0)
            continue;
        rtn = canMove(pFrom[i], to);
    }

    return rtn;
}


bool CXQGame::ShouldShowWarning(const CPoint &from, const CPoint &to)
{
#ifdef WIN32
    static CXQGame temp;
    memcpy( &temp, this, sizeof(temp));

    bool rtn = false;
    bool bSucc = ( temp.MovedAPiece_Client(from, to, char(temp.m_Side), char(0)) == 0);
    if(bSucc)
    {
        temp.m_Side = SideFlag( RED_SIDE + BLACK_SIDE - temp.m_Side);
        rtn = (temp.canKillChess(to));
    }

    return rtn;
#else
    return false;
#endif
}

// 得到不安全的将或帅的位置, 如果安全, 则返回-1
// 否则返回x+y*9
long CXQGame::GetMyUnsafeKingPos(const CPoint &from, const CPoint &to)
{
    static CXQGame temp;
    memcpy( &temp, this, sizeof(temp));

    bool rtn = false;
    bool bSucc = ( temp.MovedAPiece_Client(from, to, char(temp.m_Side), char(0)) == 0);
    if(bSucc)
    {
        temp.m_Side = SideFlag( RED_SIDE + BLACK_SIDE - temp.m_Side);
        rtn = (temp.canKillRivalKing());
    }

    if(!rtn)
    {
        return -1;
    }

    CPoint retpoint;
    if(m_Side == RED_SIDE)
    {
        retpoint = m_piecePos[RED_KING_POS];
    }
    else
    {
        retpoint = m_piecePos[BLACK_KING_POS];
    }

    return (retpoint.y*9+retpoint.x);
}


std::vector<int> CXQGame::GetAllChessIndexWillbeKill()
{
    static CXQGame temp;
    memcpy( &temp, this, sizeof(temp));
    std::vector<int> pointVec;
    temp.m_Side = SideFlag( RED_SIDE + BLACK_SIDE - temp.m_Side);

    CPoint *pTo   = NULL;
    CPoint *pFrom = NULL;
    int nOff = 0;
    if(m_Side == RED_SIDE)
    {
        nOff = 0;
    }
    else
    {
        nOff = 16;
    }

    pFrom = temp.m_piecePos + (16 - nOff); 
    pTo   = temp.m_piecePos + nOff;


    for(int idfrome = 0; idfrome < 16; idfrome++)
    {
        if(pFrom[idfrome].x < 0)
            continue;
        CPoint from = pFrom[idfrome];        
        for(int i=0; i < 16; ++i)
        {
            if(pTo[i].x < 0)
                continue;
            if(temp.canMove(from, pTo[i]))
            {
                pointVec.push_back(i);
            }
        }
    }

    return pointVec;
}

std::vector<CPoint> CXQGame::GetNewestPointsWillbeKill(BOOL bMyTurn)
{
    std::vector<CPoint> retVec;
    if(m_nStepCount <= 0)
    {
        return retVec;
    }

    static CXQGame temp;
    memcpy( &temp, this, sizeof(temp));
    std::vector<CPoint> pointVec;
    temp.m_Side = SideFlag( RED_SIDE + BLACK_SIDE - temp.m_Side);

    CPoint *pTo   = NULL;
    CPoint *pFrom = NULL;
    int nOff = 0;
    if(m_Side == RED_SIDE)
    {
        nOff = 0;
    }
    else
    {
        nOff = 16;
    }

    pFrom = temp.m_piecePos + (16 - nOff); 
    pTo   = temp.m_piecePos + nOff;

 
    // 得到现在处于危险状态棋子的列表
    std::vector<int> chessIndexVec = GetAllChessIndexWillbeKill(); 
    static CXQGame xqGameTemp;

    // 得到上一步之前处于危险状态棋子的列表
    memcpy(&xqGameTemp, this, sizeof(xqGameTemp)); 

    if(bMyTurn && m_nStepCount >= 2)
    {
        xqGameTemp.retractmoves(2);
    }
    else if(!bMyTurn && m_nStepCount >= 1)
    {
        xqGameTemp.retractmoves(1);
    }
    else
    {
        return retVec;
    }

    std::vector<int> lastChessIndexVec;


    std::vector<int> NowKillerVec;  // 现在的攻击列表
    std::vector<int> LastKillerVec; // 前一步的攻击列表
    for(int destChessIndex = 0; destChessIndex < 16; destChessIndex++)
    {
        NowKillerVec.clear();
        NowKillerVec = GetKiller(destChessIndex);
        LastKillerVec.clear();
        LastKillerVec = xqGameTemp.GetKiller(destChessIndex);

        // 现在没受到攻击
        if(NowKillerVec.size() == 0)
        {
            continue;
        }
    
        
        //LOG_TRACE("[GetNewestPointsWillbeKill] destindex = " <<destChessIndex << " size1 = " << NowKillerVec.size() << ", size2 = " << LastKillerVec.size());

        // 两次受攻击类型完全相同
        if(VectorHasSameElement(NowKillerVec, LastKillerVec))
        {
            //LOG_TRACE("[GetNewestPointsWillbeKill] same element");
            continue;
        }
         //LOG_TRACE("[GetNewestPointsWillbeKill] not same element");
        lastChessIndexVec.push_back(destChessIndex);
    }

    for(int i = 0; i < lastChessIndexVec.size(); i++)
    {
        retVec.push_back(pTo[lastChessIndexVec[i] ]);
    }

    return retVec;



	int i, j;
    // 比较两次棋子列表的差异，就可以得到这一步引起的新的危险棋子
    for(i = 0; i < chessIndexVec.size(); i++)
    {
        for(j = 0; j < lastChessIndexVec.size(); j++)
        {
            if(chessIndexVec[i] == lastChessIndexVec[j])
                break;
        }

        // 新的处于危险状态的棋子
        if(j == lastChessIndexVec.size())
        {
            retVec.push_back(pTo[ chessIndexVec[i] ]);
        }
    }

    return retVec;
}


std::vector<int> CXQGame::GetKiller(int chessIndex)
{
    std::vector<int> retVec;
    if(chessIndex >= 16)
    {
        return retVec;
    }

    
    static CXQGame temp;
    memcpy( &temp, this, sizeof(temp));
    temp.m_Side = SideFlag( RED_SIDE + BLACK_SIDE - temp.m_Side);

    CPoint *pTo   = NULL;
    CPoint *pFrom = NULL;
    int nOff = 0;
    if(m_Side == RED_SIDE)
    {
        nOff = 0;
    }
    else
    {
        nOff = 16;
    }

    pFrom = temp.m_piecePos + (16 - nOff); 
    pTo   = temp.m_piecePos + nOff;

    if(pTo[chessIndex].x < 0)
    {
        return retVec;
    }


    for(int idfrome = 0; idfrome < 16; idfrome++)
    {
        if(pFrom[idfrome].x < 0)
            continue;
        CPoint from = pFrom[idfrome];        

        if(temp.canMove(from, pTo[chessIndex]))
        {
            retVec.push_back(idfrome);
        }
    }

   return retVec;
}

// 得到所有可能被对方吃掉的棋子
std::vector<CPoint> CXQGame::GetAllPointsWillbeKill()
{
    static CXQGame temp;
    memcpy( &temp, this, sizeof(temp));
    std::vector<CPoint> pointVec;
    temp.m_Side = SideFlag( RED_SIDE + BLACK_SIDE - temp.m_Side);

    CPoint *pTo   = NULL;
    CPoint *pFrom = NULL;
    int nOff = 0;
    if(m_Side == RED_SIDE)
    {
        nOff = 0;
    }
    else
    {
        nOff = 16;
    }

    pFrom = temp.m_piecePos + (16 - nOff); 
    pTo   = temp.m_piecePos + nOff;

    
    for(int idfrome = 0; idfrome < 16; idfrome++)
    {
        if(pFrom[idfrome].x < 0)
            continue;
        CPoint from = pFrom[idfrome];        
        for(int i=0; i < 16; ++i)
        {
             if(pTo[i].x < 0)
                continue;
             if(temp.canMove(from, pTo[i]))
             {
                pointVec.push_back(pTo[i]);
             }
        }
    }

    return pointVec;

}


// 从from出发能吃掉的所有棋
std::vector<CPoint> CXQGame::GetPointsWillbeKill(const CPoint& from)
{
    static CXQGame temp;
    memcpy( &temp, this, sizeof(temp));
    std::vector<CPoint> pointVec;
    temp.m_Side = SideFlag( RED_SIDE + BLACK_SIDE - temp.m_Side);
    
    CPoint *pTo = NULL;
    int nOff = 0;
    if(m_Side == RED_SIDE)
    {
        nOff = 0;
    }
    else
    {
        nOff = 16;
    }
    pTo = temp.m_piecePos + nOff;

    for(int i=0; i < 16; ++i)
    {
        if(pTo[i].x < 0)
            continue;
        if(temp.canMove(from, pTo[i]))
        {
            pointVec.push_back(pTo[i]);
        }
    }

    return pointVec;

}

bool CXQGame::WillBeInCheck(const CPoint &from, const CPoint &to)
{
#ifdef WIN32
	static CXQGame temp;
	memcpy( &temp, this, sizeof(temp));

	bool rtn = false;
	bool bSucc = ( temp.MovedAPiece_Client(from, to, char(temp.m_Side), char(0)) == 0);
	if(bSucc)
	{
		temp.m_Side = SideFlag( RED_SIDE + BLACK_SIDE - temp.m_Side);
		rtn = temp.canKillRivalKing();
	}

	return rtn;
#else
	return false;
#endif
}