//
//  UIViewController+DrawerGesture.h
//  DearyPet
//
//  Created by Aesir Titan on 2016-08-20.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (DrawerGesture)

// enable drawer gesture
@property (assign, nonatomic) BOOL enableGesture;

#pragma mark - gesture creator
/**
 *	@author Aesir Titan, 2016-08-20 00:08:20
 *
 *	@brief setup navigation controller as main controller and drawer controller
 *
 *	@param MainVC	    mainVC
 *	@param drawerVC		drawerVC
 */
- (void)at_setupMainVC:(nonnull UIViewController *)navigationVC
              drawerVC:(nonnull UIViewController *)drawerVC enable:(BOOL)enable;

#pragma mark - gesture setting

/**
 *	@author Aesir Titan, 2016-08-23 17:08:11
 *
 *	@brief call this method when base view controller will appear
 */
- (void)at_disableGeatureInChlidController;

/**
 *	@author Aesir Titan, 2016   -08-20 00:08:19
 *
 *	@brief 缩放比例
 */
- (nonnull UIViewController * __nonnull(^)(CGFloat))scale;
/**
 *	@author Aesir Titan, 2016-08-20 00:08:39
 *
 *	@brief 屏幕右滑极限（占屏幕宽度的比例）
 */
- (nonnull UIViewController * __nonnull(^)(CGFloat))rightLimit;
/**
 *	@author Aesir Titan, 2016-08-20 00:08:06
 *
 *	@brief 屏幕左滑极限（占屏幕宽度的比例）
 */
- (nonnull UIViewController * __nonnull(^)(CGFloat))leftLimit;
/**
 *	@author Aesir Titan, 2016-08-20 00:08:30
 *
 *	@brief 屏幕左滑效率 (0~1~...,值为0时不跟手指,值为1时完全跟随手指,值大于1时滑动速率比手指快)
 */
- (nonnull UIViewController * __nonnull(^)(CGFloat))leftRatio;


@end
