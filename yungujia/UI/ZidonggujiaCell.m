//
//  ZidonggujiaCell.m
//  yungujia
//
//  Created by Lee Justin on 12-9-6.
//
//

#import "ZidonggujiaCell.h"

@implementation ZidonggujiaCell

@synthesize loupan;
@synthesize xxdongxcengxx;
@synthesize date;
@synthesize xxrenhuijia;

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
