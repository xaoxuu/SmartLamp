//
//  UIButton+ATButton.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-05-10.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "UIButton+ATButton.h"

@implementation UIButton (ATButton)

- (void)buttonState:(ATButtonState)state{
    
    self.layer.opacity = 1.0;
    self.clipsToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0,0.0);
    
    switch (state) {
        case ATButtonStateUp:
            self.layer.shadowOffset = CGSizeMake(0.0,0.0);
            self.layer.shadowOpacity = 0.2;
            self.layer.shadowRadius = 0.5;
            break;
        case ATButtonStateDown: //
            self.layer.shadowOffset = CGSizeMake(0.0,3.0);
            self.layer.shadowOpacity = 0.3;
            self.layer.shadowRadius = 5.0;
            break;

    }
    
}

@end
