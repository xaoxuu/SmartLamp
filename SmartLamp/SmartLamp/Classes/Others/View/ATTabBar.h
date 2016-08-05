//
//  ATTabBar.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-13.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATTabBar : UITabBar

/**
 *	@author Aesir Titan, 2016-08-02 20:08:38
 *
 *	@brief tabbar animation
 */
typedef NS_OPTIONS(NSUInteger, ATTabBarAnimationMode) {
    /**
     *	@author Aesir Titan, 2016-08-02 20:08:38
     *
     *	rotation
     */
    ATTabBarAnimationModeRotation,
    /**
     *	@author Aesir Titan, 2016-08-02 20:08:38
     *
     *	reversal
     */
    ATTabBarAnimationModeReversal
};


// rac double tap signal
@property (strong, nonatomic) RACSubject *didDoubleTapped;
/**
 *	@author Aesir Titan, 2016-08-02 20:08:11
 *
 *	@brief creator
 *
 *	@param mode	animation
 *
 *	@return
 */
- (instancetype)initWithAnimationMode:(ATTabBarAnimationMode)mode;

/**
 *	@author Aesir Titan, 2016-08-02 20:08:11
 *
 *	@brief creator
 *
 *	@param mode	animation
 *
 *	@return
 */
- (instancetype)initWithAnimationMode:(ATTabBarAnimationMode)mode centerButton:(UIButton *)button action:(void (^)())action;

/**
 *	@author Aesir Titan, 2016-08-04 14:08:51
 *
 *	@brief perform rotation mode
 */
- (void)tabbarAnimationWithRotationMode;
/**
 *	@author Aesir Titan, 2016-08-04 14:08:02
 *
 *	@brief perform reversal mode
 */
- (void)tabbarAnimationWithReversalMode;


@end
