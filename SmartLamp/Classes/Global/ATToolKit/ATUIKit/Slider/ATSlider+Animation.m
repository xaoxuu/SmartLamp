//
//  ATSlider+Animation.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-10.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ATSlider+Animation.h"

@implementation ATSlider (Animation)

- (void)scaleAnimation {
    [UIView animateWithDuration:0.6f delay:0.0f usingSpringWithDamping:0.3f initialSpringVelocity:0.2f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.thumb.transform = CGAffineTransformMakeScale(1.55, 1.55);
        self.thumb.layer.borderWidth = 0;
        self.thumb.layer.shadowOpacity = 0.5;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)cancelScaleAnimation {
    [UIView animateWithDuration:1.0f delay:0.0f usingSpringWithDamping:0.3f initialSpringVelocity:0.2f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.thumb.transform = CGAffineTransformIdentity;
        self.thumb.layer.borderWidth = 2;
        self.thumb.layer.shadowOpacity = 0.3;
    } completion:^(BOOL finished) {
        
    }];
}
@end
