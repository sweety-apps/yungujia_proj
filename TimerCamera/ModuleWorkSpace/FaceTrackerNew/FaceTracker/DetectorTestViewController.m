//
//  DetectorTestViewController.m
//  FaceTracker
//
//  Created by lijinxin on 13-4-21.
//
//

#import <QuartzCore/QuartzCore.h>
#import "DetectorTestViewController.h"

@interface DetectorTestViewController ()

@end

@implementation DetectorTestViewController

@synthesize imageView = _imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _featureLayers = [[NSMutableArray array] retain];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    ReleaseAndNil(_featureLayers);
    ReleaseAndNilView(_imageView);
    [super dealloc];
}

#pragma mark Event Handler

- (IBAction)onChangeImage:(id)sender
{
    [[HumanFeatureDetector sharedInstance] cancelAsyncDetection];
    
    self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"fat_%d",_imageIndex]];
    
    _displayIndex = 0;
    
    [[HumanFeatureDetector sharedInstance] startAsyncDetection:self.imageView.image forDelegate:self];
    
    _imageIndex++;
    _imageIndex %= 14;
}

#pragma mark Test Rect Drawer

- (void)clearFeatureMarkedLayers
{
    // hide all the face layers
	for (CALayer *layer in _featureLayers)
    {
        [layer setHidden:YES];
	}
}

// Update face markers given vector of face rectangles
- (void)    displayFeature:(CGRect)featureRect
         markedBorderColor:(UIColor*)color
           layerStartIndex:(int)index
              resizeFactor:(float)resizeFactor
                    startX:(CGFloat)startX
                    startY:(CGFloat)startY;
{
    [CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    CGRect faceRect;
    faceRect.origin.x = featureRect.origin.x * resizeFactor + startX;
    faceRect.origin.y = featureRect.origin.y * resizeFactor + startY;
    faceRect.size.width = featureRect.size.width * resizeFactor;
    faceRect.size.height = featureRect.size.height * resizeFactor;
    
    CALayer *featureLayer = nil;
    
    if ([_featureLayers count] <= index)
    {
        // Create a new feature marker layer
        featureLayer = [[CALayer alloc] init];
        featureLayer.borderWidth = 3.0f;
        [_featureLayers addObject:featureLayer];
        [self.view.layer addSublayer:featureLayer];
        [featureLayer release];
    }
    
    featureLayer = [_featureLayers objectAtIndex:index];
    
    [featureLayer setHidden:NO];
    
    featureLayer.borderColor = [color CGColor];
    featureLayer.frame = faceRect;
    
    [CATransaction commit];
}

#pragma mark <HumanFeatureDetectorDelegate>

- (void)onDetectedFeature:(DetectedHumanFeatures*)feature
              forDetector:(HumanFeatureDetector*)detector
{
    CGAffineTransform t = CGAffineTransformIdentity;
    switch (feature.bodyOrientation)
    {
        case kBodyHeadUp:
            t = CGAffineTransformIdentity;
            break;
        case kBodyHeadLeft:
            t = CGAffineTransformRotate(t, 0.5 * M_PI);
            break;
        case kBodyHeadRight:
            t = CGAffineTransformRotate(t, M_PI);
            break;
        case kBodyHeadDown:
            t = CGAffineTransformRotate(t, -0.5 * M_PI);
            break;
            
        default:
            break;
    }
    
    _imageView.transform = t;
    [_imageView setNeedsDisplay];
    
    //compute size and resize factor
    CGRect rect = CGRectZero;
    rect.size = _imageView.image.size;
    CGSize imageViewSize = _imageView.frame.size;
    imageViewSize.height *= 2.0;
    imageViewSize.width *= 2.0;
    CGSize imageSize = rect.size;
    
    BOOL alignForWidth = YES;
    
    CGFloat imageX = 0.0;
    CGFloat imageY = 0.0;
    CGFloat imageFactor = 1.0;
    
    if (imageViewSize.width / imageViewSize.height > imageSize.width / imageSize.height)
    {
        alignForWidth = NO;
    }
    
    if (alignForWidth)
    {
        imageFactor = imageViewSize.width / imageSize.width;
        imageX = 0.0;
        if (imageSize.height * imageFactor > imageViewSize.height)
        {
            imageY = ((imageSize.height * imageFactor) - imageViewSize.height) * 0.5;
        }
        else
        {
            imageY = (imageViewSize.height - (imageSize.height * imageFactor)) * 0.5;
        }
    }
    else
    {
        imageFactor = imageViewSize.height / imageSize.height;
        if (imageSize.width * imageFactor > imageViewSize.width)
        {
            imageX = ((imageSize.width * imageFactor) - imageViewSize.width) * 0.5;
        }
        else
        {
            imageX = (imageViewSize.width - (imageSize.width * imageFactor)) * 0.5;
        }
        imageY = 0.0;
    }
    
    if (feature.currentDetectedFeature)
    {
        [self displayFeature:feature.currentDetectedFeature.rectToRawImageHeadUp
           markedBorderColor:[UIColor redColor]
             layerStartIndex:_displayIndex
                resizeFactor:imageFactor
                      startX:imageX
                      startY:imageY];
    }
    
    _displayIndex++;
}

- (void)onStarted:(HumanFeatureDetector*)detector
{
    [self clearFeatureMarkedLayers];
}

- (void)onCancelledWithFeature:(DetectedHumanFeatures*)feature
                   forDetector:(HumanFeatureDetector*)detector
{
    [self clearFeatureMarkedLayers];
}

- (void)onFinishedWithFeature:(DetectedHumanFeatures*)feature
                  forDetector:(HumanFeatureDetector*)detector
{
    
}

@end
