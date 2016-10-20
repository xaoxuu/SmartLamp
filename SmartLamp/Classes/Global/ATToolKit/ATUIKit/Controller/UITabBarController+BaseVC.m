//
//  UITabBarController+BaseVC.m
//  DearyPet
//
//  Created by Aesir Titan on 2016-08-19.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "UITabBarController+BaseVC.h"

@implementation UITabBarController (BaseVC)

#pragma mark - self class

// setup bar style and tint color
- (void)at_setupBarStyle:(ATBarStyle)style tintColor:(UIColor * __nullable)color {
    // controller setting
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowRadius = 3.0f;
    self.view.layer.shadowOffset = CGSizeMake(0, 0);
    self.view.layer.shadowOpacity = 0.7f;
    // bar setting
    [self setupBarStyle:style];
    // tint color
    [self setupTintColor:color];
    
}

- (BOOL)at_setupTabBar:(UITabBar * __nonnull)bar {
    if (bar) {
        [self setValue:bar forKeyPath:@"tabBar"];
    } else{
        [self pushAlertView];
    }
    return bar;
}

#pragma mark - child class

// setup child controller
- (BOOL)at_setupChlidController:(UIViewController * __nonnull)vc title:(NSString * __nullable)title image:(NSString * __nonnull)image selectedImage:(NSString * __nullable)selectedImage {
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
        // show alert
        [self performSelector:@selector(pushAlertView) withObject:nil afterDelay:0.3];
    }
    return vc;
}


#pragma mark - private methods

// setup bar style
- (void)setupBarStyle:(ATBarStyle)style{
    switch (style) {
        case ATBarStyleLightBlur: {
            self.tabBar.barStyle = UIBarStyleDefault;
            self.tabBar.translucent = YES;
            self.tabBar.opaque = NO;
            break;
        }
        case ATBarStyleWhiteOpaque: {
            self.tabBar.barStyle = UIBarStyleDefault;
            self.tabBar.translucent = NO;
            self.tabBar.opaque = YES;
            break;
        }
        case ATBarStyleTintOpaque: {
            self.tabBar.barStyle = UIBarStyleBlack;
            self.tabBar.translucent = NO;
            self.tabBar.opaque = YES;
            break;
        }
    }
}

// setup tint color
- (void)setupTintColor:(UIColor *)color{
    if (!color) color = [UIColor colorWithRed:0.4 green:0.8 blue:1.0 alpha:1.0];
    // UITabBar tint color
    [UITabBar appearance].tintColor = color;
    // UITabBar bar tint color
    [UITabBar appearance].barTintColor = [UIColor whiteColor];
}

// show alert
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
