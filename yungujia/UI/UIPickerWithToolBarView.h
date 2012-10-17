//
//  UIPickerWithToolBarView.h
//  yungujia
//
//  Created by Lee Justin on 12-10-17.
//
//

#import <UIKit/UIKit.h>

@class UIPickerWithToolBarView;

@protocol UIPickerWithToolBarViewDelegate <UIPickerViewDelegate>
@optional
-(void)onPushedToolBarDoneButton:(UIPickerWithToolBarView*)pickerView;

@end

@interface UIPickerWithToolBarView : UIPickerView
{
    UIToolbar* _toolBar;
    UIBarButtonItem* _doneButton;
}

@property (nonatomic,retain) IBOutlet UIToolbar* toolBar;
@property (nonatomic,retain) IBOutlet UIBarButtonItem* doneButton;

@end
