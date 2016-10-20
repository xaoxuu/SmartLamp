//
//  UIColor+ATEnhance.h
//  Foundation
//
//  Created by Aesir Titan on 2016-08-21.
//  Copyright © 2016 Titan Studio. All rights reserved.
//



#import <UIKit/UIKit.h>

@interface UIColor (ATExtension)

/*!
 *	@author Aesir Titan, 2016-08-25
 *
 *	@brief get a dark color with 0.6 ratio
 *
 *	@return a dark color
 */
- (UIColor *)dark;

/*!
 *	@author Aesir Titan, 2016-08-25
 *
 *	@brief get a light color with 0.6 ratio
 *
 *	@return a light color
 */
- (UIColor *)light;

/*!
 *	@author Aesir Titan, 2016-08-25
 *
 *	@brief get a light color with ratio
 *
 *	@return a light color
 */
- (UIColor *(^)(CGFloat))darkRatio;

/*!
 *	@author Aesir Titan, 2016-08-25
 *
 *	@brief get a light color with ratio
 *
 *	@return a light color
 */
- (UIColor *(^)(CGFloat))lightRatio;

/**
 *	@author Aesir Titan, 2016-08-21 16:08:46
 *
 *	@brief get a random color
 *
 *	@return  a random color
 */
+ (UIColor *)randomColor;


/**
 *	@author Aesir Titan, 2016-08-13 22:08:22
 *
 *	@brief color with hex
 *
 *	@param hex	hex
 *
 *	@return color
 */
+ (UIColor *)colorWithHex:(NSUInteger)hex;
/**
 *	@author Aesir Titan, 2016-08-13 22:08:35
 *
 *	@brief color with hex string
 *
 *	@param hexStr	hex
 *
 *	@return color
 */
+ (UIColor *)colorWithHexString:(NSString *)hexStr;
/**
 *	@author Aesir Titan, 2016-08-21 16:08:06
 *
 *	@brief get red from UIColor
 *
 *	@return red
 */
- (CGFloat)getRed;
/**
 *	@author Aesir Titan, 2016-08-21 16:08:19
 *
 *	@brief get green from UIColor
 *
 *	@return green
 */
- (CGFloat)getGreen;
/**
 *	@author Aesir Titan, 2016-08-21 16:08:26
 *
 *	@brief get blue from UIColor
 *
 *	@return blue
 */
- (CGFloat)getBlue;
/**
 *	@author Aesir Titan, 2016-08-21 16:08:31
 *
 *	@brief get red from UIColor
 *
 *	@return alpha
 */
- (CGFloat)getAlpha;

/*!
 *	@author Aesir Titan, 2016-09-10
 *
 *	@brief get hex string from UIColor
 *
 *	@return hex string
 */
- (NSString *)hexString;
/*!
 *	@author Aesir Titan, 2016-09-10
 *
 *	@brief get hex string (with alpha) from UIColor
 *
 *	@return hex string
 */
- (NSString *)hexStringWithAlpha;



@end



