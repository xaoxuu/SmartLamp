//
//  UIImage+ATEnhance.h
//  ATFoundation
//
//  Created by Aesir Titan on 2016-08-28.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ATExtension)

#pragma mark - load image

/*!
 *	@author Aesir Titan, 2016-09-02
 *
 *	@brief load a image from bundle
 *
 *	@param name	image name
 *
 *	@return a image
 */
+ (UIImage *)at_imageWithBundleImageName:(NSString *)name;

/*!
 *	@author Aesir Titan, 2016-09-02
 *
 *	@brief load a lot images from bundle
 *
 *	@param name	    the first image name without serial number <image>
 *	@param count	image count
 *
 *	@return  images array <image0,image1,image2, ...>
 */
+ (NSArray<UIImage *> *)at_imageWithBundleImageName:(NSString *)name count:(NSUInteger)count;

#pragma mark - convert a rectangle image to circle image


/*!
 *	@author Aesir Titan, 2016-09-05
 *
 *	@brief create a rounded view
 *
 *	@return a rounded view
 */
- (UIImage *)at_roundedImage;


#pragma mark - create a purity image

/*!
 *	@author Aesir Titan, 2016-08-28
 *
 *	@brief create a purity image
 *
 *	@param color	image color
 *	@param size     image size
 *	@param alpha	image alpha
 *
 *	@return a purity image
 */
+ (UIImage *)at_imageWithColor:(UIColor *)color size:(CGSize)size alpha:(float)alpha;

#pragma mark - get blur effect image

/*!
 *	@author Aesir Titan, 2016-08-28
 *
 *	@brief get a blur effect image
 *
 *	@param factor	blur factor
 *
 *	@return a blur effect image
 */
- (UIImage *)at_blurEffectWithFactor:(CGFloat)factor;

/*!
 *	@author Aesir Titan, 2016-08-28
 *
 *	@brief get a blur effect image and do something
 *
 *	@param factor		blur factor
 *	@param completion	do something
 */
- (void)at_blurEffectWithFactor:(CGFloat)factor completion:(void (^)(UIImage *image))completion;


@end




