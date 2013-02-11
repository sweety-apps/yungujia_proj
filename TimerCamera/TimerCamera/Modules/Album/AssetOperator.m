//
//  AssetOperator.m
//  TimerCamera
//
//  Created by lijinxin on 13-2-3.
//
//

#include <stdlib.h>
#include <unistd.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>
#import "AssetOperator.h"
#import "ThumbNailManager.h"

@implementation AssetOperator

@synthesize operatorDelegate = _operatorDelegate;
@synthesize isGettingPhotos = _isGettingPhotos;

#pragma mark life cycle

- (id)init
{
    self = [super init];
    if (self) {
        //
        _preCropSize = CGSizeZero;
        _photoAssets = [[NSMutableArray array] retain];
    }
    return self;
}

- (void)dealloc
{
    ReleaseAndNil(_photoAssets);
    [super dealloc];
}

#pragma mark AssetOperator private Methods

- (void)onFinishedAssetEnumeration
{
    _isGettingPhotos = NO;
    
    if (_operatorDelegate)
    {
        [_operatorDelegate onGotPhotos:self];
    }
}

- (void)onFailedAssetEnumeration:(NSNumber*)reasonNum
{
    _isGettingPhotos = NO;
    
    if (_operatorDelegate)
    {
        [_operatorDelegate onFailedGetPhotos:self reason:[reasonNum intValue]];
    }
}

- (NSString*)getIdForRepresentation:(ALAssetRepresentation*)representation
{
    return [NSString stringWithFormat:@"%u",[[[representation url] absoluteString] hash]];
}

- (void)savePreCropThumbNail:(ALAsset*)result
{
    long long tt = [BaseUtilitiesFuncions getCurrentTimeInMicroSeconds];
    
    if (!CGSizeEqualToSize(_preCropSize, CGSizeZero))
    {
        NSAutoreleasePool *tmpPool = [[NSAutoreleasePool alloc] init];
        ALAssetRepresentation* representation = [result defaultRepresentation];
        UIImage* rawImage = nil;
        if (representation)
        {
            NSString* identify = [self getIdForRepresentation:representation];
            if (![[ThumbNailManager sharedInstance] getThumbNailForCropSize:_preCropSize
                                                                      andId:identify])
            {
                rawImage = [UIImage
                            imageWithCGImage:[representation fullResolutionImage]
                            scale:[representation scale]
                            orientation:[representation orientation]];
                if (rawImage)
                {
                    [[ThumbNailManager sharedInstance]
                     addThumbNailForImage:rawImage
                     withCropSize:_preCropSize
                     andId:identify
                     overwrite:NO];
                }
            }
        }
        
        [tmpPool release];
    }
    
    NSLog(@"[Save representation used] %llu microSecond", [BaseUtilitiesFuncions getCurrentTimeInMicroSeconds]- tt);
}

#pragma mark AssetOperator public Methods

- (void)setThumbNailPreCropSize:(CGSize)size
{
    _preCropSize = size;
}

- (void)getPhotos:(BOOL)onlyEditable
{
    if (_isGettingPhotos)
    {
        return;
    }
    _isGettingPhotos = YES;
    _onlyGetEditable = onlyEditable;
    [_photoAssets removeAllObjects];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
            NSLog(@"相册访问失败 =%@", [myerror localizedDescription]);
            AssetFailedType type = kAssetFiled_Other;
            if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound) {
                NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
                type = kAssetFiled_LocationOff;
            }else{
                NSLog(@"相册访问失败.");
                type = kAssetFiled_UserDenied;
            }
            
            [self performSelector:@selector(onFailedAssetEnumeration:)
                         onThread:[NSThread currentThread]
                       withObject:[NSNumber numberWithInt:type]
                    waitUntilDone:NO];
        };
        
        ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index, BOOL *stop){
            if (result!=NULL) {
                
                if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                    
                    BOOL isTarget = NO;
                    
                    if (_onlyGetEditable)
                    {
                        if (result.editable)
                        {
                            isTarget = YES;
                        }
                    }
                    else
                    {
                        isTarget = YES;
                    }
                    
                    if (isTarget)
                    {
                        [_photoAssets insertObject:result atIndex:0];
                        if (Enable_Clear_ThumbNail)
                        {
                            [self savePreCropThumbNail:result];
                        }
                    }
                    
                }
            }
            else
            {
                //_isGettingPhotos = NO;
            }
            
        };
        
        ALAssetsLibraryGroupsEnumerationResultsBlock
        libraryGroupsEnumeration = ^(ALAssetsGroup* group, BOOL* stop){
            
            if (group == nil)
            {
                [self performSelector:@selector(onFinishedAssetEnumeration)
                             onThread:[NSThread currentThread]
                           withObject:nil
                        waitUntilDone:NO];
                //[self myMethod:self._dataArray];
            }
            
            if (group!=nil) {
                NSString *g=[NSString stringWithFormat:@"%@",group];//获取相簿的组
                NSLog(@"gg:%@",g);//gg:ALAssetsGroup - Name:Camera Roll, Type:Saved Photos, Assets count:71
                /*这段代码 实际上也是有点多余的。
                 NSString *g1=[g substringFromIndex:16 ] ;
                 NSArray *arr=[[NSArray alloc] init];
                 arr=[g1 componentsSeparatedByString:@","];
                 NSString *g2=[[arr objectAtIndex:0] substringFromIndex:5];
                 if ([g2 isEqualToString:@"Camera Roll"]) {
                 g2=@"相机胶卷";
                 }
                 NSString *groupName=g2;//组的name
                 */
                [group enumerateAssetsUsingBlock:groupEnumerAtion];
            }
            //该段代码为块代码执行结束之后运行的部分。对于有刷新UI或者写入数据库的人来说也许是有必要的。
            /*else{
             dispatch_async(dispatch_get_global_queue(0,0),^{
             [self myMethod:self._dataArray];
             });
             }*/
        };
        
        ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
        [library enumerateGroupsWithTypes:ALAssetsGroupAll
                               usingBlock:libraryGroupsEnumeration
                             failureBlock:failureblock];
        // [library release];
        
        _isGettingPhotos = NO;
        
        [pool release];
    }); 
}

- (void)savePhoto:(UIImage*)image
{
    
}

- (int)photoCounts
{
    return [_photoAssets count];
}

- (UIImage*)photoAt:(int)index
       withCropSize:(CGSize)size
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    UIImage* img = [self rawPhotoAt:index];
    if (img)
    {
        img = [BaseUtilitiesFuncions scaleAndCropImage:img CropSize:size];
        [img retain];
    }
    [pool release];
    [img autorelease];
    return img;
}

- (UIImage*)photoRawThumbnailAt:(int)index
{
    ALAsset* asset = [_photoAssets objectAtIndex:index];
    if (asset)
    {
        return [UIImage imageWithCGImage:[asset thumbnail]];
    }
    return nil;
}

- (UIImage*)rawPhotoAt:(int)index
{
    ALAsset* asset = [_photoAssets objectAtIndex:index];
    if (asset)
    {
        ALAssetRepresentation* representation = [asset defaultRepresentation];
        if (representation)
        {
            return [UIImage imageWithCGImage:[representation fullResolutionImage]
                                       scale:[representation scale]
                                 orientation:[representation orientation]];
        }
        else
        {
            return [UIImage imageWithCGImage:asset.thumbnail];
        }
    }
    return nil;
}

- (UIImage*)photoPreCropedAt:(int)index
{
    ALAsset* asset = [_photoAssets objectAtIndex:index];
    if (asset)
    {
        if (Enable_Clear_ThumbNail)
        {
            ALAssetRepresentation* representation = [asset defaultRepresentation];
            NSString* key = [self getIdForRepresentation:representation];
            UIImage* ret = [[ThumbNailManager sharedInstance] getThumbNailForCropSize:_preCropSize andId:key];
            if (!ret)
            {
                [self savePreCropThumbNail:asset];
            }
            ret = [[ThumbNailManager sharedInstance] getThumbNailForCropSize:_preCropSize andId:key];
            return ret;
        }
        else
        {
            UIImage* image = [UIImage imageWithCGImage:[asset thumbnail]];
            image = [BaseUtilitiesFuncions scaleAndCropImage:image CropSize:_preCropSize];
            return image;
        }
    }
    return nil;
}

@end
