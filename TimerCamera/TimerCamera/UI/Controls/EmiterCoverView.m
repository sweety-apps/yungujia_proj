//
//  EmiterCoverView.m
//  TimerCamera
//
//  Created by lijinxin on 13-1-26.
//
//

#import "EmiterCoverView.h"

@implementation EmiterCoverView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [_coverLayer removeFromSuperlayer];
    ReleaseAndNil(_coverLayer);
    [_emitter removeFromSuperlayer];
    ReleaseAndNil(_emitter);
    [super dealloc];
}

#pragma mark Inner methods

#define PurpleColor() [UIColor colorWithRed:(77.0/255.0) green:(0.0) blue:(126.0/255.0) alpha:1.0]
#define AllColor() [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]

- (void)initEmiter:(CGRect)rect emitterImage:(UIImage*)image
{
    _emitter = [[CAEmitterLayer layer] retain];
    
    //_emitter.position = CGPointMake(rect.size.width,0);
    CGSize tsize = rect.size;
    tsize.width *= 0.2;
    tsize.height *= 0.8;
    _emitter.emitterPosition = CGPointMake(rect.origin.x + rect.size.width * 0.5,
                                           rect.origin.y + rect.size.height * 0.5);
    _emitter.emitterSize = tsize;
    
    // Spawn points for the hearts are within the area defined by the button frame
    _emitter.emitterMode = kCAEmitterLayerVolume;
    _emitter.emitterShape = kCAEmitterLayerRectangle;
    _emitter.renderMode = kCAEmitterLayerAdditive;
    
    // Configure the emitter cell
    CAEmitterCell *heart = [CAEmitterCell emitterCell];
    heart.name = @"heart";
    
    //heart.emissionLongitude = 0;//M_PI * 7.0 / 4.0;//M_PI * 3.0 /2.0; // up
    heart.emissionRange = 2.0 * M_PI;  // in a wide spread
    heart.birthRate		= 0.0;			// emitter is deactivated for now
    heart.lifetime		= 1.0;			// hearts vanish after 10 seconds
    
    heart.velocity		= 300;			// particles get fired up fast
    //heart.velocityRange = 60;			// with some variation
    heart.yAcceleration = -175;			// but fall eventually
    //heart.xAcceleration = 20;
    
    heart.contents		= (id) [image CGImage];
    heart.color			= [AllColor() CGColor];
    heart.redRange		= 1.0;			// some variation in the color
    heart.blueRange		= 1.0;
    heart.greenRange    = 1.0;
    heart.alphaSpeed	= -1.0 / heart.lifetime;  // fade over the lifetime
    
    heart.scale			= 0.04;			// let them start small
    heart.scaleSpeed	= 0.96 / heart.lifetime;    // but then 'explode' in size
    heart.spin			= 2.0 * M_PI;
    heart.spinRange		= 2.0 * M_PI;	// and send them spinning from -180 to +180 deg/s
    
    // Add everything to our backing layer
    _emitter.emitterCells = [NSArray arrayWithObject:heart];
    
    [self.layer addSublayer:_emitter];
}

- (void)initCoverLayer:(CGRect)rect withColor:(UIColor*)color
{
    _coverLayer = [[CALayer layer] retain];
    _coverLayer.bounds = rect;
    _coverLayer.position = CGPointMake(rect.origin.x + (rect.size.width * 0.5), rect.origin.y + (rect.size.height * 0.5));
    _coverLayer.hidden = YES;
    _coverLayer.backgroundColor = [color CGColor];
    
    [self.layer addSublayer:_coverLayer];
    [_coverLayer setNeedsDisplay];
}

- (void)doAnimations
{
    CABasicAnimation *heartsBurst = [CABasicAnimation animationWithKeyPath:@"emitterCells.heart.birthRate"];
	heartsBurst.fromValue		= [NSNumber numberWithFloat:600.0];
	heartsBurst.toValue			= [NSNumber numberWithFloat:  0.0];
	heartsBurst.duration		= 0.4;
	heartsBurst.timingFunction	= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [_emitter addAnimation:heartsBurst forKey:@"heartsBurst"];
}

#pragma mark EmiterCoverView methods

-     (id)initWithFrame:(CGRect)frame
 forEmitterElementImage:(UIImage*)image
          andCoverColor:(UIColor*)color
{
    self = [super initWithFrame:frame];
    {
        CGRect rect = frame;
        rect.origin = CGPointZero;
        
        [self initCoverLayer:rect withColor:color];
        [self initEmiter:rect emitterImage:image];
        
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
    }
    return self;
}

+ (EmiterCoverView*)emiterCoverViewWithElementImage:(UIImage*)image
                                      andCoverColor:(UIColor*)color
{
    return [[[EmiterCoverView alloc] initWithFrame:CGRectZero
                            forEmitterElementImage:image
                                     andCoverColor:color]
            autorelease];
}

- (void)setFrame:(CGRect)frame
{
    if (_emitter)
    {
        CGRect rect = frame;
        rect.origin = CGPointZero;
        //_emitter.position = CGPointMake(rect.size.width,0);
        CGSize tsize = rect.size;
        tsize.width = 1;
        tsize.height *= 0.8;
        _emitter.emitterPosition = CGPointMake(rect.origin.x + rect.size.width * 0.5,
                                               rect.origin.y + rect.size.height * 0.5);
        _emitter.emitterSize = tsize;
    }
    [super setFrame:frame];
}

- (void)performEmitterOverViewWithCompletionForTarget:(id)target
                                  andCompletionMethod:(SEL)sel
{
    _completionTarget = [target retain];
    _completionSel = sel;
    
    self.hidden = NO;
    [self doAnimations];
}


#pragma mark NSObject (CAAnimationDelegate)

- (void)animationDidStart:(CAAnimation *)anim
{
    //[super animationDidStart:anim];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //[super animationDidStop:anim finished:flag];
    //self.hidden = YES;
    _coverLayer.hidden = YES;
    [_coverLayer removeAnimationForKey:@"groupAnima"];
    if (_completionTarget)
    {
        id target = _completionTarget;
        SEL sel = _completionSel;
        [target performSelector:sel];
        ReleaseAndNil(target);
        sel = nil;
    }
    
}


@end
