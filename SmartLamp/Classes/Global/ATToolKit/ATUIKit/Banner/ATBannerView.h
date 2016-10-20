//
//  ATBannerView.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-06.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATBannerView : UIView


// timeout
@property (assign, nonatomic) NSTimeInterval timeout;

#pragma mark - creator
/**
 *	@author Aesir Titan, 2016-08-07 15:08:35
 *
 *	@brief create a banner and add to view
 *
 *	@param view		target view
 *	@param name		first image name (without index)
 *	@param count	image count
 *	@param action	image tap action
 *
 *	@return instancetype
 */
+ (instancetype)bannerWithView:(UIView *)view bundleImagesName:(NSString *)name count:(NSUInteger)count action:(void (^)(NSUInteger index))action;

/**
 *	@author Aesir Titan, 2016-08-07 15:08:08
 *
 *	@brief create a banner and add to view
 *
 *	@param view		target view
 *	@param images	images
 *	@param action	image tap action
 *
 *	@return instancetype
 */
+ (instancetype)bannerWithView:(UIView *)view images:(NSArray<UIImage *> *)images action:(void (^)(NSUInteger index))action;

/**
 *	@author Aesir Titan, 2016-08-07 15:08:42
 *
 *	@brief create a banner and add to view
 *
 *	@param view			target view
 *	@param imageURLs	image URLs
 *	@param action		image tap action
 *
 *	@return instancetype
 */
+ (instancetype)bannerWithView:(UIView *)view imageURLs:(NSArray<NSString *> *)imageURLs action:(void (^)(NSUInteger index))action;


/**
 *	@author Aesir Titan, 2016-08-07 15:08:12
 *
 *	@brief create a banner
 *
 *	@param frame	banner frame
 *	@param images	images
 *	@param action	image tap action
 *
 *	@return instancetype
 */
+ (instancetype)bannerWithFrame:(CGRect)frame images:(NSArray<UIImage *> *)images action:(void (^)(NSUInteger index))action;

/**
 *	@author Aesir Titan, 2016-08-07 15:08:43
 *
 *	@brief create a banner
 *
 *	@param frame		banner frame
 *	@param imageURLs	image URLs
 *	@param action		image tap action
 *
 *	@return instancetype
 */
+ (instancetype)bannerWithFrame:(CGRect)frame imageURLs:(NSArray<NSString *> *)imageURLs action:(void (^)(NSUInteger index))action;



@end


