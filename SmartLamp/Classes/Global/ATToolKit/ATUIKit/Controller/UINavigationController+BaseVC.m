//
//  UINavigationController+BaseVC.m
//  DearyPet
//
//  Created by Aesir Titan on 2016-08-19.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "UINavigationController+BaseVC.h"

@implementation UINavigationController (BaseVC)

#pragma mark - self class

- (void)at_setupBarStyle:(ATBarStyle)style tintColor:(UIColor * __nullable)color{
    if (!color) color = [UIColor colorWithRed:0.4 green:0.8 blue:1.0 alpha:1.0];
    switch (style) {
        case ATBarStyleLightBlur: {
            // bar style
            [UINavigationBar appearance].barStyle = UIBarStyleDefault;
            [UINavigationBar appearance].translucent = YES;
            [UINavigationBar appearance].opaque = NO;
            // color
            [UINavigationBar appearance].tintColor = color;
            [UINavigationBar appearance].barTintColor = atColor.background;
            self.navigationItem.titleView.tintColor = color;
            break;
        }
        case ATBarStyleWhiteOpaque: {
            // bar style
            [UINavigationBar appearance].barStyle = UIBarStyleDefault;
            [UINavigationBar appearance].translucent = NO;
            [UINavigationBar appearance].opaque = YES;
            // color
            [UINavigationBar appearance].tintColor = color;
            [UINavigationBar appearance].barTintColor = [UIColor whiteColor];
            self.navigationItem.titleView.tintColor = color;
            break;
        }
        case ATBarStyleTintOpaque: {
            // bar style
            [UINavigationBar appearance].barStyle = UIBarStyleBlack;
            [UINavigationBar appearance].translucent = NO;
            [UINavigationBar appearance].opaque = YES;
            // color
            [UINavigationBar appearance].tintColor = [UIColor whiteColor];
            [UINavigationBar appearance].barTintColor = color;
            self.navigationItem.titleView.tintColor = atColor.background;
            break;
        }
    }
    // push
    [[self rac_signalForSelector:@selector(pushViewController:animated:)] subscribeNext:^(id x) {
        //        [self removeSeparator];
        
    }];
}

- (BOOL)at_setupNavigationBar:(UINavigationBar * __nonnull)bar {
    if (bar) {
        [self setValue:bar forKey:@"navigationBar"];
    } else{
        [self pushAlertView];
    }
    return bar;
}



#pragma mark - private methods

// show alert
- (void)pushAlertView{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告⚠️" message:@"传入的bar不能为空!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        NSLog(@"警告⚠️: 传入的bar不能为空!");
    });
}


- (void)removeSeparator{
    if (self.navigationController.navigationBar.subviews.count) {
        if (self.navigationController.navigationBar.subviews[0].subviews.count) {
            [self.navigationController.navigationBar.subviews[0].subviews[0] removeFromSuperview];
        }
    }
}

@end
