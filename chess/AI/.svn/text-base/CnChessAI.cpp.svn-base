/*
 *  CnChessAI.cpp
 *  yshGameHall
 *
 *  Created by Tony Zhang on 11/12/10.
 *  Copyright 2010 ysh. All rights reserved.
 *
 */
	
#include <iostream>
#include "CnChessAI.h"
#include "CnChessLogic.h"
#include "AIMoveOperation.h"
#include "CnChess_define.h"
#include "CnChess_Protocol.h"	
#define nil 0
int hashTable[17] = {8, 12, 13, 10, 9, 11, 14, 
					-1,  0, -1, 
					 1,  5,  6,  3, 2,  4,  7};


CCnChessAI::CCnChessAI()
{
	m_pMG = nil;
	m_pEvel = nil;
	m_pSE = nil;
	m_bIsAiInThinking = false;
}

CCnChessAI::~CCnChessAI()
{
	if (m_pMG) {
		delete m_pMG;
		m_pMG = nil;
	}
	if (m_pEvel) {
		delete m_pEvel;
		m_pEvel = nil;
	}
	if (m_pSE) {
		delete m_pSE;
		m_pSE = nil;
	}
}

bool CCnChessAI::init(CCnChessLogic* cnChessLogic)
{
	m_CnChessLogic = cnChessLogic;
	
	m_pSE = new CNegaMaxEngine;
	
	m_pMG = new CMoveGenerator;
	
	m_pEvel = new CEveluation;
	
	if (!m_pEvel || !m_pMG || !m_pEvel) {
		if (m_pEvel) {
			delete m_pEvel;
			m_pEvel = 0;
		}
		if (m_pMG) {
			delete m_pMG;
			m_pMG = 0;
		}
		if (m_pSE) {
			delete m_pSE;
			m_pSE = 0;
		}
		return false;
	}
	
	m_pSE->SetSearchDepth(3);
	
	m_pSE->SetMoveGenerator(m_pMG);
	
	m_pSE->SetEveluator(m_pEvel);
	
	return true;
}


/*int CCnChessAI::whowin() 
{
	for (int i = 0; i < 10; i++) {
		for (int j = 0; j < 9; j++) {
			m_ChessBoard[i][j] = hashTable[m_CnChessLogic->m_XQGame.m_chessmap[9 - i][8 - j]];
		}
	}
	
	bool redKingAlive = false;
	bool blackKingAlive = false;
	for (int i = 0; i < 10; i++) {
		for (int j = 0; j < 9; j++) {
			if (R_KING == m_ChessBoard[i][j])
				redKingAlive = true;
			if (B_KING == m_ChessBoard[i][j]) {
				blackKingAlive = true;
			}
		}
	}
	
	if (redKingAlive && !blackKingAlive) {
		return 1;
	}
	else if (!redKingAlive && blackKingAlive){
		return 2;
	}
	else {
		return 0;
	}
}*/

bool CCnChessAI::restart() 
{
	//m_CnChessLogic->m_XQGame.InitGame(0);
	return true;
}

void CCnChessAI::NotifyComputerMove()
{
	m_bIsAiInThinking = true;
	AIMoveOperation *aOpt = new AIMoveOperation(this);
}

void CCnChessAI::NotifyComputerMoveFunc(UserMoveChessRequest* stRequest)
{
	for (int i = 0; i < 10; i++) {
		for (int j = 0; j < 9; j++) {
			int index = m_CnChessLogic->m_XQGame.m_chessmap[9 - i][8 - j];
			if (index == -1) {
				m_ChessBoard[i][j] = m_BeforePos[9 - i][8 - j] = NOCHESS;
			}
			else {
				m_ChessBoard[i][j] = m_BeforePos[9 - i][8 - j] = hashTable[pieceType[index]];
			}
		}
	}
	
	m_pSE->SearchAGoodMove(m_ChessBoard);
	//cout << "after: \n";
	for (int i = 0; i < 10; i++) {
		for (int j = 0; j < 9; j++) {
			m_AfterPos[9 - i][8 - j] = m_ChessBoard[i][j];
			//cout << m_AfterPos[9 - i][8 - j] << " ";
		}
		//cout << endl;
	}
	
	CPoint from, to;
	
	for (int i = 0; i < 10; i++) {
		for (int j = 0; j < 9; j++) {
			if (m_AfterPos[i][j] != m_BeforePos[i][j])
			{
				if (NOCHESS != m_BeforePos[i][j] && NOCHESS == m_AfterPos[i][j]) {
					from.x = j;
					from.y = i;
				}
				else {
					to.x = j;
					to.y = i;
				}
			}
		}
	}

	//UserMoveChessRequest stRequest;
	stRequest->cType = CMD_DLL_REQ_MOVE;
	stRequest->side = 1;
	stRequest->fromx = from.x;
	stRequest->fromy = from.y;
	stRequest->tox = to.x;
	stRequest->toy = to.y;
	stRequest->bCheck = char(0);
	m_CnChessLogic->isNeedMainThread = true;
	//m_CnChessLogic->OnSvrRespMovedAPiece(&stRequest);
	m_CnChessLogic->isNeedMainThread = false;
	m_bIsAiInThinking = false;
}
