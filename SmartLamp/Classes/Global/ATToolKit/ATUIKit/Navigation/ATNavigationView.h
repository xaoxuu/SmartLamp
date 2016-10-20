//
//  ATNavigationView.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-05.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATNavigationView : UIView

// title
@property (strong, nonatomic) NSString *title;


- (void)at_leftButtonWithImage:(NSString *)image action:(void (^)())action;
- (void)at_rightButtonWithImage:(NSString *)image action:(void (^)())action;


/**
 *	@author Aesir Titan, 2016-08-04 12:08:16
 *
 *	@brief create a bar with tint color
 *
 *	@param barTintColor	tint color
 *
 *	@return
 */
+ (instancetype)viewWithBarTintColor:(UIColor *)barTintColor height:(CGFloat)height title:(NSString *)title;


@end
