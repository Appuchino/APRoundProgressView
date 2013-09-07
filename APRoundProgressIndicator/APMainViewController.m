//
// Created by Alexey Rashevskiy on 03/09/2013.
// Copyright (c) 2013 Appuchino. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "APMainViewController.h"
#import "APRoundProgressView.h"


@implementation APMainViewController
{
    float _currentProgressValue;
    NSTimer *_progressTimer;
    APRoundProgressView *_progressView;
    UIProgressView *_standardProgressView;
    UISlider *_slider;
    UISwitch *_timerSwitch;
}

- (void)loadView
{
    [super loadView];

    self.view.backgroundColor = [UIColor colorWithRed:0.310 green:0.812 blue:0.776 alpha:1];
    _progressView = [[APRoundProgressView alloc] initWithFrame:CGRectMake(0, 200, CGRectGetWidth(self.view.frame),
            250)];
    _progressView.trackWidth = 1.0;
    _progressView.progressWidth = 2.0;
    _progressView.radius = 60.0;
    _progressView.progressColor = [UIColor blueColor];
    _progressView.trackColor = [UIColor blueColor];
    _progressView.style = APRoundProgressStyleIn;
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

}

- (void)increaseProgress
{
    _currentProgressValue+=10;
    if (_currentProgressValue > 100)
        _currentProgressValue = 0;
    NSLog(@"Progress: %f", _currentProgressValue);
    _progressView.progress = _currentProgressValue/100;
    [_standardProgressView setProgress:_currentProgressValue/100 animated:YES];
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
        _progressTimer = [NSTimer scheduledTimerWithTimeInterval:1
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
@end