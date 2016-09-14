//
//  ATMDSwitch.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-20.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "MDSwitch.h"

@interface ATMDSwitch : MDSwitch

+ (instancetype)switchWithView:(UIView *)view thumbColor:(UIColor *)thumb trackColor:(UIColor *)track;

- (void)at_normalStyle;
- (void)at_lightStyle;

@end
