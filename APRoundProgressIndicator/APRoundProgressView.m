//
// Created by Alexey Rashevskiy on 04/09/2013.
// Copyright (c) 2013 Appuchino. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "APRoundProgressView.h"


@implementation APRoundProgressView
{
    CGRect _circleRect;
    CAShapeLayer *_progressCircle;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _radius = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame))/2;
        _trackWidth = 2.0;
        _progressWidth = 2.0;
        _style = APRoundProgressStyleCenter;
        _trackColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        _progressCircle = [CAShapeLayer layer];
        _progressCircle.strokeStart = 0.0;
        _progressCircle.strokeEnd = 0.0;
        _progressCircle.fillColor = [UIColor clearColor].CGColor;
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.layer addSublayer:_progressCircle];
        self.progressColor = [UIColor whiteColor];
        [self updateGeometry];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, _trackColor.CGColor);
    CGContextSetLineWidth(context, _trackWidth);
    CGContextStrokeEllipseInRect(context, _circleRect);
    NSLog(@"Drawing track in rect x:%f, y:%f, w:%f, h:%f with width: %f", _circleRect.origin.x, _circleRect.origin.y, _circleRect.size.width, _circleRect.size.height, _trackWidth);
//    CGContextRelease(context);

}

-(CGRect)trackFrame {
    float delta = _trackWidth/2;
    return CGRectMake(CGRectGetMinX(_circleRect) - delta, CGRectGetMinY(_circleRect) - delta, CGRectGetWidth(_circleRect) + _trackWidth, CGRectGetHeight(_circleRect) + _trackWidth);
}

- (void)updateGeometry
{
    float circleMidDiameter = 2*(_radius - _trackWidth/2);
    _circleRect = CGRectMake((CGRectGetWidth(self.frame)-circleMidDiameter)/2,
            (CGRectGetHeight(self.frame)-circleMidDiameter)/2, circleMidDiameter, circleMidDiameter);
    
    float progressMidDiameter;
    switch (self.style) {
        case APRoundProgressStyleIn:
            progressMidDiameter = circleMidDiameter -_trackWidth-_progressWidth;
            break;
        case APRoundProgressStyleOut:
            progressMidDiameter = circleMidDiameter +_trackWidth+_progressWidth;
            break;
        case APRoundProgressStyleCenter:
        default:
            progressMidDiameter = circleMidDiameter;
            break;
    }
    
    CGRect progressRect = CGRectMake((CGRectGetWidth(self.frame)-progressMidDiameter)/2,
            (CGRectGetHeight(self.frame)-progressMidDiameter)/2, progressMidDiameter, progressMidDiameter);
    _progressCircle.path = [UIBezierPath bezierPathWithRoundedRect:progressRect
                                                      cornerRadius:progressMidDiameter/2].CGPath;
    _progressCircle.lineWidth = _progressWidth;

    float minimumInnerRadius = MIN((_radius - _trackWidth/2), progressMidDiameter-_progressWidth);
    
    
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    if (animated)
    {
        CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        drawAnimation.duration            = 0.5;
        drawAnimation.repeatCount         = 1.0;
        drawAnimation.removedOnCompletion = NO;
        drawAnimation.fromValue = [NSNumber numberWithFloat:_progress];
        drawAnimation.toValue   = [NSNumber numberWithFloat:progress];
        drawAnimation.fillMode = kCAFillModeForwards;
        [_progressCircle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
    }
    else
    {
        _progressCircle.strokeEnd = progress;
    }
    _progress = progress;
}

- (void)setProgress:(float)progress
{
    [self setProgress:progress animated:NO];
}

- (void)setProgressWidth:(float)progressWidth
{
    _progressWidth = progressWidth;
    [self updateGeometry];
}

- (void)setTrackWidth:(float)trackWidth
{
    _trackWidth = trackWidth;
    [self updateGeometry];
}

- (void)setStyle:(APRoundProgressStyle)style
{
    _style = style;
    [self updateGeometry];
}

- (void)setRadius:(float)radius
{
    _radius = radius;
    [self updateGeometry];
}

- (void)setProgressColor:(UIColor *)progressColor
{
    _progressColor = progressColor;
    _progressCircle.strokeColor = _progressColor.CGColor;
}

-(void)setTrackColor:(UIColor *)trackColor {
    _trackColor = trackColor;
    [self setNeedsDisplay];
}


@end