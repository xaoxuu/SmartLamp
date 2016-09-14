//
//  UINavigationController+BaseVC.h
//  DearyPet
//
//  Created by Aesir Titan on 2016-08-19.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (BaseVC)

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
 *	@brief setup navigation bar
 *
 *	@param bar	navigation
 *
 *	@return success or not
 */
- (BOOL)at_setupNavigationBar:(nonnull UINavigationBar *)bar;

@end
