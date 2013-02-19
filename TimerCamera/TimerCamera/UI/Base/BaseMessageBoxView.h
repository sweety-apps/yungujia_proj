//
//  BaseMessageBoxView.h
//  TimerCamera
//
//  Created by lijinxin on 13-2-19.
//
//

#import <UIKit/UIKit.h>
#import "CommonAnimationButton.h"

@class BaseMessageBoxView;

@protocol BaseMessageBoxViewDelegate <NSObject>

- (void)onYesButtonPressedForMessageBox:(BaseMessageBoxView*)messageBox;
- (void)onNoButtonPressedForMessageBox:(BaseMessageBoxView*)messageBox;
- (void)onTextButtonPressedAt:(int)index
                forMessageBox:(BaseMessageBoxView*)messageBox;

@end


@interface BaseMessageBoxView : UIView
{
    UIView* _bgView;
    UIColor* _bgColor;
    UIImageView* _boxBgImage;
    CommonAnimationButton* _yesButton;
    CommonAnimationButton* _noButton;
    NSMutableArray* _textButtons;
    NSArray* _textButtonTexts;
    UILabel* _titleLbl;
    NSString* _title;
    UILabel* _contentLbl;
    NSString* _content;
    UIView* _extraView;
    id<BaseMessageBoxViewDelegate> _messageBoxDelegate;
}

@property (nonatomic,retain) NSArray* textButtonTexts;
@property (nonatomic,retain) NSString* title;
@property (nonatomic,retain) NSString* content;
@property (nonatomic,retain) UIView* extraView;
@property (nonatomic,assign) id<BaseMessageBoxViewDelegate> messageBoxDelegate;

+ (BaseMessageBoxView*)baseMessageBoxWithBgView:(UIView*)bgImg
                                      orBgColor:(UIColor*)bgColor
                                     boxBgImage:(UIImage*)boxBgImage
                                 yesButtonImage:(UIImage*)yesImage
                          yesButtonPressedImage:(UIImage*)yesPressed
                                  noButtonImage:(UIImage*)noImage
                           noButtonPressedImage:(UIImage*)noPressed
                                textButtonImage:(UIImage*)textImage
                         textButtonPressedImage:(UIImage*)textPressed
                                          title:(NSString*)title
                                        content:(NSString*)content
                                      extraView:(UIView*)extraView
                                textButtonTexts:(NSArray*)textBtnTexts
                                   withDelegate:(id<BaseMessageBoxViewDelegate>) messageBoxDelegate;

- (id)      initWithBgView:(UIView*)bgImg
                 orBgColor:(UIColor*)bgColor
                boxBgImage:(UIImage*)boxBgImage
            yesButtonImage:(UIImage*)yesImage
     yesButtonPressedImage:(UIImage*)yesPressed
             noButtonImage:(UIImage*)noImage
      noButtonPressedImage:(UIImage*)noPressed
           textButtonImage:(UIImage*)textImage
    textButtonPressedImage:(UIImage*)textPressed
                     title:(NSString*)title
                   content:(NSString*)content
                 extraView:(UIView*)extraView
           textButtonTexts:(NSArray*)textBtnTexts
              withDelegate:(id<BaseMessageBoxViewDelegate>) messageBoxDelegate;


- (void)showOnWindowWithYesButtonShowed:(BOOL)showYes
                         noButtonShowed:(BOOL)showNO;

- (void)showOnView:(UIView*)view
   yesButtonShowed:(BOOL)showYes
    noButtonShowed:(BOOL)showNO;

@end
