//
//  HuijiaLV1Cell.m
//  yungujia
//
//  Created by lijinxin on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HuijiaLV1Cell.h"

@implementation HuijiaLV1Cell

@synthesize xxhuayuan = _xxhuayuan;
@synthesize xdongxcengxxx = _xdongxcengxxx;
@synthesize date = _date;
@synthesize result = _result;

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
