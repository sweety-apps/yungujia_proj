// XQGame.h: interface for the CXQGame class.
//
//////////////////////////////////////////////////////////////////////

#ifndef _AFX_XQGAME_H__1B7BDDC6_E7D2_4614_97B5_43B0409E1303__INCLUDED_
#define _AFX_XQGAME_H__1B7BDDC6_E7D2_4614_97B5_43B0409E1303__INCLUDED_

#include <vector>
#include "CnChess_define.h"
#include "CnChess_Protocol.h"
#include "common.h"


//#include "resource.h"       // 主符号

//#include "CnChessLogic_h.h"
//#include "_INotifyEvents_CP.H"
//#include <map>
//#include <atlctl.h> // IObjectSafetyImpl
//#include "xqgame.h"
//#include "NetComm/NetServer.h"
//#include "SDLogger.h"
//#include "CnChessReplay.h"



#ifdef LOGGER
#include "SDLogger.h"
#endif

#define BLACK_LOSS 11
#define RED_LOSS   1

enum SideFlag
{
	RED_SIDE   = 0,		//红方
	BLACK_SIDE = 1
};

enum PIECETYPE			// 棋子的类型，影响到其移动规则
{
	RED_K   = 0,		//红帅
	RED_S   = 1,		//仕
	RED_X   = 2,		//相
	RED_M   = 3,		//马
	RED_J   = 4,		//车
	RED_P   = 5,		//炮
	RED_B   = 6,		//兵

	PIECE_NONE = 8,		//非象棋子，
	COMPARE_X = 8,		//非象棋子，作比较用

	BLACK_K = 10,		//黑将
	BLACK_S = 11,		//士
	BLACK_X = 12,		//象
	BLACK_M = 13,		//马
	BLACK_J = 14,		//车
	BLACK_P = 15,		//炮
	BLACK_B = 16,		//卒
};

#define XIANGQI_MAXNUM_PIECE 32			// 共32个子
const int redSideRange[2]={0,16};		// 红子16个，[0,16)
const int blackSideRange[2]={16,32};	// 黑子16个，[16,32)

#define RED_KING_POS 4
#define BLACK_KING_POS 27
const PIECETYPE pieceType[32] = {	RED_J  , RED_M  , RED_X  ,   RED_S, RED_K  , RED_S  , RED_X  , RED_M  , RED_J  ,
RED_P  , RED_P  ,
RED_B  , RED_B  , RED_B  , RED_B  , RED_B  ,
BLACK_B, BLACK_B, BLACK_B, BLACK_B, BLACK_B,
BLACK_P, BLACK_P,
BLACK_J, BLACK_M, BLACK_X, BLACK_S, BLACK_K, BLACK_S, BLACK_X, BLACK_M, BLACK_J};

//                              车 马 相 仕 帅 仕 相 马 车 炮 炮 卒 卒 卒 卒 卒 兵 兵 兵 兵 兵 炮 炮 车 马 象 士 将 士 象 马 车
const int _defaultPos[2][32] = {{0, 1, 2, 3, 4, 5, 6, 7, 8, 1, 7, 0, 2, 4, 6, 8, 0, 2, 4, 6, 8, 1, 7, 0, 1, 2, 3, 4, 5, 6, 7, 8},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 3, 3, 3, 3, 3, 6, 6, 6, 6, 6, 7, 7, 9, 9, 9, 9, 9, 9, 9, 9, 9}};
// 注意：默认按照这个顺序，则红子在上，黑子在下
// 为简化逻辑，红方、黑方、服务器的矩阵保持一致，仅红方显示的时候将棋盘旋转即可


#define NO_CHESS -1

#define STEP_BUFF_LENGTH 512
#define STEP_RECORD_LENGTH 512


class CXQGame  
{
     //friend class CCnChessReplay;
	friend class CCnChessAI;
public:
	CXQGame();
	~CXQGame();
	
	void InitGame(int nSideFlag);	// 0表示RED_SIDE；1表示BLACK_SIDE；
	
	bool canMove(const CPoint &from, const CPoint &to);				// （我）能否移动一颗子

	int MovedAPiece_Client(const CPoint &from, const CPoint &to, const char nSide, const char bCheck);	// 客户端移动一颗子。nSide：0，红方的子；1：黑方
	int MovedAPiece_Svr(const CPoint &from, const CPoint &to, const char nSide, char &bCheck);	// 服务器记录移动一颗子。nSide：0，红方的子；1：黑方

	bool RetractMoves(int n);											// 悔棋
	int  GetPieceIndex(const CPoint &point) const
	{
#ifdef LOGGER
		LOG_DEBUG("[CnChess]:GetPieceIndex(), point ("<<point.x<<", "<<point.y<<")");
#endif
		return m_chessmap[point.y][point.x];
	}
	
	GAMESTATE GetGameState() { return m_GameState;}
	
	CPoint GetPiecePosition(int nIndex)
	{
		return m_piecePos[nIndex];
	}
	bool IsMyPiece(CPoint point)
	{
		return CheckPieceSide(point, m_Side);
	}
	bool IsRivalPiece(CPoint point)
	{
		SideFlag side = SideFlag(RED_SIDE + BLACK_SIDE - m_Side);
		return CheckPieceSide(point, side);
	}

	int CheckViolation(const CPoint &from, const CPoint &to, BOOL bWarn = TRUE);					// 判断是否违例：对将、长将

	bool PrintAllPiecesPos(int side, ChessStep *stepArr, int stepCount, char *pBuff, int len);
	void SetGameOver()
	{
		m_GameState = GAME_OVER;
	}

	// 强制同步状态用
	int GetStepArrMaxLen();
	void GetGameData(char *pPosArr, ChessStep *pStepArr);
	void SetGameData(char *pPosArr, ChessStep *pStepArr, int nStepCount);
	char *GetCompleteDescribeOfCurPos();

	int GetStepCount()
	{
		return m_nStepCount;
	}
	char* GetDescribeStr()
	{
		return m_DescribeStr;
	}
	//vector<int> GetDescribeVec()
	//{
	//	return m_DescribeVec;
	//}
	const ChessStep *GetChessStepRecord()
	{
		return m_ChessStepRecord;
	}
	int GetChessStepRecordLength()
	{
		return (m_nStepCount < STEP_RECORD_LENGTH) ? m_nStepCount : STEP_RECORD_LENGTH;
	}

	vector<CPoint> GetPointsWillbeKill(const CPoint& from);
    vector<CPoint> GetAllPointsWillbeKill();
    vector<int>    GetAllChessIndexWillbeKill();
    vector<CPoint> GetNewestPointsWillbeKill(BOOL bMyTurn); // 得到最近的可能被吃掉的子


    vector<int>  GetKiller(int chessIndex); // 得到能吃掉编号为chessIndex的所有子序号


    SideFlag GetMySide()
    {
        return m_Side;
    }
	SideFlag SwitchMySide()
    {
        if (RED_SIDE == m_Side) {
			m_Side = BLACK_SIDE;
		}
		else {
			m_Side = RED_SIDE;
		}
		return m_Side;
    }
    bool ShouldShowWarning(const CPoint &from, const CPoint &to);
    long GetMyUnsafeKingPos(const CPoint &from, const CPoint &to);
    bool ShouldDraw(); // 是否应该作和
   	int m_chessmap[10][9];	// 棋盘；红在上，黑在下（即黑方的视角）。初始化为NO_CHESS，值为棋子在piecePos对应的顺序

	bool canKillRivalKing();	// 对方是否被将军
private:
	bool CheckPieceSide(const CPoint &point, SideFlag side) const
	{
		PIECETYPE type = GetChessTypeFromPoint(point);
		return ((side == RED_SIDE && type < COMPARE_X) || (side == BLACK_SIDE && type > COMPARE_X));
	}

private:
	void FillChessMap(int _map[10][9], CPoint manpoint[32]);
	int  MoveAPiece(const CPoint &from, const CPoint &to, const char nSide, const char bCheck);			// 移动一颗子

	bool IsValidPos(const CPoint &from, const CPoint &to);	// 简单判断此处的棋子在棋盘上的移动是否合乎规则（如：仕只能在 X 上）


	bool WillKingsMeet(const CPoint &from, const CPoint &to);				// 是否对将
	bool IsLoopCycle(const CPoint &from, const CPoint &to);					// 是否长将违例
    bool IsLoopCheck(const CPoint& from, const CPoint& to);
	bool WillBeInCheck(const CPoint &from, const CPoint &to);				// 是否会造成被将
    bool IsLoopSnatch(const CPoint& from, const CPoint &to);                // 是否为长捉


    bool canKillChess(const CPoint& to);

    bool retractmoves(int n);

	char *GetTermDescr(int side, int step, int nMan, int fromX, int fromY, int toX, int toY);

	PIECETYPE GetChessTypeFromPoint(const CPoint &point) const
	{
		int i = GetPieceIndex(point);
		return (i<0) ? PIECE_NONE : pieceType[i];
	}

	void ResetChessMap(int _map[10][9])			// 将棋盘恢复到无子的状态
	{
		for(int i=0; i<10; ++i)
			for(int j=0; j<9; ++j)
				_map[i][j] = NO_CHESS;
	}

private:
	ChessStep& GetNthStep(int n)
	{
		return m_ChessStepBuff[n % STEP_BUFF_LENGTH];
	}
	void RecordCurrentStep()
	{
		if(m_nStepCount <= STEP_RECORD_LENGTH)
		{
			m_ChessStepRecord[m_nStepCount - 1] = GetNthStep(m_nStepCount - 1);
		}
	}

private:
	bool m_bMyTurn;			// 是否轮到我
	SideFlag m_Side;		// 我的颜色
	GAMESTATE m_GameState;	// 游戏的状态

	CPoint m_piecePos[32];	// 由_defaultPos[2][32]初始化，指明对应的棋子在chessmap中的位置。若x坐标为-1，表示已被吃掉
							// 需要额外关注的帅、将分别为m_piecePos[4]、m_piecePos[27]

	ChessStep m_ChessStepBuff[STEP_BUFF_LENGTH];		// 记录之前的32步棋（供悔棋用）
	ChessStep m_ChessStepRecord[STEP_RECORD_LENGTH];	// 记录最早的512步棋（供打谱用，超过了512步的则不再记录）
	int m_nStepCount;				// 记录走了多少步棋；红黑各走一步，算2步，对应于m_ChessStepBuff[]
	char m_DescribeStr[256];		// 对每步棋（走棋、悔棋）的描述字符串
	//vector<int> m_DescribeVec;
#ifdef LOGGER
	DECL_LOGGER
#endif
};

#endif // _AFX_XQGAME_H__1B7BDDC6_E7D2_4614_97B5_43B0409E1303__INCLUDED_
