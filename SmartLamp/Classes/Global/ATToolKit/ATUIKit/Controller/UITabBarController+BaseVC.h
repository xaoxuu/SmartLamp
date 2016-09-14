//
//  UITabBarController+BaseVC.h
//  DearyPet
//
//  Created by Aesir Titan on 2016-08-19.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (BaseVC)


#pragma mark - self class


// bar style
typedef NS_ENUM(NSUInteger, ATBarStyle){
    ATBarStyleLightBlur,
    ATBarStyleWhiteOpaque,
    ATBarStyleTintOpaque,
};
/**
 *	@author Aesir Titan, 2016-08-10 21:08:21
 *
 *	@brief setup bar style and tint color
 *
 *	@param style	bar style
 *	@param tint	    tint color
 */
- (void)at_setupBarStyle:(ATBarStyle)style tintColor:(nullable UIColor *)tint;
/**
 *	@author Aesir Titan, 2016-08-10 21:08:42
 *
 *	@brief setup tab bar
 *
 *	@param bar	tabbar
 *
 *	@return success or not
 */
- (BOOL)at_setupTabBar:(nonnull UITabBar *)bar;

#pragma mark - child class

/**
 *	@author Aesir Titan, 2016-08-10 20:08:36
 *
 *	@brief setup child controller
 *
 *	@param vc				a child controller
 *	@param title            a child controller's title
 *	@param image			a child controller's image
 *	@param selectedImage	a child controller's selected image
 *
 *	@return success or not
 */
- (BOOL)at_setupChlidController:(nonnull UIViewController *)vc title:(nullable NSString *)title image:(nonnull NSString *)image selectedImage:(nullable NSString *)selectedImage;


@end
