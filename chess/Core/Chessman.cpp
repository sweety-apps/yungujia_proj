//
//  Chessman.m
//  yshGameChess
//
//  Created by Tony Zhang on 10/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
/*
#import "Chessman.h"



@implementation Chessman

@synthesize posX, posY, chessmanType, chessmanImageView;




- (id)initWithX:(int)_posX WithY:(int)_posY WithType:(PIECETYPE)_chessmanType {
	self.posX = _posX;
	self.posY = _posY;
	self.chessmanType = _chessmanType;
	
	NSString *picPath;
	if (RED_B == chessmanType) {
		picPath = @"bing_r.png";
	}
	else if (RED_P == chessmanType){
		picPath = @"pao_r.png";
	}
	else if (RED_J == chessmanType){
		picPath = @"ju_r.png";
	}
	else if (RED_M == chessmanType){
		picPath = @"horse_r.png";
	}
	else if (RED_X == chessmanType){
		picPath = @"xiang_r.png";
	}
	else if (RED_S == chessmanType){
		picPath = @"shi_r.png";
	}
	else if (RED_K == chessmanType){
		picPath = @"king_r.png";
	}
	else if (BLACK_B == chessmanType) {
		picPath = @"bing_b.png";
	}
	else if (BLACK_P == chessmanType){
		picPath = @"pao_b.png";
	}
	else if (BLACK_J == chessmanType){
		picPath = @"ju_b.png";
	}
	else if (BLACK_M == chessmanType){
		picPath = @"horse_b.png";
	}
	else if (BLACK_X == chessmanType){
		picPath = @"xiang_b.png";
	}
	else if (BLACK_S == chessmanType){
		picPath = @"shi_b.png";
	}
	else{
		picPath = @"king_b.png";
	}
	chessmanImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:picPath]];
	chessmanImageView.frame = CGRectMake(0, 0, imageSize, imageSize);
    return self;
}


- (void)dealloc {
	[chessmanImageView release];
    [super dealloc];
}


@end
*/

#include "Chessman.h"

Chessman::Chessman(int _posX,int _posY,PIECETYPE _chessmanType)
{
	posX = _posX;
	posY = _posY;
	chessmanType = _chessmanType;
/* //³õÊ¼»¯Í¼Æ¬
	NSString *picPath;
	if (RED_B == chessmanType) {
		picPath = @"bing_r.png";
	}
	else if (RED_P == chessmanType){
		picPath = @"pao_r.png";
	}
	else if (RED_J == chessmanType){
		picPath = @"ju_r.png";
	}
	else if (RED_M == chessmanType){
		picPath = @"horse_r.png";
	}
	else if (RED_X == chessmanType){
		picPath = @"xiang_r.png";
	}
	else if (RED_S == chessmanType){
		picPath = @"shi_r.png";
	}
	else if (RED_K == chessmanType){
		picPath = @"king_r.png";
	}
	else if (BLACK_B == chessmanType) {
		picPath = @"bing_b.png";
	}
	else if (BLACK_P == chessmanType){
		picPath = @"pao_b.png";
	}
	else if (BLACK_J == chessmanType){
		picPath = @"ju_b.png";
	}
	else if (BLACK_M == chessmanType){
		picPath = @"horse_b.png";
	}
	else if (BLACK_X == chessmanType){
		picPath = @"xiang_b.png";
	}
	else if (BLACK_S == chessmanType){
		picPath = @"shi_b.png";
	}
	else{
		picPath = @"king_b.png";
	}
	chessmanImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:picPath]];
	chessmanImageView.frame = CGRectMake(0, 0, imageSize, imageSize);
*/
}

Chessman::~Chessman()
{

}