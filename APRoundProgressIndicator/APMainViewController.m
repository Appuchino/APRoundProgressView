//
// Created by Alexey Rashevskiy on 03/09/2013.
// Copyright (c) 2013 Appuchino. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "APMainViewController.h"
#import "APRoundProgressView.h"
#import "APRoundProgressGlareView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreMotion/CoreMotion.h>
#import "GlareView.h"

#define FRAME_RATE 0.033

@implementation APMainViewController
{
    float _currentProgressValue;
    NSTimer *_progressTimer;
    APRoundProgressGlareView *_progressView;
    UIProgressView *_standardProgressView;
    UISlider *_slider;
    UISwitch *_timerSwitch;
    UILabel *_label;
    CMMotionManager *_motionManager;
}

- (void)loadView
{
    [super loadView];

    self.view.backgroundColor = [UIColor colorWithRed:0.310 green:0.812 blue:0.776 alpha:1];
    _progressView = [[APRoundProgressGlareView alloc] initWithFrame:CGRectMake(0, 200, CGRectGetWidth(self.view.frame),
            250)];
    _progressView.trackWidth = 4.0;
    _progressView.progressWidth = 4.0;
    _progressView.radius = 60.0;
    _progressView.progressColor = [UIColor blueColor];
    _progressView.style = APRoundProgressStyleCenter;
    _progressView.gyroAnimated = YES;
    [self.view addSubview:_progressView];

    _standardProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    _standardProgressView.frame = CGRectMake(10, 70, 300, 40);

    _slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 100, 300, 40)];
    _slider.minimumValue = 0.0;
    _slider.maximumValue = 1.0;
    [_slider addTarget:self action:@selector(sliderMoved:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_slider];

    _timerSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(20, 30, 120, 30)];
    _timerSwitch.on = NO;
    [_timerSwitch addTarget:self action:@selector(switchSwitched:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_timerSwitch];



    [self.view addSubview:_standardProgressView];
    
    [self addGyroLogging];

}

- (void)increaseProgress
{
    float totalProgressTime = 15;
    float tickInProgress = FRAME_RATE/totalProgressTime;
    _currentProgressValue+=tickInProgress;
    if (_currentProgressValue > 1)
        _currentProgressValue = 0;
    _progressView.progress = _currentProgressValue;
    [_standardProgressView setProgress:_currentProgressValue animated:NO];
}

- (void)sliderMoved:(id)sender
{
    _progressView.progress = _slider.value;
    _standardProgressView.progress = _slider.value;
    _currentProgressValue = _slider.value;
}

- (void)switchSwitched:(id)sender
{
    if (_timerSwitch.on == YES)
    {
        _progressTimer = [NSTimer scheduledTimerWithTimeInterval:FRAME_RATE
                                                          target:self
                                                        selector:@selector(increaseProgress)
                                                        userInfo:nil
                                                         repeats:YES];

    }
    else
    {
        [_progressTimer invalidate];
        _progressTimer = nil;
    }
}

-(void)addGyroLogging {
    
        _motionManager = [[CMMotionManager alloc] init];
    UILabel *xLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 400, 80, 30)];
    xLabel.textColor = [UIColor whiteColor];
    xLabel.font = [UIFont systemFontOfSize:14];
    xLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:xLabel];
    
    UILabel *yLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 400, 80, 30)];
    yLabel.textColor = [UIColor whiteColor];
    yLabel.font = [UIFont systemFontOfSize:14];
    yLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:yLabel];
    
    UILabel *zLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 400, 80, 30)];
    zLabel.textColor = [UIColor whiteColor];
    zLabel.font = [UIFont systemFontOfSize:14];
    zLabel.backgroundColor = [UIColor clearColor];
    
    
    [self.view addSubview:zLabel];
    
        //Gyroscope
        if([_motionManager isDeviceMotionAvailable])
        {
            /* Start the gyroscope if it is not active already */
            if([_motionManager isDeviceMotionActive] == NO)
            {
                /* Update us 2 times a second */
                [_motionManager setDeviceMotionUpdateInterval:0.1];
                
                /* Add on a handler block object */
                CMDeviceMotion *deviceMotion = _motionManager.deviceMotion;
                CMAttitude *attitude = deviceMotion.attitude;
                CMAttitude *referenceAttitude = attitude;
                /* Receive the gyroscope data on this block */
                [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                            withHandler:^(CMDeviceMotion *deviceMotion, NSError *error)
                 {
                     GLfloat rotMatrix[16];
                     CMAttitude *attitude = deviceMotion.attitude;
                     if (referenceAttitude != nil)
                         [attitude multiplyByInverseOfAttitude:referenceAttitude];
                     CMRotationMatrix rot=attitude.rotationMatrix;
                     rotMatrix[0]=rot.m11; rotMatrix[1]=rot.m21; rotMatrix[2]=rot.m31;  rotMatrix[3]=0;
                     rotMatrix[4]=rot.m12; rotMatrix[5]=rot.m22; rotMatrix[6]=rot.m32;  rotMatrix[7]=0;
                     rotMatrix[8]=rot.m13; rotMatrix[9]=rot.m23; rotMatrix[10]=rot.m33; rotMatrix[11]=0;
                     rotMatrix[12]=0;      rotMatrix[13]=0;      rotMatrix[14]=0;       rotMatrix[15]=1;
                     
                     NSString *x = [[NSString alloc] initWithFormat:@"%.02f",attitude.yaw];
                     xLabel.text = [NSString stringWithFormat:@"X: %@", x];
                     
                     NSString *y = [[NSString alloc] initWithFormat:@"%.02f",attitude.pitch];
                     yLabel.text = [NSString stringWithFormat:@"Y: %@", y];
                     
                     NSString *z = [[NSString alloc] initWithFormat:@"%.02f",attitude.roll];
                     zLabel.text = [NSString stringWithFormat:@"Z: %@", z];
                 }];
            }
        }
        else
        {
            NSLog(@"Gyroscope not Available!");
        }
}



@end