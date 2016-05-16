//
//  UIButton+ATButton.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-05-10.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ATButton)

// 按钮状态枚举
typedef NS_ENUM(NSUInteger,ATButtonState){
    
    // 按钮弹起
    ATButtonStateNormal,
    // 按钮按下
    ATButtonStateTap,
    
    // 按钮选中
    ATButtonStateSelected,
    // 按钮不可用
    ATButtonStateDisable
};

- (void)buttonState:(ATButtonState)state;


@end
