//
//  UIImageView+GetColorAtPixel.h
//  UIImageView+GetColorAtPixel
//
//  Created by Aesir Titan on 2016-05-20.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (GetColorAtPixel)

#pragma mark - get red green blue alpha
/**
 *	@author Aesir Titan, 2016-08-02 15:08:39
 *
 *	@brief get red green blue alpha with point
 *
 *	@param red		red
 *	@param green	green
 *	@param blue	    blue
 *	@param alpha	alpha
 *	@param point	point
 */
- (void)at_getRed:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha withPoint:(CGPoint)point;
/**
 *	@author Aesir Titan, 2016-08-02 15:08:03
 *
 *	@brief get red green blue alpha with point and completion
 *
 *	@param point		point
 *	@param completion	completion
 */
- (void)at_getRGBAWithPoint:(CGPoint)point completion:(void(^)(CGFloat red,CGFloat green,CGFloat blue,CGFloat alpha))completion;
/**
 *	@author Aesir Titan, 2016-08-02 15:08:28
 *
 *	@brief get red green blue alpha from circle with point and completion
 *
 *	@param point		point
 *	@param completion	completion
 */
- (void)at_getRGBAFromCircleWithPoint:(CGPoint)point completion:(void (^)(CGFloat red,CGFloat green,CGFloat blue,CGFloat alpha))completion;


#pragma mark - get color
/**
 *	@author Aesir Titan, 2016-08-02 15:08:05
 *
 *	@brief get color with point
 *
 *	@param point	point
 *
 *	@return UIColor
 */
- (UIColor *)at_getColorWithPoint:(CGPoint)point;
/**
 *	@author Aesir Titan, 2016-08-02 15:08:20
 *
 *	@brief get color with point and completion
 *
 *	@param point		point
 *	@param completion	completion
 */
- (void)at_getColorWithPoint:(CGPoint)point completion:(void(^)(UIColor *color))completion;
/**
 *	@author Aesir Titan, 2016-08-02 15:08:36
 *
 *	@brief get color from circle with point and completion
 *
 *	@param point		point
 *	@param completion	completion
 */
- (void)at_getColorFromCircleWithPoint:(CGPoint)point completion:(void (^)(UIColor *color))completion;





@end
