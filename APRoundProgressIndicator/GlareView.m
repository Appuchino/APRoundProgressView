//
//  GlareView.m
//  APRoundProgressIndicator
//
//  Created by Alexey Rashevskiy on 10/12/2013.
//  Copyright (c) 2013 Appuchino. All rights reserved.
//

#import "GlareView.h"
#import "AngleGradientLayer.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreMotion/CoreMotion.h>


@implementation GlareView

AngleGradientLayer *gradientLayer;

+ (Class)layerClass
{
	return [AngleGradientLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
	if (!(self = [super initWithFrame:frame]))
		return nil;
	
	self.backgroundColor = [UIColor clearColor];
	
	gradientLayer = (AngleGradientLayer *)self.layer;
	
	gradientLayer.cornerRadius = CGRectGetWidth(self.bounds) / 2;
	self.clipsToBounds = YES;
    
	return self;
}

-(void)setStrokeColorLight:(UIColor *)strokeColorLight {
    UIColor *glareColor = [strokeColorLight colorWithAlphaComponent:1.0];
    _strokeColorLight = strokeColorLight;
    gradientLayer.colors = @[(id)_strokeColorLight.CGColor, (id)glareColor.CGColor, (id)_strokeColorLight.CGColor, (id)_strokeColorLight.CGColor,
                             (id)glareColor.CGColor, (id)_strokeColorLight.CGColor];
    gradientLayer.locations = @[@0.0, @0.05, @0.1, @0.5, @0.55, @0.60];
    
}

-(void)setStrokeWidth:(CGFloat)strokeWidth {
    _strokeWidth = strokeWidth;
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    float delta = strokeWidth / 2;
    CGRect midCircleFrame = CGRectMake(CGRectGetMinX(self.bounds)+delta, CGRectGetMinY(self.bounds)+delta, CGRectGetWidth(self.bounds)-strokeWidth, CGRectGetHeight(self.bounds)-strokeWidth);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:midCircleFrame];
    CGPathRef path = CGPathCreateCopyByStrokingPath(bezierPath.CGPath, nil, strokeWidth, kCGLineCapButt, kCGLineJoinMiter, 0);
    shapeLayer.path = path;
    gradientLayer.mask = shapeLayer;
}

@end
