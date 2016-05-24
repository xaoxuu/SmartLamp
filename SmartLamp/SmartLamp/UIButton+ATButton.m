//
//  UIButton+ATButton.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-05-10.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "UIButton+ATButton.h"


@implementation UIButton (ATButton)

// 设置按钮的状态
- (void)buttonState:(ATButtonState)state{
    
    [self setEnabled:YES];
    self.layer.opacity = 1.0;
    self.clipsToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0,0.0);
    self.layer.backgroundColor = [UIColor colorWithRed:0.42 green:0.8 blue:1 alpha:1].CGColor;
    self.layer.shadowRadius = 0.5;

    switch (state) {
        case ATButtonStateNormal:
            self.layer.shadowOffset = CGSizeMake(0.0,0.0);
            self.layer.shadowOpacity = 0.2;
            self.layer.shadowRadius = 0.5;
            self.layer.backgroundColor = self.normalColor.CGColor;
            break;
        case ATButtonStateTap: //
            self.layer.shadowOffset = CGSizeMake(0.0,4.0);
            self.layer.shadowOpacity = 0.3;
            self.layer.shadowRadius = 5.0;
            self.layer.backgroundColor = self.selectedColor.CGColor;
            break;
        case ATButtonStateSelected: //
            self.selected = YES;
            self.layer.shadowOffset = CGSizeMake(0.0,3.0);
            self.layer.shadowOpacity = 0.2;
            self.layer.shadowRadius = 4.0;
            self.layer.backgroundColor = self.selectedColor.CGColor;
            break;
        case ATButtonStateDisabled: //
            [self setEnabled:NO];
            self.layer.backgroundColor = self.disabledColor.CGColor;
            self.layer.shadowOffset = CGSizeMake(0.0,0.0);
            self.layer.shadowOpacity = 0.2;
            self.layer.shadowRadius = 0.5;
            break;
    }
    
}

- (UIColor *)normalColor{
    return [UIColor colorWithRed:0.40f green:0.80f blue:0.98f alpha:1.00f];
}

- (UIColor *)disabledColor{
    return [UIColor colorWithRed:0.70f green:0.90f blue:0.99f alpha:1.00f];
}

- (UIColor *)selectedColor{
    return [UIColor colorWithRed:0.55f green:0.85f blue:0.98f alpha:1.00f];
}




@end
