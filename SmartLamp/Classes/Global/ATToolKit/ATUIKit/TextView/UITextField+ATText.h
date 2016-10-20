//
//  UITextField+ATText.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-05-10.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (ATText)

// textfiled status
typedef NS_ENUM(NSUInteger,ATTextFieldState){
    
    // not editing
    ATTextFieldStateEditEnd,
    // editing
    ATTextFieldStateEditing,
    
};

// set status
- (void)textFieldState:(ATTextFieldState)state;

@end
