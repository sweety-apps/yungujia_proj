//
//  AssetOperator.h
//  TimerCamera
//
//  Created by lijinxin on 13-2-3.
//
//

#import <Foundation/Foundation.h>

#define Enable_Clear_ThumbNail (0)

@class AssetOperator;

typedef enum eAssetFailedType
{
    kAssetFiled_UserDenied = 1,
    kAssetFiled_LocationOff = 2,
    kAssetFiled_Other = 3,
} AssetFailedType;

@protocol AssetOperatorDelegate <NSObject>

- (void)onGotPhotos:(AssetOperator*)operatorObject;
- (void)onFailedGetPhotos:(AssetOperator*)operatorObject
                   reason:(AssetFailedType)reasonType;

@end

@interface AssetOperator : NSObject
{
    id<AssetOperatorDelegate> _operatorDelegate;
    NSMutableArray* _photoAssets;
    BOOL _isGettingPhotos;
    BOOL _onlyGetEditable;
    CGSize _preCropSize;
}

@property (nonatomic, assign) id<AssetOperatorDelegate> operatorDelegate;
@property (nonatomic, readonly, assign) BOOL isGettingPhotos;

- (void)setThumbNailPreCropSize:(CGSize)size;
- (void)getPhotos:(BOOL)onlyEditable;
- (void)savePhoto:(UIImage*)image;

- (int)photoCounts;
- (UIImage*)photoAt:(int)index
       withCropSize:(CGSize)size;
- (UIImage*)photoRawThumbnailAt:(int)index;
- (UIImage*)rawPhotoAt:(int)index;
- (UIImage*)photoPreCropedAt:(int)index;

@end
