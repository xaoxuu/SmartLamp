//
//  UITabBarController+ATBaseController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-13.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "UITabBarController+ATBaseController.h"

static UIColor *at_tintColor;
@implementation UITabBarController (ATBaseController)


- (void)at_initWithDefaultStyle {
    
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowRadius = 3.0f;
    self.view.layer.shadowOffset = CGSizeMake(0, 0);
    self.view.layer.shadowOpacity = 0.7f;
    
}


- (void)at_setBarStyleWithLightBlur {
    self.tabBar.opaque = YES;
}

- (void)at_setBarStyleWithWhiteOpaque {
    
    self.tabBar.barStyle = UIBarStyleDefault;
//    [self.tabBar setOpaque:NO];
}

- (void)at_setTintColor:(UIColor * __nullable)color {
    if (color) {
        color = [UIColor colorWithRed:0.4 green:0.8 blue:1.0 alpha:1.0];
    }
    at_tintColor = color;
    // UITabBar 前景色
    [UITabBar appearance].tintColor = at_tintColor;
    // UITabBar 背景色
    [UITabBar appearance].barTintColor = [UIColor whiteColor];
}



- (BOOL)at_setupChlidController:(UINavigationController * __nonnull)vc title:(NSString * __nullable)title image:(NSString * __nonnull)image selectedImage:(NSString * __nullable)selectedImage {
    if (vc) {
        vc.tabBarItem.title = title;
        if (image.length) {
            vc.tabBarItem.image = [UIImage imageNamed:image];
            if (selectedImage) {
                vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
            }
        }
        [self addChildViewController:vc];
    } else {
        // 弹出警告信息
        [self performSelector:@selector(pushAlertView) withObject:nil afterDelay:0.3];
    }
    return vc;
}





// 弹出警告信息
- (void)pushAlertView{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告⚠️" message:@"传入的子控制器不能为空!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        NSLog(@"警告⚠️: 传入的子控制器不能为空!");
    });
}



@end
