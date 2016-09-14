//
//  ATTabBarView+MD.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-25.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "ATTabBarView+MD.h"
#import "TitleButton.h"

@implementation ATTabBarView (MD)


+ (instancetype)tabBarWithTitleView:(UIView *)titleView titles:(NSArray<NSString *> *)titles titleColor:(UIColor *)titleColor rippleColor:(UIColor *)rippleColor contentView:(UIView *)contentView content:(UIView *(^)(NSUInteger index))content action:(void (^)(NSUInteger index))action {
    
    
    return [self tabBarWithTitleView:titleView items:^(NSMutableArray<UIButton *> *items) {
        for (NSString *title in titles) {
            TitleButton *btn = [[TitleButton alloc] init];
            btn.tintColor = atColor.white;
            btn.rippleColor = rippleColor;
            [btn setTitle:title forState:UIControlStateNormal];
            [items addObject:btn];
        }
    } contentView:contentView content:content action:action];
    
}



@end
