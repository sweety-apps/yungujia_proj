//
//  MessageBoxView.h
//  TimerCamera
//
//  Created by lijinxin on 13-2-19.
//
//

#import <UIKit/UIKit.h>
#import "BaseMessageBoxView.h"

@interface MessageBoxView : BaseMessageBoxView
{
    
}

+ (MessageBoxView*)showWithYesNoButtonForTitle:(NSString*)title
                                       content:(NSString*)content
                                  withDelegate:(id<BaseMessageBoxViewDelegate>) messageBoxDelegate;

+ (MessageBoxView*)showWithOnlyNoButtonForTitle:(NSString*)title
                                        content:(NSString*)content
                                   withDelegate:(id<BaseMessageBoxViewDelegate>) messageBoxDelegate;

+ (MessageBoxView*)showWithOnlyYesButtonForTitle:(NSString*)title
                                         content:(NSString*)content
                                    withDelegate:(id<BaseMessageBoxViewDelegate>) messageBoxDelegate;

+ (MessageBoxView*)showWithYesButtonForTitle:(NSString*)title
                                     content:(NSString*)content
                                withDelegate:(id<BaseMessageBoxViewDelegate>) messageBoxDelegate
                          andTextButtonTexts:(NSString*)first,...;

+ (MessageBoxView*)showWithNoButtonForTitle:(NSString*)title
                                    content:(NSString*)content
                               withDelegate:(id<BaseMessageBoxViewDelegate>) messageBoxDelegate
                         andTextButtonTexts:(NSString*)first,...;

+ (MessageBoxView*)showWithOnlyTextButtonForTitle:(NSString*)title
                                          content:(NSString*)content
                                     withDelegate:(id<BaseMessageBoxViewDelegate>) messageBoxDelegate
                               andTextButtonTexts:(NSString*)first,...;


@end
