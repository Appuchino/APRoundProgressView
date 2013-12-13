//
//  APRoundProgressGlareView.h
//  APRoundProgressIndicator
//
//  Created by Alexey Rashevskiy on 12/12/2013.
//  Copyright (c) 2013 Appuchino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APRoundProgressView.h"

@interface APRoundProgressGlareView : UIView

@property (nonatomic) float radius;
@property (nonatomic) float trackWidth;
@property (nonatomic) float progressWidth;
@property (nonatomic) UIColor *progressColor;
@property (nonatomic) UIColor *trackColor;
@property (nonatomic) APRoundProgressStyle style;
@property (readonly) UILabel *label;
@property (nonatomic) float progress;
@property (nonatomic) BOOL gyroAnimated;

@end
