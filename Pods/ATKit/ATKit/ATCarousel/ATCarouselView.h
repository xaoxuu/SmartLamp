//
//  ATCarouselView.h
//  ATCarouselView
//
//  Created by Aesir Titan on 2016-08-25.
//  Copyright © 2016 Titan Studio. All rights reserved.
//
/****************************************************
 
 个人主页：      https://xaoxuu.com
 团队GitHub主页：https://github.com/TitanStudio
 ATKit项目主页： https://xaoxuu.com/atkit
 
 ****************************************************/



#import <UIKit/UIKit.h>

@interface ATCarouselView : UIView

#pragma mark - creator

/*!
 *	@author Aesir Titan, 2016-08-28
 *
 *	@brief create a carousel view
 *
 *	@param view			super view
 *	@param count		image count
 *	@param image		request image from controller
 *	@param title        request title from controller
 *	@param indicator	request indicator frame from controller
 *	@param timeout		slide timerout
 *	@param action		tap action
 *
 *	@return instancetype
 */
+ (instancetype)carouselWithView:(UIView *)view
                           count:(NSUInteger)count
                           image:(void (^)(UIImageView *imageView,NSUInteger index))image
                           title:(NSString *(^)(NSUInteger index))title
                       indicator:(void (^)(UIPageControl *indicator))indicator
                         timeout:(NSTimeInterval)timeout
                          action:(void (^)(NSUInteger index))action;

- (instancetype)initWithView:(UIView *)view
                           count:(NSUInteger)count
                           image:(void (^)(UIImageView *imageView,NSUInteger index))image
                           title:(NSString *(^)(NSUInteger index))title
                       indicator:(void (^)(UIPageControl *indicator))indicator
                         timeout:(NSTimeInterval)timeout
                          action:(void (^)(NSUInteger index))action;

/*!
 *	@author Aesir Titan
 *
 *	@brief start slide with timer
 */
-(void)startAutoSlide;

/*!
 *	@author Aesir Titan
 *
 *	@brief stop slide with timer
 */
-(void)stopAutoSlide;

@end


