//
//  ATCarouselView.h
//  ATCarouselView
//
//  Created by Aesir Titan on 2016-08-25.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

//  >>>>>>>>>>>>>>>>>>>>  Aesir Titan  <<<<<<<<<<<<<<<<<<<<
//  >>                                                   <<
//  >>  http://ayan.site                                 <<  (我的主页)
//  >>  http://github.com/AesirTitan)                    <<  (github主页)
//  >>  http://nexusonline.github.io)                    <<  (macOS应用下载站)
//  >>  http://www.jianshu.com/notebooks/6236581/latest) <<  (ATKit使用文档)
//  >>                                                   <<
//  >>>>>>>>>>>>>>>>>>>>  Aesir Titan  <<<<<<<<<<<<<<<<<<<<



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


