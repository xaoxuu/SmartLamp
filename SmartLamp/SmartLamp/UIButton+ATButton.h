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
    
    // 按钮正常状态
    ATButtonStateNormal,
    // 按钮轻触时
    ATButtonStateTap,
    
    // 按钮选中时
    ATButtonStateSelected,
    // 按钮不可用时
    ATButtonStateDisabled
};

// 设置按钮的状态
- (void)buttonState:(ATButtonState)state;


@end
