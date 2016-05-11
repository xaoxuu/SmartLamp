//
//  UITextField+ATText.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-05-10.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (ATText)

// 文本框状态枚举
typedef NS_ENUM(NSUInteger,ATTextFieldState){
    
    // 非编辑状态
    ATTextFieldStateEditEnd,
    // 编辑状态
    ATTextFieldStateEditing,
    
};

- (void)textFieldState:(ATTextFieldState)state;

@end
