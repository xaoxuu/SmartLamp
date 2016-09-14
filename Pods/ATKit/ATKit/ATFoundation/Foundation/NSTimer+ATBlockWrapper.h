//
//  NSTimer+ATBlockWrapper.h
//  ATFoundation
//
//  Created by Aesir Titan on 2016-09-02.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface NSTimer (ATBlockWrapper)

/*!
 *	@author Aesir Titan
 *
 *	@brief create a shchedule timer add to current runLoop NSRunLoopCommonModes
 *
 *	@param seconds	time interval
 *	@param repeats	repeat or not
 *	@param block	invoke block
 *
 *	@return a schedule timer
 */
+ (instancetype)at_scheduleTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats usingBlock:(void (^)(NSTimer *timer))block;

/*!
 *	@author Aesir Titan
 *
 *	@brief create a timer
 *
 *	@param seconds	time interval
 *	@param repeats	repeat or not
 *	@param block	invoke block
 *
 *	@return a timer
 */
+ (instancetype)at_timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats usingBlock:(void (^)(NSTimer *timer))block;

/*!
 *	@author Aesir Titan
 *
 *	@brief pause timer
 *
 *	@return success or not
 */
- (BOOL)at_pause;

/*!
 *	@author Aesir Titan
 *
 *	@brief resume timer
 *
 *	@return success or not
 */
- (BOOL)at_resume;

/*!
 *	@author Aesir Titan
 *
 *	@brief resume or pause timer
 *
 *	@return the timer state is running or not
 */
- (BOOL)at_turnover;

/*!
 *	@author Aesir Titan
 *
 *	@brief get the state of timer
 *
 *	@return running or not
 */
- (BOOL)at_isRunning;


@end

NS_ASSUME_NONNULL_END