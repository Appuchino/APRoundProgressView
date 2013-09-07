//
// Created by Alexey Rashevskiy on 04/09/2013.
// Copyright (c) 2013 Appuchino. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

typedef enum {
    APRoundProgressStyleCenter,
    APRoundProgressStyleOut,
    APRoundProgressStyleIn
} APRoundProgressStyle;

@interface APRoundProgressView : UIView

@property (nonatomic) float radius;
@property (nonatomic) float trackWidth;
@property (nonatomic) float progressWidth;
@property (nonatomic) UIColor *progressColor;
@property (nonatomic) UIColor *trackColor;
@property (nonatomic) APRoundProgressStyle style;

@property (nonatomic) float progress;

@end