//
//  CIImage+ATScaleExtension.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-15.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <CoreImage/CoreImage.h>
#import <UIKit/UIKit.h>

@interface CIImage (ATScaleExtension)

/**
 *	@author Aesir Titan, 2016-08-15 22:08:10
 *
 *	@brief create a noninterpolated image
 *
 *	@param widthAndHeight	WidthAndHeight
 *
 *	@return uiimage
 */
- (UIImage *)at_createNonInterpolatedWithWidthAndHeight:(CGFloat)widthAndHeight;

/**
 *	@author Aesir Titan, 2016-08-15 22:08:41
 *
 *	@brief create a noninterpolated image
 *
 *	@param scale	scale
 *
 *	@return uiimage
 */
- (UIImage *)at_createNonInterpolatedWithScale:(CGFloat)scale;

/**
 *	@author Aesir Titan, 2016-08-15 22:08:48
 *
 *	@brief create a noninterpolated image
 *
 *	@param size	size
 *
 *	@return uiimage
 */
- (UIImage *)at_createNonInterpolatedWithCGSize:(CGSize)size;


@end
