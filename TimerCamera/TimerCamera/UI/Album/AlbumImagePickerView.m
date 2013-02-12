//
//  AlbumImagePickerView.m
//  TimerCamera
//
//  Created by lijinxin on 13-2-8.
//
//

#import "AlbumImagePickerView.h"
#import "AlbumImagePickerViewCell.h"

#define kBGColor()  [UIColor colorWithRed:(140.0/255.0) green:(200.0/255.0) blue:(0.0/255.0) alpha:1.0]
#define kNotifyTextColor() [UIColor colorWithRed:(77.0/255.0) green:(0.0/255.0) blue:(126.0/255.0) alpha:1.0]

#define NUMBER_OF_ITEMS (IS_IPAD? 19: 12)
#define NUMBER_OF_VISIBLE_ITEMS (IS_IPAD? 19: 12)
#define ITEM_SPACING 150
#define INCLUDE_PLACEHOLDERS YES

#define kCatHandStartPosition CGPointMake(320,370)
#define kCatHandStayPosition CGPointMake(110,180)

@implementation AlbumImagePickerView

#pragma mark life-cycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
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
    ReleaseAndNilView(_noImageNotifyLbl);
    ReleaseAndNilView(_menuBtn);
    ReleaseAndNilView(_editorBtn);
    ReleaseAndNilView(_cameraBtn);
    ReleaseAndNil(_borderImage);
    ReleaseAndNil(_selectedImage);
    [super dealloc];
}

#pragma mark ImagePickerView methods

-       (id)initWithFrame:(CGRect)frame
                andTarget:(id<IImagePickerTarget>)target
              andDelegate:(id<ImagePickerViewDelegate>)pickerDelegate
             cameraButton:(CommonAnimationButton*)cameraBtn
             editorButton:(CommonAnimationButton*)editorBtn
               menuButton:(CommonAnimationButton*)menuBtn
         imageBorderImage:(UIImage*)borderImg
 imageBorderSelectedImage:(UIImage*)borderSelectedImg
{
    self = [super initWithFrame:frame
                      andTarget:target
                    andDelegate:pickerDelegate];
    if (self)
    {
        self.backgroundColor = kBGColor();
        _cameraBtn = [cameraBtn retain];
        _editorBtn = [editorBtn retain];
        _menuBtn = [menuBtn retain];
        
        [self addSubview:_cameraBtn];
        [self addSubview:_editorBtn];
        [self addSubview:_menuBtn];
        
        _noImageNotifyLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height * 0.5 - 100, frame.size.width, 200)];
        _noImageNotifyLbl.backgroundColor = [UIColor clearColor];
        _noImageNotifyLbl.textColor = kNotifyTextColor();
        _noImageNotifyLbl.font = [UIFont systemFontOfSize:36.0];
        _noImageNotifyLbl.textAlignment = UITextAlignmentCenter;
        [self insertSubview:_noImageNotifyLbl belowSubview:_carouselView];
        
        _borderImage = [borderImg retain];
        _selectedImage = [borderSelectedImg retain];
        
        [self resetSubviewFrames];
    }
    return self;
}

+ (AlbumImagePickerView*)albumImagePickerWitWithFrame:(CGRect)frame
                                            andTarget:(id<IImagePickerTarget>)target
                                          andDelegate:(id<ImagePickerViewDelegate>)pickerDelegate
                                         cameraButton:(CommonAnimationButton*)cameraBtn
                                         editorButton:(CommonAnimationButton*)editorBtn
                                           menuButton:(CommonAnimationButton*)menuBtn
                                     imageBorderImage:(UIImage*)borderImg
                             imageBorderSelectedImage:(UIImage*)borderSelectedImg
{
    return [[[AlbumImagePickerView alloc] initWithFrame:frame
                                              andTarget:target
                                            andDelegate:pickerDelegate
                                           cameraButton:cameraBtn
                                           editorButton:editorBtn
                                             menuButton:menuBtn
                                       imageBorderImage:borderImg
                               imageBorderSelectedImage:borderSelectedImg]
            autorelease];
}

- (void)doSelectedCellAnimation:(int)index
                   catHandImage:(UIImage*)catHand
                       endBlock:(void (^)(void))block
{
    [_carouselView scrollToItemAtIndex:index
                              animated:YES];
    AlbumImagePickerViewCell* cell = (AlbumImagePickerViewCell*)[_carouselView itemViewAtIndex:index];
    
    UIImageView* catHandView = [[[UIImageView alloc]
                             initWithImage:catHand] autorelease];
    
    CGRect rectCatHandStart = catHandView.frame;
    rectCatHandStart.origin = kCatHandStartPosition;
    CGRect rectCatHandStay = catHandView.frame;
    rectCatHandStay.origin = kCatHandStayPosition;
    CGRect rectCatHandStay2 = rectCatHandStay;
    rectCatHandStay2.origin.y += 1;
    CGRect rectCatHandEnd = rectCatHandStay;
    rectCatHandEnd.origin.y += self.frame.size.height;
    
    catHandView.frame = rectCatHandStart;
    [self addSubview:catHandView];
    
    CGRect rect = cell.containerView.frame;
    CGRect rectRaw = rect;
    rect.origin.y += self.frame.size.height;
    
    [UIView animateWithDuration:0.15 animations:^(){
        catHandView.frame = rectCatHandStay;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.1 animations:^(){
            catHandView.frame = rectCatHandStay2;
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.2
                             animations:^(){
                                 catHandView.frame = rectCatHandEnd;
                                 cell.containerView.frame = rect;
                             }
                             completion:^(BOOL finished){
                                 [catHandView removeFromSuperview];
                                 cell.containerView.frame = rectRaw;
                                 if (block)
                                 {
                                     block();
                                 }
                             }];
        }];
    }];
}

- (void)reloadData
{
    [_carouselView reloadData];
    [self performSelector:@selector(doFakeScrollEffect)
               withObject:nil afterDelay:0.2];
}

- (void)doFakeScrollEffect
{
    if ([_target getImageCount] > 0)
    {
        int startIndex = [_target getImageCount];
        startIndex = startIndex > 20 ? 10 : (startIndex / 2 - 1);
        [_carouselView scrollToItemAtIndex:startIndex
                                  animated:NO];
        [_carouselView scrollToItemAtIndex:0
                                  animated:YES];
    }
}

#pragma mark methods override

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self resetSubviewFrames];
}

#pragma mark AlbumImagePickerView private methods

#pragma mark Other Methods

- (void)resetSubviewFrames
{
    CGRect rect = CGRectZero;
    CGPoint offset = CGPointZero;
    
    //menu
    rect = _menuBtn.frame;
    offset.x = (self.frame.size.width - _menuBtn.frame.size.width) * 0.5;
    offset.y = self.frame.size.height - rect.size.height;
    rect.origin = offset;
    _menuBtn.frame = rect;
    
    //cameraBtn
    rect = _cameraBtn.frame;
    offset.x = 0;
    offset.y = 0;
    rect.origin = offset;
    _cameraBtn.frame = rect;
    
    //editorBtn
    rect = _editorBtn.frame;
    offset.x = self.frame.size.width - _editorBtn.frame.size.width;
    offset.y = 0;
    rect.origin = offset;
    _editorBtn.frame = rect;
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    NSUInteger count = 0;
    if (_target)
    {
        count = [_target getImageCount];
    }
    
    if (count == 0)
    {
        _noImageNotifyLbl.text = LString(@"No Photo");
    }
    else
    {
        _noImageNotifyLbl.text = @"";
    }
    
    return count;
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
            cell.coverImage.image = _borderImage;
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
            [_pickerDelegate onPickedImage:rawImage atIndex:index forView:self];
        }
    }
}

@end
