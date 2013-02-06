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
@synthesize grayCover = _grayCover;
@synthesize selectedBtn = _selectedBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageBorderWidth = 0.0;
        CGRect rect = frame;
        rect.origin = CGPointZero;
        //alloc subviews
        _imageView = [[UIImageView alloc] initWithFrame:rect];
        _grayCover = [[UIImageView alloc] initWithFrame:rect];
        _grayCover.backgroundColor = [UIColor clearColor];
        _label = [[UILabel alloc] initWithFrame:rect];
        _label.backgroundColor = [UIColor clearColor];
        _selectedBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        //add subviews
        [self addSubview:_imageView];
        [self addSubview:_grayCover];
        [self addSubview:_label];
        [self addSubview:_selectedBtn];
    }
    return self;
}

- (void)dealloc
{
    ReleaseAndNilView(_selectedBtn);
    ReleaseAndNilView(_grayCover);
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
    _grayCover.frame = rect;
    _selectedBtn.frame = rect;
}

-(void)setImageBorderWidth:(float)imageBorderWidth
{
    _imageBorderWidth = imageBorderWidth;
    if (_imageBorderWidth > 0.0)
    {
        _imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _imageView.layer.borderWidth = _imageBorderWidth;
    }
    else
    {
        _imageView.layer.borderColor = [[UIColor clearColor] CGColor];
        _imageView.layer.borderWidth = 0.0;
    }
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
