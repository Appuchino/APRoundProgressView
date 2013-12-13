//
//  APRoundProgressGlareView.m
//  APRoundProgressIndicator
//
//  Created by Alexey Rashevskiy on 12/12/2013.
//  Copyright (c) 2013 Appuchino. All rights reserved.
//

#import "APRoundProgressGlareView.h"
#import "GlareView.h"
#import <CoreMotion/CoreMotion.h>

@implementation APRoundProgressGlareView
{
    APRoundProgressView *_progressView;
    GlareView *_glareView;
    CMMotionManager *_motionManager;
//    float rotation;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _progressView = [[APRoundProgressView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        _progressView.trackColor = [UIColor clearColor];
        [self addSubview:_progressView];
    }
    return self;
}

-(void)setRadius:(float)radius {
    _radius = radius;
    _progressView.radius = radius;
    if (_trackWidth) {
        [self updateGlareView];
    }
}

-(void)setTrackWidth:(float)trackWidth {
    _trackWidth = trackWidth;
    _progressView.trackWidth = trackWidth;
    if (_radius) {
        [self updateGlareView];
    }
}

-(void)setProgressWidth:(float)progressWidth {
    _progressWidth = progressWidth;
    _progressView.progressWidth = progressWidth;
}

-(void)setProgressColor:(UIColor *)progressColor {
    _progressColor = progressColor;
    _progressView.progressColor = progressColor;
}

-(void)setTrackColor:(UIColor *)trackColor {
    _trackColor = trackColor;
    _glareView.strokeColorLight = trackColor;
}

-(void)setStyle:(APRoundProgressStyle)style {
    _style = style;
    _progressView.style = style;
}

-(void)setLabel:(UILabel *)label {
    
}

-(void)setProgress:(float)progress {
    _progress = progress;
    _progressView.progress = progress;
}

-(void)updateGlareView
{
    if (!_glareView) {
        [_glareView removeFromSuperview];
        _glareView = nil;
    }
    _glareView = [[GlareView alloc] initWithFrame:_progressView.trackFrame];
    _glareView.strokeWidth = _trackWidth;
    _glareView.strokeColorLight = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [self addSubview:_glareView];
    [self sendSubviewToBack:_glareView];
}

-(void)setGyroAnimated:(BOOL)gyroAnimated {
    _gyroAnimated = gyroAnimated;
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    if([_motionManager isDeviceMotionAvailable])
    {
        if([_motionManager isDeviceMotionActive] == NO)
        {
            [_motionManager setDeviceMotionUpdateInterval:1/30];
            [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                                withHandler:^(CMDeviceMotion *deviceMotion, NSError *error)
             {
                 CMAttitude *attitude = deviceMotion.attitude;
                 _glareView.transform = CGAffineTransformMakeRotation(attitude.yaw + attitude.roll + attitude.pitch);
             }];
        }
    }
}

@end
