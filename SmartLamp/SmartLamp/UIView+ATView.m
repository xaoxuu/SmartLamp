//
//  UIView+ATView.m
//  Aesir Titan UIView Category
//
//  Created by Aesir Titan on 2016.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "UIView+ATView.h"

@implementation UIView (ATView)


// 设置控件的阴影效果
- (void)shadowLayer:(ATWidgetAnimation)state{
    self.layer.opacity = 1.0;
    self.clipsToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0,0.0);
    switch (state) {
            
        case ATWidgetAnimationNone:      // 没有效果
            self.layer.shadowOpacity = 0;
            self.layer.shadowRadius = 0;
            break;
        /*======================[ Label ]======================*/
        case ATWidgetAnimationTitleStyle:  // 标题风格
            self.layer.shadowOpacity = 0.5;
            self.layer.shadowRadius = 1.0;
            break;
            
            
            
        /*======================[ TextField ]======================*/
        case ATWidgetAnimationEditing:     // 编辑状态
            self.layer.borderColor = [UIColor colorWithRed:0.419 green:0.8 blue:1.0 alpha:1.0].CGColor;
            self.layer.shadowColor = [UIColor blackColor].CGColor;
            
            self.layer.shadowOffset = CGSizeMake(0.0, 0.0);
            self.clipsToBounds = NO;
            
            self.layer.borderWidth = 2.0;
            self.layer.shadowOpacity = 0.3;
            self.layer.shadowRadius = 2.0;
            break;
        case ATWidgetAnimationEditEnd:     // 非编辑状态
            [self resignFirstResponder];
            self.layer.shadowOpacity = 0;
            self.layer.borderWidth = 0;
            break;

            
            
        /*======================[ Button ]======================*/
        case ATWidgetAnimationButtonDown:  // 按钮按下
            self.layer.shadowOpacity = 0.2;
            self.layer.shadowRadius = 0.5;
            break;
        case ATWidgetAnimationButtonUp:    // 按钮弹起
            self.layer.shadowOpacity = 0.3;
            self.layer.shadowRadius = 2.0;
            break;
            
            
        default:
            break;
    }
    
}


@end
