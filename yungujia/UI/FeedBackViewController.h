//
//  FeedBackViewController.h
//  yungujia
//
//  Created by 波 徐 on 12-7-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedBackViewController : UIViewController
<UITextViewDelegate>
{
    UITextView* textEdit;
    UILabel* wordLeftLabel;
}
@property (nonatomic,retain) IBOutlet UITextView* textEdit;
@property (nonatomic,retain) IBOutlet UILabel* wordLeftLabel;
@end
