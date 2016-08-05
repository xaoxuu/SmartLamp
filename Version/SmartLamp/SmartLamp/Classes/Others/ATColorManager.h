//
//  ATColorManager.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-14.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

#define atColor [ATColorManager defaultColorManager]

@interface ATColorManager : NSObject

#pragma mark - 主题色

// 主题色
@property (strong, nonatomic) UIColor *themeColor;
// 背景色
@property (strong, nonatomic) UIColor *backgroundColor;
// 主题色_深
@property (strong, readonly, nonatomic) UIColor *themeColor_dark;
// 主题色_浅
@property (strong, readonly, nonatomic) UIColor *themeColor_light;

#pragma mark - 绿色
// 绿色
@property (strong, readonly, nonatomic) UIColor *greenColor;
@property (strong, readonly, nonatomic) UIColor *greenColor_dark;
@property (strong, readonly, nonatomic) UIColor *greenColor_light;

#pragma mark - 蓝色
// 蓝色
@property (strong, readonly, nonatomic) UIColor *blueColor;
@property (strong, readonly, nonatomic) UIColor *blueColor_dark;
@property (strong, readonly, nonatomic) UIColor *blueColor_light;
// 天蓝色
@property (strong, readonly, nonatomic) UIColor *lightblueColor;
@property (strong, readonly, nonatomic) UIColor *lightblueColor_dark;
@property (strong, readonly, nonatomic) UIColor *lightblueColor_light;


// 红色
@property (strong, readonly, nonatomic) UIColor *redColor;
// 橙色
@property (strong, readonly, nonatomic) UIColor *orangeColor;
// 黄色
@property (strong, readonly, nonatomic) UIColor *yellowColor;


// 黄色
@property (strong, readonly, nonatomic) UIColor *yellow1Color;
@property (strong, readonly, nonatomic) UIColor *yellow1Color_light;
@property (strong, readonly, nonatomic) UIColor *yellow1Color_dark;


/**
 *	@author Aesir Titan, 2016-07-14 17:07:28
 *
 *	@brief 设置主题色
 *
 *	@param theme	主题色
 *	@param bgColor	背景色
 */
- (void)at_setThemeColor:(UIColor *)theme backgroundColor:(UIColor *)bgColor;

/**
 *	@author Aesir Titan, 2016-07-24 20:07:41
 *
 *	@brief 随机色
 *
 *	@return 返回一个随机色
 */
- (UIColor *)randomColor;


#pragma mark 📦 构造方法

// defaultColorManager (可以用此方法快速创建一个单例对象)
+ (instancetype)defaultColorManager;

// sharedColorManager
+ (instancetype)sharedColorManager;



@end
