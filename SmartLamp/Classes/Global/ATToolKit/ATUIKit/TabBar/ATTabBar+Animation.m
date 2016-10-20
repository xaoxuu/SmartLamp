//
//  ATTabBar+Animation.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-10.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ATTabBar+Animation.h"

static NSUInteger animationMode;

@implementation ATTabBar (Animation)

// setup animation mode
- (void)setupAnimationMode:(ATTabBarAnimationMode)mode {
    switch (animationMode) {
        case ATTabBarAnimationModeRotation: {
            [self rotationMode];
            break;
        }
        case ATTabBarAnimationModeReversal: {
            [self reversalMode];
            break;
        }
    }
}

// rotation mode
- (void)rotationMode{
    for (int i=0; i<self.subviews.count; i++) {
        UIView *subview = self.subviews[i];
        // filter UITabBarButton
        if (subview.class != NSClassFromString(@"UITabBarButton")) continue;
        // animation
        [[subview rac_signalForSelector:@selector(touchesBegan:withEvent:)] subscribeNext:^(id x) {
            [UIView animateWithDuration:3.0f delay:0.0f usingSpringWithDamping:0.3f initialSpringVelocity:0.2f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                subview.subviews[0].transform = CGAffineTransformMakeRotation(M_PI);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.38f animations:^{
                    subview.subviews[0].transform = CGAffineTransformIdentity;
                }];
            }];
        }];
    }
}

// reversal mode
- (void)reversalMode{
    for (int i=0; i<self.subviews.count; i++) {
        UIView *subview = self.subviews[i];
        // filter UITabBarButton
        if (subview.class != NSClassFromString(@"UITabBarButton")) continue;
        // animation
        [[subview rac_signalForSelector:@selector(touchesBegan:withEvent:)] subscribeNext:^(id x) {
            [UIView animateWithDuration:3.0f delay:0.0f usingSpringWithDamping:0.3f initialSpringVelocity:0.3f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                subview.subviews[0].transform = CGAffineTransformMake(-1, 0, 0, 1, 0, 0);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.38f animations:^{
                    subview.subviews[0].transform = CGAffineTransformIdentity;
                }];
            }];
        }];
    }
}





@end
