//
//  YinhangkedaieDetailCell.m
//  yungujia
//
//  Created by Lee Justin on 12-8-14.
//
//

#import "YinhangkedaieDetailCell.h"

@implementation YinhangkedaieDetailCell

@synthesize lblTitle = _lblTitle;
@synthesize lblValue = _lblValue;
@synthesize lblSubValue = _lblSubValue;
@synthesize seg = _seg;

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
