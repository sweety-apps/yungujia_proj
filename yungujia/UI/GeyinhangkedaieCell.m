//
//  GeyinhangkedaieCell.m
//  yungujia
//
//  Created by lijinxin on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GeyinhangkedaieCell.h"

@implementation GeyinhangkedaieCell

@synthesize icon = _icon;
@synthesize xxyinhang = _xxyinhang;
@synthesize kedai = _kedai;
@synthesize jingzhi = _jingzhi;

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
