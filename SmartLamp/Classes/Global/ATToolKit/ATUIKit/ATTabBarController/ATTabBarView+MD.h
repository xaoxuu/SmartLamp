//
//  ATTabBarView+MD.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-25.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <ATKit/ATTabBarView.h>

@interface ATTabBarView (MD)


+ (instancetype)tabBarWithTitleView:(UIView *)titleView titles:(NSArray<NSString *> *)titles titleColor:(UIColor *)titleColor rippleColor:(UIColor *)rippleColor contentView:(UIView *)contentView content:(UIView *(^)(NSUInteger index))content action:(void (^)(NSUInteger index))action;


@end
