//
//  ATMaterialButton.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-19.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ATMaterialButton.h"

static NSTimeInterval duration = 0.5f;
static CGFloat dampingRatio = 0.5f;
static CGFloat velocity = 0.1f;

@implementation ATMaterialButton

- (void)awakeFromNib{
    [self _initUI];
    [self normalStatus];
}

// init UI
- (void)_initUI{
    [self setEnabled:YES];
    self.clipsToBounds = NO;
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.backgroundColor = [UIColor colorWithRed:0.42 green:0.8 blue:1 alpha:1].CGColor;
    self.layer.shadowRadius = 1.0;
    [self setTitleColor:atColor.backgroundColor forState:UIControlStateNormal];
}


// hightlighted
- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    [self highlightedStatusIf:highlighted];
}

// selected
- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    [self selectedStatusIf:selected];
}

// normal
- (void)normalStatus{
    [UIView animateWithDuration:2*duration delay:0.0f usingSpringWithDamping:2*dampingRatio initialSpringVelocity:velocity options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.layer.shadowOffset = CGSizeMake(0.0,0.0);
        self.layer.shadowOpacity = 0.3;
        self.layer.shadowRadius = 1.0;
        self.layer.backgroundColor = atColor.themeColor.CGColor;
    } completion:^(BOOL finished) {
        
    }];
    
}

// highlighted
- (void)highlightedStatusIf:(BOOL)isYes{
    if (isYes) {
         [UIView animateWithDuration:duration delay:0.0f usingSpringWithDamping:dampingRatio initialSpringVelocity:velocity options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.layer.shadowOffset = CGSizeMake(0.0,4.0);
            self.layer.shadowOpacity = 0.3;
            self.layer.shadowRadius = 5.0;
            self.layer.backgroundColor = atColor.themeColor_light.CGColor;
        } completion:^(BOOL finished) {
            
        }];
        
    } else{
        [self normalStatus];
    }
}

// selected
- (void)selectedStatusIf:(BOOL)isYes{
    if (isYes) {
         [UIView animateWithDuration:duration delay:0.0f usingSpringWithDamping:dampingRatio initialSpringVelocity:velocity options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.layer.shadowOffset = CGSizeMake(0.0,2.5);
            self.layer.shadowOpacity = 0.4;
            self.layer.shadowRadius = 2.0;
            self.layer.backgroundColor = atColor.themeColor_light.CGColor;
        } completion:^(BOOL finished) {
            
        }];
        
    } else{
        [self normalStatus];
    }
}

// disabled
- (void)disabledStatusIf:(BOOL)isYes{
    if (isYes) {
         [UIView animateWithDuration:duration delay:0.0f usingSpringWithDamping:dampingRatio initialSpringVelocity:velocity options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.layer.backgroundColor = atColor.themeColor_light.CGColor;
            self.layer.shadowOffset = CGSizeMake(0.0,0.0);
            self.layer.shadowOpacity = 0.2;
            self.layer.shadowRadius = 0.5;
        } completion:^(BOOL finished) {
            
        }];
        
    } else{
        [self normalStatus];
    }
}

@end
