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
    [self setEnabled:YES];
    
    self.layer.opacity = 1.0;
    self.clipsToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0,0.0);
    self.layer.borderWidth = 0;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.backgroundColor = [UIColor colorWithRed:0.42 green:0.8 blue:1 alpha:1].CGColor;
    self.layer.shadowRadius = 0.5;
    if (self.isSelected == YES) {
        state = ATButtonStateSelected;
    }

    switch (state) {
        case ATButtonStateNormal:
            self.layer.shadowOffset = CGSizeMake(0.0,0.0);
            self.layer.shadowOpacity = 0.2;
            self.layer.shadowRadius = 0.5;
            self.layer.backgroundColor = [UIColor colorWithRed:0.42 green:0.8 blue:1 alpha:1].CGColor;
            break;
        case ATButtonStateTap: //
            self.layer.shadowOffset = CGSizeMake(0.0,3.0);
            self.layer.shadowOpacity = 0.3;
            self.layer.shadowRadius = 7.0;
            self.layer.backgroundColor = [UIColor colorWithRed:0.71 green:0.9 blue:1 alpha:1].CGColor;
            break;
        case ATButtonStateSelected: //
            self.selected = YES;
            self.layer.shadowOffset = CGSizeMake(0.0,0.0);
            self.layer.shadowOpacity = 0.2;
            self.layer.shadowRadius = 0.5;
            self.layer.borderWidth = 2;
            self.layer.backgroundColor = [UIColor colorWithRed:0.42 green:0.8 blue:1 alpha:1].CGColor;
            break;
        case ATButtonStateDisable: //
            [self setEnabled:NO];
            self.layer.backgroundColor = [UIColor colorWithRed:0.71 green:0.9 blue:1 alpha:1].CGColor;
            self.layer.shadowOffset = CGSizeMake(0.0,0.0);
            self.layer.shadowOpacity = 0.2;
            self.layer.shadowRadius = 0.5;
            
            break;


    }
    
}



@end
