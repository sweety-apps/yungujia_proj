//
//  LoupanCell.m
//  yungujia
//
//  Created by Justin Lee on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoupanCell.h"

@implementation LoupanCell

@synthesize xxhuayuan = _xxhuayuan;
@synthesize xxdiduan = _xxdiduan;
@synthesize gongxxdongxxhu = _gongxxdongxxhu;
@synthesize danjia = _danjia;
@synthesize xxminei = _xxminei;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
