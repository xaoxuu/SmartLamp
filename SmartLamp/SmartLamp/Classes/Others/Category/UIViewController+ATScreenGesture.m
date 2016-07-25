//
//  UIViewController+ATScreenGesture.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-09.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//
#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
#define CenterX  SCREEN_W * 0.5
#define CenterY  SCREEN_H * 0.5
#import "UIViewController+ATScreenGesture.h"

// ==================== [ 参数 ] ==================== //
// 侧滑打开之后的右边边距
static CGFloat RightMargin = 60;
// 屏幕向左能滑动多少
static CGFloat LeftOffset = 80;

// ==================== [ 变量 ] ==================== //
// 侧滑打开之后的Center
#define CenterX_Opened (CenterX + SCREEN_W - RightMargin)
static UIViewController *at_mainVC = nil;
static UIViewController *at_leftVC = nil;
static BOOL at_isLeftViewOpen = NO;
UIPanGestureRecognizer *at_pan = nil;

@implementation UIViewController (ATScreenGesture)

- (BOOL)at_loadPanGestureWithMainVC:(UIViewController * __nonnull)mainVC
                             leftVC:(UIViewController * __nonnull)leftVC
                   andAppThemeColor:(UIColor * __nullable)themeColor {
    
    if (mainVC&&leftVC) {
        [self at_initWithMainVC:mainVC leftVC:leftVC];
        [self at_setAppThemeColor:themeColor];
        [self at_loadPanGesture];
    }
    
    return mainVC&&leftVC;
    
}

// 初始化侧滑视图
- (BOOL)at_initWithMainVC:(UIViewController * __nonnull)mainVC leftVC:(UIViewController * __nullable)leftVC{
    
    if (mainVC) {
        // ==================== [ 加载控制器 ] ==================== //
        if (leftVC) {
            at_leftVC = leftVC;
            // 把leftVC控制器作为子控制器
            [self addChildViewController:leftVC];
            // 把leftVC的视图添加到view
            [self.view addSubview:leftVC.view];
        }
        at_mainVC = mainVC;
        // 添加mainVC
        [self addChildViewController:mainVC];
        // mainVC.view
        [self.view addSubview:mainVC.view];
        
    } else{
        // 弹出警告信息
        [self performSelector:@selector(pushAlertView) withObject:nil afterDelay:0.3];
    }
    
    return mainVC;
}

// 设置app主题色
- (BOOL)at_setAppThemeColor:(UIColor * __nullable)themeColor{
    
    if (!themeColor) {
        themeColor = [UIColor colorWithRed:0.4 green:0.8 blue:1.0 alpha:1.0];
    }
    // 设置背景颜色与主题色相同
    self.view.tintColor = themeColor;
    self.view.backgroundColor = themeColor;
    if (at_mainVC&&at_leftVC) {
        at_leftVC.view.backgroundColor = themeColor;
        at_mainVC.view.tintColor = themeColor;
        
        // UITabBar 前景色
        [UITabBar appearance].tintColor = themeColor;
        // UITabBar 背景色
        [UITabBar appearance].barTintColor = [UIColor whiteColor];
        // UINavigationBar 前景色
        [UINavigationBar appearance].tintColor = [UIColor whiteColor];
        // UINavigationBar 背景色
        [UINavigationBar appearance].barTintColor = themeColor;
    }
    return at_mainVC&&at_leftVC;
}

// 设置手势参数
- (void)at_setPanGestureWithRightMargin:(CGFloat)rightMargin leftOffset:(CGFloat)leftOffset{
    if (rightMargin >= 0) {
        RightMargin = rightMargin;
    }
    if (leftOffset >= 0) {
        LeftOffset = leftOffset;
    }
}

// 加载手势
- (BOOL)at_loadPanGesture {
    
    // ==================== [ 加载手势 ] ==================== //
    if (at_mainVC&&at_leftVC) {
        at_pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handlePanGesture:)];
        [self.view addGestureRecognizer:at_pan];
    } else{
        // 弹出警告信息
        [self performSelector:@selector(pushAlertView) withObject:nil afterDelay:0.3];
    }
    return at_mainVC&&at_leftVC;
    
}


#pragma mark - 🚫🚫🚫🚫🚫🚫🚫🚫🚫🚫 私有方法

- (void)_handlePanGesture:(UIPanGestureRecognizer *)sender{
    
    // ==================== [ 过滤和准备参数 ] ==================== //
    const CGFloat translationX = [sender translationInView:self.view].x;
    const CGFloat velocityX = [sender velocityInView:self.view].x;
    // ==================== [ 正在滑动 ] ==================== //
    // 手指位置改变
    if (sender && sender.state == UIGestureRecognizerStateChanged) {
        
        if (at_mainVC.view.center.x < CenterX) {
            // 主屏滑到左侧时主屏跟随手指的规则
            [self moveLeftWithTranslationX:translationX];
        } else {
            // 主屏滑到右侧时主屏跟随手指的规则
            [self moveRightWithTranslationX:translationX];
        }

    }
    // 松开手指
    if (sender && sender.state == UIGestureRecognizerStateRecognized) {
        
        // 根据松开手指时主屏移动的加速度来判断结果应该是打开还是关闭
        if (fabs(velocityX)>500) {
            [self leftViewOpenIf:velocityX > 500];
        } else {
            // 根据位置判断应该打开还是关闭
            const CGFloat leftMargin  = fabs(at_mainVC.view.center.x-CenterX);
            const CGFloat rightMargin = fabs(at_mainVC.view.center.x-CenterX_Opened);
            // 如果main的中心与屏幕左边的距离大于与右边的距离, 就打开
            [self leftViewOpenIf:leftMargin > rightMargin];
        }
        
    }
    
    
}

// 主屏滑到左侧时主屏跟随手指的规则
- (void)moveLeftWithTranslationX:(CGFloat)translationX{
    
    // 主屏向左侧滑的最大限制: LeftOffset
    if (at_mainVC.view.center.x >= CenterX - LeftOffset) {
        at_mainVC.view.center = [self offsetX:0.5 * translationX fromOriginX:0];
    }

}
// 主屏滑到右侧时主屏跟随手指的规则
- (void)moveRightWithTranslationX:(CGFloat)translationX{
    
    if (at_isLeftViewOpen) {
        at_mainVC.view.center = CGPointMake(translationX + CenterX_Opened, CenterY);
        at_leftVC.view.center = [self offsetX:translationX fromOriginX:0];
        
    } else {
        at_mainVC.view.center = CGPointMake(translationX + CenterX, CenterY);
        at_leftVC.view.center = [self offsetX:translationX fromOriginX:-LeftOffset];
    }
}

// 从origin开始移动offset的距离
- (CGPoint)offsetX:(CGFloat)offset fromOriginX:(CGFloat)origin{
    return CGPointMake(origin + CenterX + LeftOffset * CenterX_Opened * offset * 0.25 / pow(CenterX, 2.0), CenterY);
}

// 打开或关闭左侧视图
- (void)leftViewOpenIf:(BOOL)isOpen{
    
    [UIView animateWithDuration:0.38f delay:0 options:UIViewAnimationOptionCurveEaseOut  animations:^{
        at_mainVC.view.center = CGPointMake(isOpen ? CenterX_Opened:CenterX, CenterY);
        at_leftVC.view.center = CGPointMake(isOpen ? CenterX:(CenterX - LeftOffset), CenterY);
    } completion:^(BOOL finished) {
        at_isLeftViewOpen = isOpen;
    }];
    
}



// 弹出警告信息
- (void)pushAlertView{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告⚠️" message:@"主视图控制器或左侧抽屉视图控制器不能为空!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        NSLog(@"警告⚠️: 主视图控制器或左侧抽屉视图控制器不能为空!");
    });
}





@end
