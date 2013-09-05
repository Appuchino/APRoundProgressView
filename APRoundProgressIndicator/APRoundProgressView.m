//
// Created by Alexey Rashevskiy on 04/09/2013.
// Copyright (c) 2013 Appuchino. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "APRoundProgressView.h"


@implementation APRoundProgressView
{
    UIColor *_unfilledIndicatorColor;
    CGRect _circleRect;
    CAShapeLayer *_progressCircle;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _radius = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame))/2;
        _circleRect = CGRectMake((CGRectGetWidth(frame)-2*_radius)/2, (CGRectGetHeight(frame)-2*_radius)/2, 2*_radius,
                2*_radius);
        _lineThickness = 2.0;
        _unfilledIndicatorColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        _progressCircle = [CAShapeLayer layer];
        _progressCircle.path = [UIBezierPath bezierPathWithRoundedRect:_circleRect
                                                          cornerRadius:_radius].CGPath;
        _progressCircle.strokeStart = 0.0;
        _progressCircle.strokeEnd = 0.0;
        _progressCircle.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:_progressCircle];
        self.backgroundColor = [UIColor clearColor];
        self.boldLineThickness = 5.0;
        self.indicatorColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetStrokeColorWithColor(context, _unfilledIndicatorColor.CGColor);
    CGContextSetLineWidth(context, _lineThickness);
    CGContextStrokeEllipseInRect(context, _circleRect);
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

- (void)setBoldLineThickness:(float)boldLineThickness
{
    _boldLineThickness = boldLineThickness;
    _progressCircle.lineWidth = _boldLineThickness;
}

- (void)setIndicatorColor:(UIColor *)indicatorColor
{
    _indicatorColor = indicatorColor;
    _progressCircle.strokeColor = indicatorColor.CGColor;
}

@end