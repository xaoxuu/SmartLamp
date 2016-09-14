//
//  UITextField+ATText.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-05-10.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "UITextField+ATText.h"

@implementation UITextField (ATText)

// 设置文本框的状态
- (void)textFieldState:(ATTextFieldState)state{
    
    self.layer.opacity = 1.0;
    self.clipsToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowRadius = 2.0;
    self.layer.shadowOffset = CGSizeMake(0.0,0.0);
    self.layer.borderColor = [UIColor colorWithRed:0.419 green:0.8 blue:1 alpha:1].CGColor;
    self.layer.cornerRadius = 5.0;
    
    switch (state) {
        case ATTextFieldStateEditEnd:
            [self resignFirstResponder];
            self.layer.shadowOpacity = 0;
            self.layer.borderWidth = 0;
            break;
            
        case ATTextFieldStateEditing: //
            [self becomeFirstResponder];
            self.layer.borderWidth = 2.0;
            self.layer.shadowOpacity = 0.3;
            break;

    }
    
}

@end
