//
//  ATMaterialButton.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-19.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ATMaterialButton.h"

@implementation ATMaterialButton


- (void)awakeFromNib{
    
    [self _initUI];
    
    [self normalStatus];

}

// 初始化UI
- (void)_initUI{
    
    [self setEnabled:YES];
    self.layer.opacity = 1.0;
    self.clipsToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0,0.0);
    self.layer.backgroundColor = [UIColor colorWithRed:0.42 green:0.8 blue:1 alpha:1].CGColor;
    self.layer.shadowRadius = 0.5;
    [self setTitleColor:atColor.backgroundColor forState:UIControlStateNormal];
}

// 触摸开始事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self setHighlighted:YES];
    UIView *superView = self.superview;
    for (UIView *view in superView.subviews) {
        if ([view isKindOfClass:[ATMaterialButton class]]) {
            ATMaterialButton * btn = (ATMaterialButton *)view;
            if (![btn isEqual:self]) {
                [btn setSelected:NO];
            }
        }
        
    }
    
}

// 触摸结束事件
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    [self setSelected:YES];
}

// 设置高亮
- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    [self highlightedStatusIf:highlighted];
}

// 设置选中
- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    [self selectedStatusIf:selected];
}

// 正常状态
- (void)normalStatus{
    [UIView animateWithDuration:0.38f animations:^{
        self.layer.shadowOffset = CGSizeMake(0.0,0.0);
        self.layer.shadowOpacity = 0.2;
        self.layer.shadowRadius = 0.5;
        self.layer.backgroundColor = atColor.themeColor.CGColor;
    }];
    
}

// 设置高亮状态
- (void)highlightedStatusIf:(BOOL)isYes{
    if (isYes) {
        [UIView animateWithDuration:0.1f animations:^{
            self.layer.shadowOffset = CGSizeMake(0.0,4.0);
            self.layer.shadowOpacity = 0.3;
            self.layer.shadowRadius = 5.0;
            self.layer.backgroundColor = atColor.themeColor_light.CGColor;
        }];
        
    } else{
        [self normalStatus];
    }
}

// 设置选中状态
- (void)selectedStatusIf:(BOOL)isYes{
    if (isYes) {
        [UIView animateWithDuration:0.38f animations:^{
            self.layer.shadowOffset = CGSizeMake(0.0,2.5);
            self.layer.shadowOpacity = 0.4;
            self.layer.shadowRadius = 2.0;
            self.layer.backgroundColor = atColor.themeColor_light.CGColor;
        }];
        
    } else{
        [self normalStatus];
    }
}

// 设置不可用状态
- (void)disabledStatusIf:(BOOL)isYes{
    if (isYes) {
        [UIView animateWithDuration:0.38f animations:^{
            [self setEnabled:NO];
            self.layer.backgroundColor = atColor.themeColor_light.CGColor;
            self.layer.shadowOffset = CGSizeMake(0.0,0.0);
            self.layer.shadowOpacity = 0.2;
            self.layer.shadowRadius = 0.5;
        }];
        
    } else{
        [self normalStatus];
    }
}

@end
