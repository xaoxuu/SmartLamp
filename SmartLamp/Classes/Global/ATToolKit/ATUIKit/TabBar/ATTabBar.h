//
//  ATTabBar.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-13.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ATTabBar : UITabBar

// rac double tap signal
@property (strong, nonatomic) RACSubject * __nonnull didDoubleTapped;

// tabbar animation
typedef NS_ENUM(NSUInteger, ATTabBarAnimationMode) {
    ATTabBarAnimationModeRotation,
    ATTabBarAnimationModeReversal
};

/**
 *	@author Aesir Titan, 2016-08-02 20:08:11
 *
 *	@brief creator
 *
 *	@param mode	animation
 *
 *	@return
 */
+ (instancetype __nonnull)barWithAnimationMode:(ATTabBarAnimationMode)mode;

/**
 *	@author Aesir Titan, 2016-08-02 20:08:11
 *
 *	@brief creator
 *
 *	@param mode	animation
 *
 *	@return
 */
- (instancetype __nonnull)initWithAnimationMode:(ATTabBarAnimationMode)mode;

/**
 *	@author Aesir Titan, 2016-08-02 20:08:11
 *
 *	@brief creator
 *
 *	@param mode	animation
 *
 *	@return
 */
+ (instancetype __nonnull)barWithAnimationMode:(ATTabBarAnimationMode)mode centerButton:(UIButton * __nonnull)button action:(void (^__nonnull)())action;

/**
 *	@author Aesir Titan, 2016-08-02 20:08:11
 *
 *	@brief creator
 *
 *	@param mode	animation
 *
 *	@return
 */
- (instancetype __nonnull)initWithAnimationMode:(ATTabBarAnimationMode)mode centerButton:(UIButton *__nonnull)button action:(void (^__nonnull)())action;


@end

#import "ATTabBar+CenterButton.h"

