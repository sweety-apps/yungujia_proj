//
//  AssetImagePickerTarget.h
//  TimerCamera
//
//  Created by lijinxin on 13-2-3.
//
//

#import <Foundation/Foundation.h>
#import "BaseImagePickerTarget.h"
#import "AssetOperator.h"

#define kDefaultAssetTargetImageSize CGSizeMake(360,360)

@class AssetImagePickerTarget;

@protocol AssetImagePickerTargetDelegate <NSObject>

- (void)onLoadAssetSucceed:(AssetImagePickerTarget*)target;
- (void)onLoadAssetFailed:(AssetImagePickerTarget*)target
                   reason:(AssetFailedType)reasonType;

@end

@interface AssetImagePickerTarget : BaseImagePickerTarget <AssetOperatorDelegate>
{
    AssetOperator* _assetOperator;
    id<AssetImagePickerTargetDelegate> _delegate;
    BOOL _operatorSucceed;
}

@property (nonatomic, assign) id<AssetImagePickerTargetDelegate> delegate;

- (id)initWithDelegate:(id<AssetImagePickerTargetDelegate>)delegate;

@end
