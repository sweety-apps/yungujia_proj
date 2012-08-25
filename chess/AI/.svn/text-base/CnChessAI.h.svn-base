/*
 *  CnChessAI.h
 *  yshGameHall
 *
 *  Created by Tony Zhang on 11/12/10.
 *  Copyright 2010 ysh. All rights reserved.
 *
 */

#include "MoveGenerator.h"
#include "NegaMaxEngine.h"
#include "CnChessAIdefine.h"
#include "CnChess_Protocol.h"
class CCnChessLogic;

class CCnChessAI {
public:
	//NSOperationQueue* operationQueue;
	CCnChessAI();
	~CCnChessAI();
	bool init(CCnChessLogic* cnChessLogic);
	//int whowin(); 
	bool restart();
	void NotifyComputerMove();
	void NotifyComputerMoveFunc(UserMoveChessRequest* stRequest);
	bool GetIsAiInThinking(){return m_bIsAiInThinking;}
private:
	BYTE m_ChessBoard[10][9];
	int m_BeforePos[10][9];
	int m_AfterPos[10][9];
	CMoveGenerator	*m_pMG;
	CEveluation		*m_pEvel;
	CNegaMaxEngine  *m_pSE;
	CCnChessLogic* m_CnChessLogic;
	bool m_bIsAiInThinking;
};