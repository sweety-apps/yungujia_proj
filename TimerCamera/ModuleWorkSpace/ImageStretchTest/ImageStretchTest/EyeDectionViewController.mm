//
//  EyeDectionViewController.m
//  ImageStretchTest
//
//  Created by lijinxin on 13-3-29.
//  Copyright (c) 2013年 Lee Justin. All rights reserved.
//

#import "EyeDectionViewController.h"
#import <opencv.hpp>
#import <opencv2/highgui/cap_ios.h>

using namespace cv;

static CascadeClassifier cascade;
#define kHaarcascadeFileName @"haarcascade_eyes.xml"

void detecteyes( IplImage *img );

//int X;

//IplImage *resframe=0;

int main( int argc, char** argv ){
    CvCapture *capture;
    IplImage *frame;
    int key;
    char *filename = ;
    
    
    
    // IplImage *bframe=0;
    
    
    /* load the classifier
     note that I put the file in the same directory with
     this code */
    // bframe = cvLoadImage("PICTURE.jpg",CV_LOAD_IMAGE_COLOR);
    
    
    
    /* setup memory buffer; needed by the face detector */
    storage = cvCreateMemStorage( 0 );
    
    
    /* initialize camera */
    capture = cvCaptureFromCAM(0);
    /* always check */
    assert(cascade && storage && capture );
    
    
    /* create a window */
    cvNamedWindow( "video", 1 );
    
    
    
    while( key != 'q' ) {
        /* get a frame */
        frame = cvQueryFrame( capture );
        /* always check */
        // if( !frame ) break;
        /* 'fix' frame */
        // cvFlip( frame, frame, 1 );
        // frame->origin = 0;
        /* detect faces and display video */
        detecteyes(frame);
        
        /* quit if user press 'q' */
        key = cvWaitKey( 50 );
    }
    /* free memory */
    cvReleaseImage(&frame);
    cvReleaseCapture( &capture );
    cvDestroyWindow( "video" );
    
    cvReleaseHaarClassifierCascade( &cascade );
    
    cvReleaseMemStorage( &storage );
    return 0;
}

void detecteyes(IplImage* img)
{
    int i,x;
    x=0;
    
    CvSeq *eyes = cvHaarDetectObjects(
                                      img,
                                      cascade,
                                      storage,
                                      1.1,
                                      3,
                                      0,
                                      cvSize(10,10)
                                      
                                      
                                      );
    
    for( i=0; i < (eyes ? eyes->total : 0) ; i++){
        
        CvRect *r = ( CvRect* )cvGetSeqElem( eyes, i );
        
        cvRectangle( img,
                    
                    cvPoint( r->x, r->y),
                    cvPoint( r->x + r->width, r->y + r->height ),
                    CV_RGB(255, 0, 0), 1, 8, 0);
        
        x=x+1;
        printf("eyes detected %d",x);
    }
    cvShowImage( "video", img );
}






@interface EyeDectionViewController (opencvCamera) <CvVideoCameraDelegate>

@property (retain,nonatomic) CvVideoCamera* videoCamera;

@end

@implementation EyeDectionViewController

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
	// Do any additional setup after loading the view.
    CGRect rect = self.view.frame;
    rect.origin = CGPointZero;
    _imageView = [[UIImageView alloc] initWithFrame:rect];
    _imageView.contentMode = UIViewContentModeTopLeft;
    [self.view addSubview:_imageView];
    
    cascade.load([kHaarcascadeFileName UTF8String]);
    
    self.videoCamera = nil;
    CvVideoCamera* _tvideoCamera = [[CvVideoCamera alloc] initWithParentView:_imageView];
    self.videoCamera = _tvideoCamera;
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    self.videoCamera.defaultFPS = 30;
    self.videoCamera.delegate = self;
    self.videoCamera.grayscaleMode = NO;
    
    [self.videoCamera start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.videoCamera = nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [self.videoCamera adjustLayoutToInterfaceOrientation:toInterfaceOrientation];
    return YES;
}

#pragma mark - Protocol CvVideoCameraDelegate

#ifdef __cplusplus
- (void)processImage:(Mat&)image;
{
    std::vector<cv::Rect> faces;
    cascade.detectMultiScale(image, faces, 1.1, 3, 0, cv::Size(60, 60));

//    // Do some OpenCV stuff with the image
//    Mat image_copy;
//    cvtColor(image, image_copy, CV_BGRA2BGR);
//    
//    // invert image
//    bitwise_not(image_copy, image_copy);
//    cvtColor(image_copy, image, CV_BGR2BGRA);
}
#endif

#pragma mark - property re-defines

- (CvVideoCamera *)videoCamera
{
    return (CvVideoCamera *)_cvObject;
}

- (void)setVideoCamera:(CvVideoCamera *)videoCamera
{
    [videoCamera retain];
    [_cvObject release];
    _cvObject = videoCamera;
}

@end
