//
//  UIControl+ATBlockWrapper.h
//  ATFoundation
//
//  Created by Aesir Titan on 2016-09-01.
//  Copyright © 2016 Titan Studio. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** Block control event handling for UIControl.
 
 Includes code by the following:
 
 - [Kevin O'Neill](https://github.com/kevinoneill)
 - [Zach Waldowski](https://github.com/zwaldowski)
 
 @warning UIControl is only available on a platform with UIKit.
 */
#pragma mark - UIControl
@interface UIControl (ATBlockWrapper)

///-----------------------------------
/// @name Block event handling
///-----------------------------------

/** Adds a block for a particular event to an internal dispatch table.
 
 @param handler A block representing an action message, with an argument for the sender.
 @param controlEvents A bitmask specifying the control events for which the action message is sent.
 @see removeEventHandlersForControlEvents:
 */
- (void)at_addEventHandler:(void (^)(__kindof UIControl *sender))handler forControlEvents:(UIControlEvents)controlEvents;

/** Removes all control event blocks associated with the given mask of control
 * events.
 *
 * Do note that, like @c UIControl, this method will not decompose control
 * events; thus, only a handler matching an exact given bitmask will be removed.
 *
 * @param controlEvents A bitmask specifying the control events for which the block will be removed.
 * @see addEventHandler:forControlEvents:
 */
- (void)at_removeEventHandlersForControlEvents:(UIControlEvents)controlEvents;

/** Checks to see if the control has any blocks for a particular event combination.
 @param controlEvents A bitmask specifying the control events for which to check for blocks.
 @see addEventHandler:forControlEvents:
 @return Returns YES if there are blocks for these control events, NO otherwise.
 */
- (NSUInteger)at_hasEventHandlersForControlEvents:(UIControlEvents)controlEvents;

@end

#pragma mark - UIButton
@interface UIButton (ATBlockWrapper)

/*!
 *	@author Aesir Titan, 2016-09-01
 *
 *	@brief add a handler to button
 *
 *	@param handler			handle block
 *	@param controlEvents	control events
 */
- (void)at_addEventHandler:(void (^)(UIButton *sender))handler forControlEvents:(UIControlEvents)controlEvents;

/*!
 *	@author Aesir Titan, 2016-09-01
 *
 *	@brief add a touch down handler to button
 *
 *	@param handler			handle block
 */
- (void)at_addTouchDownHandler:(void (^)(UIButton *sender))handler;

/*!
 *	@author Aesir Titan, 2016-09-01
 *
 *	@brief add a touch up inside handler to button
 *
 *	@param handler			handle block
 */
- (void)at_addTouchUpInsideHandler:(void (^)(UIButton *sender))handler;

/*!
 *	@author Aesir Titan, 2016-09-02
 *
 *	@brief add a touch up inside handler to button and perform animation
 *
 *	@param handler		handle block
 *	@param scale		transform scale
 *	@param duration     animation duration
 */
- (void)at_addTouchUpInsideHandler:(nullable void (^)(UIButton *sender))handler animatedScale:(CGFloat)scale duration:(NSTimeInterval)duration;


@end

#pragma mark - UISlider
@interface UISlider (ATBlockWrapper)

/*!
 *	@author Aesir Titan, 2016-09-01
 *
 *	@brief add a handler to slider
 *
 *	@param handler			handle block
 *	@param controlEvents	control events
 */
- (void)at_addEventHandler:(void (^)(UISlider *sender))handler forControlEvents:(UIControlEvents)controlEvents;

/*!
 *	@author Aesir Titan, 2016-09-01
 *
 *	@brief add a touch down handler to slider
 *
 *	@param handler			handle block
 */
- (void)at_addTouchDownHandler:(void (^)(UISlider *sender))handler;

/*!
 *	@author Aesir Titan, 2016-09-01
 *
 *	@brief add a touch down handler to slider and perform animation
 *
 *	@param handler			handle block
 */
- (void)at_addTouchDownHandler:(nullable void (^)(UISlider *sender))handler animatedScale:(CGFloat)scale duration:(NSTimeInterval)duration;

/*!
 *	@author Aesir Titan, 2016-09-01
 *
 *	@brief add a value changed handler to slider
 *
 *	@param handler			handle block
 */
- (void)at_addValueChangedHandler:(void (^)(UISlider *sender))handler;

/*!
 *	@author Aesir Titan, 2016-09-01
 *
 *	@brief add a touch up inside&outside handler to slider
 *
 *	@param handler			handle block
 */
- (void)at_addTouchUpHandler:(void (^)(UISlider *sender))handler;

/*!
 *	@author Aesir Titan, 2016-09-01
 *
 *	@brief add a touch up inside&outside handler to slider and perform animation
 *
 *	@param handler			handle block
 */
- (void)at_addTouchUpHandler:(nullable void (^)(UISlider *sender))handler animatedScale:(CGFloat)scale duration:(NSTimeInterval)duration;


@end

#pragma mark - UISwitch
@interface UISwitch (ATBlockWrapper)

/*!
 *	@author Aesir Titan, 2016-09-01
 *
 *	@brief add a handler to switch
 *
 *	@param handler			handle block
 *	@param controlEvents	control events
 */
- (void)at_addEventHandler:(void (^)(UISwitch *sender))handler forControlEvents:(UIControlEvents)controlEvents;

/*!
 *	@author Aesir Titan, 2016-09-01
 *
 *	@brief add a touch down handler to switch
 *
 *	@param handler			handle block
 */
- (void)at_addTouchDownHandler:(void (^)(UISwitch *sender))handler;

/*!
 *	@author Aesir Titan, 2016-09-01
 *
 *	@brief add a value changed handler to switch
 *
 *	@param handler			handle block
 */
- (void)at_addValueChangedHandler:(void (^)(UISwitch *sender))handler;

/*!
 *	@author Aesir Titan, 2016-09-01
 *
 *	@brief add a touch up inside handler to switch
 *
 *	@param handler			handle block
 */
- (void)at_addTouchUpInsideHandler:(void (^)(UISwitch *sender))handler;

@end

#pragma mark - UISegmentedControl
@interface UISegmentedControl (ATBlockWrapper)

/*!
 *	@author Aesir Titan, 2016-09-01
 *
 *	@brief add a handler to segmentedControl
 *
 *	@param handler			handle block
 *	@param controlEvents	control events
 */
- (void)at_addEventHandler:(void (^)(UISegmentedControl *sender))handler forControlEvents:(UIControlEvents)controlEvents;

/*!
 *	@author Aesir Titan, 2016-09-01
 *
 *	@brief add a value changed handler to segmentedControl
 *
 *	@param handler			handle block
 */
- (void)at_addValueChangedHandler:(void (^)(UISegmentedControl *sender))handler;


@end

#pragma mark - UITextField
@interface UITextField (ATBlockWrapper)

/*!
 *	@author Aesir Titan, 2016-09-01
 *
 *	@brief add a handler to textField
 *
 *	@param handler			handle block
 *	@param controlEvents	control events
 */
- (void)at_addEventHandler:(void (^)(UITextField *sender))handler forControlEvents:(UIControlEvents)controlEvents;

/*!
 *	@author Aesir Titan, 2016-09-01
 *
 *	@brief add a editing begin handler to textField
 *
 *	@param handler			handle block
 */
- (void)at_addEditingBeginHandler:(void (^)(UITextField *sender))handler;

/*!
 *	@author Aesir Titan, 2016-09-01
 *
 *	@brief add a editing begin handler to textField
 *
 *	@param handler			handle block
 */
- (void)at_addEditingBeginHandler:(nullable void (^)(UITextField *sender))handler animatedScale:(CGFloat)scale duration:(NSTimeInterval)duration;

/*!
 *	@author Aesir Titan, 2016-09-01
 *
 *	@brief add a editing changed handler to textField
 *
 *	@param handler			handle block
 */
- (void)at_addEditingChangedHandler:(void (^)(UITextField *sender))handler;

/*!
 *	@author Aesir Titan, 2016-09-01
 *
 *	@brief add a editing end on exit handler to textField
 *
 *	@param handler			handle block
 */
- (void)at_addEditingEndOnExitHandler:(void (^)(UITextField *sender))handler;

/*!
 *	@author Aesir Titan, 2016-09-01
 *
 *	@brief add a editing end handler to textField
 *
 *	@param handler			handle block
 */
- (void)at_addEditingEndHandler:(void (^)(UITextField *sender))handler;

/*!
 *	@author Aesir Titan, 2016-09-01
 *
 *	@brief add a editing end handler to textField
 *
 *	@param handler			handle block
 */
- (void)at_addEditingEndHandler:(nullable void (^)(UITextField *sender))handler animatedScale:(CGFloat)scale duration:(NSTimeInterval)duration;


@end


NS_ASSUME_NONNULL_END
