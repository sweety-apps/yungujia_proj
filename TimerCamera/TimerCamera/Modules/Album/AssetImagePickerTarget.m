//
//  AssetImagePickerTarget.m
//  TimerCamera
//
//  Created by lijinxin on 13-2-3.
//
//

#import "AssetImagePickerTarget.h"

@implementation AssetImagePickerTarget

@synthesize delegate = _delegate;

#pragma mark life-cycle

- (id)init
{
    self = [super init];
    if (self)
    {
        _assetOperator = [[AssetOperator alloc] init];
        _assetOperator.operatorDelegate = self;
        //[_assetOperator setThumbNailPreCropSize:kDefaultAssetTargetImageSize];
        [_assetOperator getPhotos:NO];
    }
    return self;
}

- (void)dealloc
{
    ReleaseAndNil(_assetOperator);
    [super dealloc];
}

#pragma mark AssetImagePickerTarget public methods

- (id)initWithDelegate:(id<AssetImagePickerTargetDelegate>)delegate
{
    self = [self init];
    if (self)
    {
        self.delegate = delegate;
    }
    return self;
}

#pragma mark AssetImagePickerTarget private methods


#pragma mark <AssetOperatorDelegate>

- (void)onGotPhotos:(AssetOperator*)operatorObject
{
    _operatorSucceed = YES;
    if (_delegate)
    {
        [_delegate onLoadAssetSucceed:self];
    }
}

- (void)onFailedGetPhotos:(AssetOperator*)operatorObject
                   reason:(AssetFailedType)reasonType
{
    if (_delegate)
    {
        [_delegate onLoadAssetFailed:self reason:reasonType];
    }
}


#pragma mark <IImagePickerTarget>

- (int)getImageCount
{
    if (_operatorSucceed)
    {
        return [_assetOperator photoCounts];
    }
    return 0;
}

- (UIImage*)getImageAtIndex:(int)index
{
    if (_operatorSucceed)
    {
        return [_assetOperator photoRawThumbnailAt:index];
    }
    return nil;
}

- (NSString*)getImageTitleAtIndex:(int)index
{
    return @"";
}

- (UIImage*)getRawImageAtIndex:(int)index
{
    if (_operatorSucceed)
    {
        return [_assetOperator rawPhotoAt:index];
    }
    return nil;
}

- (BOOL)insertImageAtIndex:(int)index
{
    return NO;
}

- (BOOL)removeImageAtIndex:(int)index
{
    return NO;
}

@end
