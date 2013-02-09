//
//  ImagePickerView.m
//  TimerCamera
//
//  Created by lijinxin on 13-2-3.
//
//

#import "ImagePickerView.h"

#define NUMBER_OF_ITEMS (IS_IPAD? 19: 12)
#define NUMBER_OF_VISIBLE_ITEMS (IS_IPAD? 19: 12)
#define ITEM_SPACING 150
#define INCLUDE_PLACEHOLDERS YES

@implementation ImagePickerView

@synthesize target = _target;
@synthesize pickerDelegate = _pickerDelegate;

@synthesize imageViewSize = _imageViewSize;
@synthesize imageViewUseBounds = _imageViewUseBounds;


#pragma mark life-cycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect rect = frame;
        rect.origin = CGPointZero;
        
        _carouselView = [[iCarousel alloc] initWithFrame:rect];
        _carouselView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _carouselView.type = iCarouselTypeWheel;
        _carouselView.delegate = self;
        _carouselView.dataSource = self;
        
        //add carousel to view
        [self addSubview:_carouselView];
        
        self.backgroundColor = [UIColor clearColor];
        //self.backgroundColor = [UIColor grayColor];
        _imageViewSize = CGSizeZero;
        _imageViewUseBounds = NO;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    ReleaseAndNilView(_carouselView);
    ReleaseAndNil(_target);
    [super dealloc];
}

#pragma mark ImagePickerView methods

- (id)initWithFrame:(CGRect)frame
          andTarget:(id<IImagePickerTarget>)target
        andDelegate:(id<ImagePickerViewDelegate>)pickerDelegate
{
    self = [self initWithFrame:frame];
    if (self)
    {
        self.target = target;
        self.pickerDelegate = pickerDelegate;
    }
    return self;
}

+ (ImagePickerView*)imagePickerWitWithFrame:(CGRect)frame
                                  andTarget:(id<IImagePickerTarget>)target
                                andDelegate:(id<ImagePickerViewDelegate>)pickerDelegate
{
    return [[[ImagePickerView alloc] initWithFrame:frame
                                         andTarget:target
                                       andDelegate:pickerDelegate]
            autorelease];
}

- (void)reloadData
{
    [_carouselView reloadData];
}

#pragma mark methods override

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    if (_target)
    {
        return [_target getImageCount];
    }
    return 0;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    //limit the number of items views loaded concurrently (for performance reasons)
    return NUMBER_OF_VISIBLE_ITEMS;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    if (_target)
    {
        ImagePickerViewCell* cell = (ImagePickerViewCell*)view;
        
        //create new view if no view is available for recycling
        if (cell == nil)
        {
            cell = [[ImagePickerViewCell alloc] initWithFrame:CGRectZero];
        }
        
        {
            UIImage* image = [_target getImageAtIndex:index];
            CGRect rect = CGRectZero;
            if (CGSizeEqualToSize(_imageViewSize, CGSizeZero))
            {
                rect.size = image.size;
                if (IS_RETINA)
                {
                    rect.size.width *= 0.5;
                    rect.size.height *= 0.5;
                }
            }
            else
            {
                rect.size = _imageViewSize;
            }
            
            cell.frame = rect;
            cell.imageView.image = image;
            if (_imageViewUseBounds)
            {
            }
            //set label
            cell.label.text = [_target getImageTitleAtIndex:index];
        }
        
        view = cell;
    }
    return view;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
	//note: placeholder views are only displayed if wrapping is disabled
	return INCLUDE_PLACEHOLDERS? 2: 0;
}

- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
	//create new view if no view is available for recycling
	if (view == nil)
	{
		view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)] autorelease];
        view.backgroundColor = [UIColor clearColor];
	}
	
	return view;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    //slightly wider than item view
    return ITEM_SPACING;
}

- (CGFloat)carousel:(iCarousel *)carousel itemAlphaForOffset:(CGFloat)offset
{
	//set opacity based on distance from camera
    return 1.0f - fminf(fmaxf(offset, 0.0f), 1.0f);
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * _carouselView.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    //wrap all carousels
    return YES;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    if (_pickerDelegate && _target)
    {
        UIImage* rawImage = [_target getRawImageAtIndex:index];
        if (rawImage)
        {
            [_pickerDelegate onPickedImage:rawImage forView:self];
        }
    }
}

@end
