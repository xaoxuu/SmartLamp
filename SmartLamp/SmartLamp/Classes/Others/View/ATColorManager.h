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


#pragma mark - theme color
/**
 *	@author Aesir Titan
 *
 *	@brief theme color
 *
 *	@return theme color
 */
- (UIColor *)themeColor;
/**
 *	@author Aesir Titan
 *
 *	@brief dark theme color
 *
 *	@return dark theme color
 */
- (UIColor *)themeColor_dark;
/**
 *	@author Aesir Titan
 *
 *	@brief light theme color
 *
 *	@return light theme color
 */
- (UIColor *)themeColor_light;
/**
 *	@author Aesir Titan
 *
 *	@brief background color
 *
 *	@return background color
 */
- (UIColor *)backgroundColor;
/**
 *	@author Aesir Titan
 *
 *	@brief get a random color
 *
 *	@return a random color
 */
- (UIColor *)randomColor;


#pragma mark - all color
#pragma mark system
- (UIColor *)clear;

#pragma mark blue
- (UIColor *)blue;
- (UIColor *)blue_dark;
- (UIColor *)blue_light;
#pragma mark blue
- (UIColor *)lightBlue;
- (UIColor *)lightBlue_dark;
- (UIColor *)lightBlue_light;
#pragma mark blue
- (UIColor *)green;
- (UIColor *)green_dark;
- (UIColor *)green_light;
#pragma mark blue
- (UIColor *)yellow;
- (UIColor *)yellow_dark;
- (UIColor *)yellow_light;
#pragma mark blue
- (UIColor *)orange;



#pragma mark - creator methods

// defaultColorManager
+ (instancetype)defaultColorManager;

// sharedColorManager
+ (instancetype)sharedColorManager;


@end
