//
//  ATNavigationBar.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-03.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATNavigationBar : UINavigationBar

/**
 *	@author Aesir Titan, 2016-08-04 12:08:16
 *
 *	@brief create a bar with tint color
 *
 *	@param barTintColor	tint color
 *
 *	@return
 */
+ (instancetype)barWithBarTintColor:(UIColor *)barTintColor;
/**
 *	@author Aesir Titan, 2016-08-04 12:08:16
 *
 *	@brief create a bar with tint color
 *
 *	@param barTintColor	tint color
 *
 *	@return
 */
- (instancetype)initWithBarTintColor:(UIColor *)barTintColor;

@end
