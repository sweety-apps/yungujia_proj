//
//  DetectorTestViewController.h
//  FaceTracker
//
//  Created by lijinxin on 13-4-21.
//
//

#import <UIKit/UIKit.h>
#import "HumanFeatureDetector.h"

@interface DetectorTestViewController : UIViewController <HumanFeatureDetectorDelegate>
{
    UIImageView* _imageView;
    UILabel* _statusLabel;
    NSMutableArray* _featureLayers;
    int _imageIndex;
    int _displayIndex;
}

@property (nonatomic,retain) IBOutlet UIImageView* imageView;
@property (nonatomic,retain) IBOutlet UILabel* statusLabel;

- (IBAction)onChangeImage:(id)sender;
- (IBAction)onStatusDebug:(id)sender;

@end
