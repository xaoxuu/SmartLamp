//
//  UIView+ATAnimationWrapper.h
//  ATFoundation
//
//  Created by Aesir Titan on 2016-08-27.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ATAnimationWrapper)


#pragma mark - build in
/*!
 *	@author Aesir Titan, 2016-08-27
 *
 *	@brief build in animation with scale
 *
 *	@param scale		scale
 *	@param duration		duration
 *	@param completion	completion
 */
- (void)at_animatedScaleIn:(CGFloat)scale duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;

#pragma mark - action

/*!
 *	@author Aesir Titan, 2016-08-27
 *
 *	@brief action animation with scale
 *
 *	@param scale		scale
 *	@param duration		duration
 *	@param completion	completion
 */
- (void)at_animatedScale:(CGFloat)scale duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;


#pragma mark - build out
/*!
 *	@author Aesir Titan, 2016-08-27
 *
 *	@brief build out animation with scale
 *
 *	@param scale		scale
 *	@param duration		duration
 *	@param completion	completion
 */
- (void)at_animatedScaleOut:(CGFloat)scale duration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion;


@end
