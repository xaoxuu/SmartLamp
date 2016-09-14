//
//  UIImageView+ATGetColor.h
//  ATFoundation
//
//  Created by Aesir Titan on 2016-08-28.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (ATGetColor)


#pragma mark - get red green blue alpha

/**
 *	@author Aesir Titan
 *
 *	@brief get red green blue alpha with point
 *  从指定点获取RGBA值（最原始最暴力的方法，不推荐用）
 *
 *	@param red		red
 *	@param green	green
 *	@param blue	    blue
 *	@param alpha	alpha
 *	@param point	point
 */
- (void)at_getRed:(nullable CGFloat *)red green:(nullable CGFloat *)green blue:(nullable CGFloat *)blue alpha:(nullable CGFloat *)alpha withPoint:(CGPoint)point;

/**
 *	@author Aesir Titan
 *
 *	@brief get red green blue alpha with point and completion
 *  从指定点获取RGBA值，并在block中执行操作
 *
 *	@param point		point
 *	@param completion	completion
 */
- (void)at_getRGBAWithPoint:(CGPoint)point completion:(void(^)(CGFloat red,CGFloat green,CGFloat blue,CGFloat alpha))completion;

/**
 *	@author Aesir Titan
 *
 *	@brief get red green blue alpha from circle with point and completion
 *  从圆形范围内的指定点获取RGBA值，并在block中执行操作
 *
 *	@param point		point
 *	@param completion	completion
 */
- (void)at_getRGBAFromCircleWithPoint:(CGPoint)point completion:(void (^)(CGFloat red,CGFloat green,CGFloat blue,CGFloat alpha))completion;


#pragma mark - get color

/**
 *	@author Aesir Titan
 *
 *	@brief get color with point
 *  从指定点获取UIColor对象（最原始最暴力的方法，不推荐用）
 *
 *	@param point	point
 *
 *	@return UIColor
 */
- (nullable UIColor *)at_getColorWithPoint:(CGPoint)point;

/**
 *	@author Aesir Titan
 *
 *	@brief get color with point and completion
 *  从指定点获取UIColor对象，并在block中执行操作
 *
 *	@param point		point
 *	@param completion	completion
 */
- (void)at_getColorWithPoint:(CGPoint)point completion:(void(^)(UIColor *color))completion;

/**
 *	@author Aesir Titan
 *
 *	@brief get color from circle with point and completion
 *  从圆形范围内的指定点获取UIColor对象，并在block中执行操作
 *
 *	@param point		point
 *	@param completion	completion
 */
- (void)at_getColorFromCircleWithPoint:(CGPoint)point completion:(void (^)(UIColor *color))completion;


@end

NS_ASSUME_NONNULL_END