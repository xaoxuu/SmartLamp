//
//  UIViewController+ATScreenGesture.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-09.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ATScreenGesture)

#pragma mark - 推荐使用,一行搞定
/**
 *	@author Aesir Titan, 2016-07-11 13:07:48
 *
 *	@brief 初始化控制器, 并设置app主题色, 然后加载手势
 *
 *	@param mainVC			主控制器
 *	@param leftVC			左侧控制器
 *	@param themeColor	    app主题色
 */
- (BOOL)at_loadPanGestureWithMainVC:(UIViewController * __nonnull)mainVC
                             leftVC:(UIViewController * __nonnull)leftVC
                   andAppThemeColor:(UIColor * __nullable)themeColor;

#pragma mark - 下面是详细的方法
/**
 *	@author Aesir Titan, 2016-07-10 15:07:26
 *
 *	@brief 设置app主题色
 *
 *	@param themeColor	主题色
 */
- (BOOL)at_setAppThemeColor:(UIColor * __nullable)themeColor;

/**
 *	@author Aesir Titan, 2016-07-10 00:07:16
 *
 *	@brief 初始化侧滑视图
 *
 *	@param mainVC	    主视图控制器
 *	@param leftVC		左侧视图控制器
 */
- (BOOL)at_initWithMainVC:(UIViewController * __nonnull)mainVC leftVC:(UIViewController * __nullable)leftVC;

/**
 *	@author Aesir Titan, 2016-07-09 16:07:24
 *
 *	@brief 设置手势参数
 *
 *	@param rightMargin  侧滑打开之后的右边边距
 *	@param leftOffset	屏幕向左能滑动多少
 *	@param leftDrag		屏幕向左滑动时的效率 (0~1~...,值为0时不跟手指,值为1时完全跟随手指,值大于1时滑动速率比手指快)
 */
- (void)at_setPanGestureWithRightMargin:(CGFloat)rightMargin leftOffset:(CGFloat)leftOffset;

/**
 *	@author Aesir Titan, 2016-07-09 16:07:10
 *
 *	@brief 加载手势
 */
- (BOOL)at_loadPanGesture;





@end
