//
// Created by Alexey Rashevskiy on 04/09/2013.
// Copyright (c) 2013 Appuchino. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface APRoundProgressView : UIView

@property (nonatomic) float radius;
@property (nonatomic) float lineThickness;
@property (nonatomic) float boldLineThickness;
@property (nonatomic) UIColor *indicatorColor;

@property (nonatomic) float progress;

@end