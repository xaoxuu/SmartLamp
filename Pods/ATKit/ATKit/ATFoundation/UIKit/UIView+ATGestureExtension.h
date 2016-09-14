//
//  UIView+ATGestureExtension.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-09.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ATGestureExtension)

/*!
 *	@author Aesir Titan, 2016-09-01
 *
 *	@brief add a simple tap gesture to view
 *
 *	@param handler	handle block
 */
- (void)at_addTapGestureHandler:(void (^)(UITapGestureRecognizer *sender))handler;

/*!
 *	@author Aesir Titan, 2016-09-01
 *
 *	@brief add a tap gesture to view
 *
 *	@param tap		tap gesture
 *	@param handler	handle block
 */
- (void)at_addTapGesture:(nullable void (^)(UITapGestureRecognizer *sender))tap handler:(void (^)(UITapGestureRecognizer *sender))handler;

/*!
 *	@author Aesir Titan, 2016-09-01
 *
 *	@brief add a tap gesture handler to view and perform animation
 *
 *	@param tap		tap gesture
 *	@param handler	handle block
 *	@param scale	transform scale
 *	@param duration	animation duration
 */
- (void)at_addTapGesture:(nullable void (^)(UITapGestureRecognizer *sender))tap handler:(void (^)(UITapGestureRecognizer *sender))handler animatedScale:(CGFloat)scale duration:(NSTimeInterval)duration;

/*!
 *	@author Aesir Titan, 2016-09-01
 *
 *	@brief add a double-tap gesture to view
 *
 *	@param doubleTap	double tap gesture
 *	@param duration     double tap duration
 *	@param handler		handle block
 */
- (void)at_addDoubleTapGesture:(nullable void (^)(UITapGestureRecognizer *sender))doubleTap duration:(NSTimeInterval)duration handler:(void (^)(UITapGestureRecognizer *sender))handler;

/*!
 *	@author Aesir Titan, 2016-09-01
 *
 *	@brief add a long press gesture to view
 *
 *	@param longPress	long press gesture
 *	@param handler		handle block
 */
- (void)at_addLongPressGesture:(nullable void (^)(UILongPressGestureRecognizer *sender))longPress handler:(void (^)(UILongPressGestureRecognizer *sender))handler;

/*!
 *	@author Aesir Titan, 2016-09-01
 *
 *	@brief add a swipe gesture to view
 *
 *	@param swipe		swipe gesture
 *	@param handler	    handle block
 */
- (void)at_addSwipeGesture:(nullable void (^)(UISwipeGestureRecognizer *sender))swipe handler:(void (^)(UISwipeGestureRecognizer *sender))handler;

/*!
 *	@author Aesir Titan, 2016-09-01
 *
 *	@brief add a pan gesture to view
 *
 *	@param pan			pan gesture
 *	@param handler	    handle block
 */
- (void)at_addPanGesture:(nullable void (^)(UIPanGestureRecognizer *sender))pan handler:(void (^)(UIPanGestureRecognizer *sender))handler;

/*!
 *	@author Aesir Titan, 2016-09-01
 *
 *	@brief add a screen edge pan gesture to view
 *
 *	@param screenEdgePan	screenEdgePan gesture
 *	@param handler			handle block
 */
- (void)at_addScreenEdgePanGesture:(nullable void (^)(UIScreenEdgePanGestureRecognizer *sender))screenEdgePan handler:(void (^)(UIScreenEdgePanGestureRecognizer *sender))handler;

/*!
 *	@author Aesir Titan, 2016-09-01
 *
 *	@brief add a pinch gesture to view
 *
 *	@param pinch		pinch gesture
 *	@param handler	    handle block
 
 sender.view.transform = CGAffineTransformScale(sender.view.transform, sender.scale, sender.scale);
 sender.scale = 1;
 
 */
- (void)at_addPinchGesture:(nullable void (^)(UIPinchGestureRecognizer *sender))pinch handler:(void (^)(UIPinchGestureRecognizer *sender))handler;

/*!
 *	@author Aesir Titan, 2016-09-01
 *
 *	@brief add a rotation gesture to view
 *
 *	@param rotation	rotation gesture
 *	@param handler	handle block
 
 rotation.view.transform = CGAffineTransformRotate(sender.view.transform, sender.rotation);
 sender.rotation = 0;

 */
- (void)at_addRotationGesture:(nullable void (^)(UIRotationGestureRecognizer *sender))rotation handler:(void (^)(UIRotationGestureRecognizer *sender))handler;


@end

NS_ASSUME_NONNULL_END
