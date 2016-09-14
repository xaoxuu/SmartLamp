//
//  ATTabBar.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-13.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ATTabBar.h"

@interface ATTabBar ()

@property (weak, nonatomic) UIButton *centerBtn;


@end

@implementation ATTabBar

#pragma mark - 私有方法

// 初始化
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    // 第一次layout的时候把最后一个元素移除掉,也就是tabbar上边的分割线
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self.subviews lastObject] removeFromSuperview];
    });
}

// 设置中心按钮
- (void)_setupCenterButton{
    // 按钮的尺寸
    const CGFloat btnW = self.at_width / 5;
    const CGFloat btnH = self.at_height;
    // 设置所有uitabbar button的frame
    /**** 设置所有UITabBarButton的frame ****/
    CGFloat tabBarButtonY = 0;
    // 按钮索引
    int tabBarButtonIndex = 0;
    
    for (UIView *subview in self.subviews) {
        // 过滤掉非UITabBarButton
        if (subview.class != NSClassFromString(@"UITabBarButton")) continue;
        
        // 设置frame
        CGFloat tabBarButtonX = tabBarButtonIndex * btnW;
        if (tabBarButtonIndex >= 2) { // 右边的2个UITabBarButton
            tabBarButtonX += btnW;
        }
        subview.frame = CGRectMake(tabBarButtonX, tabBarButtonY, btnW, btnH);
        
        // 增加索引
        tabBarButtonIndex++;
    }
    
    // frame
    self.centerBtn.at_width = btnW;
    self.centerBtn.at_height = btnH;
    self.centerBtn.at_centerX = self.at_width * 0.5;
    self.centerBtn.at_centerY = self.at_height * 0.5;
    
}

#pragma mark 懒加载
// 中间按钮
- (UIButton *)centerBtn{
    if (!_centerBtn) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setImage:[UIImage imageNamed:@"tabbar_switch_off"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"tabbar_switch_off"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(centerBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
        _centerBtn = btn;
    }
    return _centerBtn;
}

// 中间按钮点击事件
- (void)centerBtnTapped:(UIButton *)sender{
    
    if (self.action) {
        self.action();
    }
    
}
// 设置通知
- (void)_setupNotification{
    
    [atNotificationCenter addObserver:self selector:@selector(receiveNotification:) name:nil object:nil];
    
}
// 接收通知
- (void)receiveNotification:(NSNotification *)noti{
    if ([noti.name isEqualToString:@"connect"]) {
        if ([noti.object isEqualToNumber:@YES]) {
            self.centerBtn.selected = YES;
        } else{
            self.centerBtn.selected = NO;
        }
    }
}





@end
