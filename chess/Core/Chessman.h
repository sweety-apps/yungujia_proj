//
//  Chessman.h
//  yshGameChess
//
//  Created by Tony Zhang on 10/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

/*
#import <UIKit/UIKit.h>
#include "xqgame.h"

const int imageSize = 71;

@interface Chessman : NSObject {
	PIECETYPE chessmanType;
	int posX;
	int posY;
	UIImageView *chessmanImageView;
}

@property (nonatomic) int posX;
@property (nonatomic) int posY;
@property (nonatomic) PIECETYPE chessmanType;
@property (nonatomic, retain) UIImageView *chessmanImageView;

- (id)initWithX:(int)_posX WithY:(int)_posY WithType:(PIECETYPE)_chessmanType;

@end
*/

#include "xqgame.h"

class UIImageView;
const int imageSize = 71;
class Chessman {
	PIECETYPE chessmanType;
	int posX;
	int posY;
	UIImageView *chessmanImageView;
	Chessman(int _posX,int _posY,PIECETYPE _chessmanType);
	~Chessman();
};