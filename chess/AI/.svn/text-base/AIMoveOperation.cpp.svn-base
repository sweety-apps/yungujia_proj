//
//  AIMoveOperation.mm
//  yshGameHall
//
//  Created by Tony Zhang on 11/18/10.
//  Copyright 2010 ysh. All rights reserved.
//

/*
#import "AIMoveOperation.h"
#import "CnChessAI.h"


@implementation AIMoveOperation

- (id)initWithAi:(CCnChessAI*)_ai {
	if (self = [self init]) {
		ai = _ai;
		return self;
	}
	return nil;
}

- (void)dealloc {
	ai = nil;
	[super dealloc];
}


- (void)main {
	if (![self isCancelled]) {
		ai->NotifyComputerMoveFunc();
	}
}
@end
*/

#include "AIMoveOperation.h"
#include "CnChessAI.h"
#include "CnChess_Protocol.h"
using namespace std;

#define nil 0
AIMoveOperation::AIMoveOperation(CCnChessAI* _ai)
{
	ai = _ai;
}

AIMoveOperation::~AIMoveOperation()
{
	ai = nil;
}

void AIMoveOperation::main()
{
	UserMoveChessRequest stRequest;
	if (!this) {
		ai->NotifyComputerMoveFunc(&stRequest);
	}
}
