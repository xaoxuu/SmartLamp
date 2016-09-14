//
//  SCLAlertView+ATAlertView.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-19.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import <SCLAlertView.h>

@interface SCLAlertView (ATAlertView)


#pragma mark - 快速弹窗
/**
 *	@author Aesir Titan, 2016-07-09 13:07:07
 *
 *	@brief 普通提示
 *
 *	@param vc				弹出在哪个控制器
 *	@param title			标题
 *	@param subTitle			内容
 *	@param closeButtonTitle	关闭按钮
 *	@param duration			持续时间
 */
+ (void)at_showNotice:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;
/**
 *	@author Aesir Titan, 2016-07-09 13:07:07
 *
 *	@brief 成功
 *
 *	@param vc				弹出在哪个控制器
 *	@param title			标题
 *	@param subTitle			内容
 *	@param closeButtonTitle	关闭按钮
 *	@param duration			持续时间
 */
+ (void)at_showSuccess:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;
/**
 *	@author Aesir Titan, 2016-07-09 13:07:07
 *
 *	@brief 警告
 *
 *	@param vc				弹出在哪个控制器
 *	@param title			标题
 *	@param subTitle			内容
 *	@param closeButtonTitle	关闭按钮
 *	@param duration			持续时间
 */
+ (void)at_showWarning:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;
/**
 *	@author Aesir Titan, 2016-07-09 13:07:07
 *
 *	@brief 错误
 *
 *	@param vc				弹出在哪个控制器
 *	@param title			标题
 *	@param subTitle			内容
 *	@param closeButtonTitle	关闭按钮
 *	@param duration			持续时间
 */
+ (void)at_showError:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;
/**
 *	@author Aesir Titan, 2016-07-09 13:07:07
 *
 *	@brief 等待
 *
 *	@param vc				弹出在哪个控制器
 *	@param title			标题
 *	@param subTitle			内容
 *	@param closeButtonTitle	关闭按钮
 *	@param duration			持续时间
 */
+ (void)at_showWaiting:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;



#pragma mark - 创建弹窗实例
/**
 *	@author Aesir Titan, 2016-07-09 13:07:48
 *
 *	@brief 创建一个颜色为color的弹窗实例
 *
 *	@param color	给定颜色
 *
 *	@return 只返回实例, 不弹出窗口
 */
+ (instancetype)at_SCLAlertViewWithColor:(UIColor *)color;
/**
 *	@author Aesir Titan, 2016-07-09 13:07:48
 *
 *	@brief 创建一个默认颜色的弹窗实例
 *
 *	@return 只返回实例, 不弹出窗口
 */
+ (instancetype)at_SCLAlertViewWithDefaultColor;



@end
