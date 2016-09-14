//
//  ATSlider.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-02.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ATSlider.h"

UIImageView *thumb;

@implementation ATSlider

- (void)awakeFromNib{
    [super awakeFromNib];
    self.minimumTrackTintColor = atColor.themeColor;
    [self setThumbImage:[UIImage imageNamed:@"home_thumb"] forState:UIControlStateNormal];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        thumb = self.subviews[2];
        thumb.layer.cornerRadius = 0.5*thumb.frame.size.width;
        thumb.layer.borderColor = atColor.backgroundColor.CGColor;
        thumb.layer.borderWidth = 2;
        thumb.layer.shadowOffset = CGSizeMake(0, 0);
        thumb.layer.shadowOpacity = 0.3;
        thumb.layer.shadowRadius = 1.0;
    });
    
    [self handleTapEvents];
}

- (void)handleTapEvents{
    [[self rac_signalForSelector:@selector(touchesBegan:withEvent:)] subscribeNext:^(id x) {
        
        [UIView animateWithDuration:0.6f delay:0.0f usingSpringWithDamping:0.3f initialSpringVelocity:0.2f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            thumb.transform = CGAffineTransformMakeScale(1.55, 1.55);
            thumb.layer.borderWidth = 0;
            thumb.layer.shadowOpacity = 0.5;
        } completion:^(BOOL finished) {
            
        }];
    }];
    [[self rac_signalForSelector:@selector(touchesEnded:withEvent:)] subscribeNext:^(id x) {
        
        [UIView animateWithDuration:1.0f delay:0.0f usingSpringWithDamping:0.3f initialSpringVelocity:0.2f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            thumb.transform = CGAffineTransformIdentity;
            thumb.layer.borderWidth = 2;
            thumb.layer.shadowOpacity = 0.3;
        } completion:^(BOOL finished) {
            
        }];
    }];
    
}


@end
