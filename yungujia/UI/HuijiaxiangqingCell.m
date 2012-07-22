//
//  HuijiaxiangqingCell.m
//  yungujia
//
//  Created by lijinxin on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HuijiaxiangqingCell.h"

@implementation HuijiaxiangqingCell

@synthesize icon = _icon;
@synthesize xxpinggu = _xxpinggu;
@synthesize danjia = _danjia;
@synthesize zongjia = _zongjia;
@synthesize time = _time;

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
