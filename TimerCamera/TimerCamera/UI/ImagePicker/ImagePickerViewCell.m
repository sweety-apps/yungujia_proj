//
//  ImagePickerViewCell.m
//  TimerCamera
//
//  Created by lijinxin on 13-2-5.
//
//

#import <QuartzCore/QuartzCore.h>
#import "ImagePickerViewCell.h"

@implementation ImagePickerViewCell

@synthesize imageView = _imageView;
@synthesize label = _label;
@synthesize coverImage = _coverImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect rect = frame;
        rect.origin = CGPointZero;
        //alloc subviews
        _imageView = [[UIImageView alloc] initWithFrame:rect];
        _coverImage = [[UIImageView alloc] initWithFrame:rect];
        _label = [[UILabel alloc] initWithFrame:rect];
        _label.backgroundColor = [UIColor clearColor];
        //add subviews
        [self addSubview:_imageView];
        [self addSubview:_coverImage];
        [self addSubview:_label];
    }
    return self;
}

- (void)dealloc
{
    ReleaseAndNilView(_coverImage);
    ReleaseAndNilView(_label);
    ReleaseAndNilView(_imageView);
    [super dealloc];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGRect rect = frame;
    rect.origin = CGPointZero;
    _imageView.frame = rect;
    _label.frame = rect;
    _coverImage.frame = rect;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
