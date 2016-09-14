//
//  UITabBarController+ATBaseController.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-13.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (ATBaseController)


#pragma mark - main
- (BOOL)at_setupChlidController:(UINavigationController * __nonnull)vc title:(NSString * __nullable)title image:(NSString * __nonnull)image selectedImage:(NSString * __nullable)selectedImage;


#pragma mark - detail

- (void)at_initWithDefaultStyle;

- (void)at_setTintColor:(UIColor * __nullable)color;

- (void)at_setBarStyleWithLightBlur;

- (void)at_setBarStyleWithWhiteOpaque;



@end
