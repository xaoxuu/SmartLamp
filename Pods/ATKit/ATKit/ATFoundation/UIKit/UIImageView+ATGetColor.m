//
//  UIImageView+ATGetColor.m
//  ATFoundation
//
//  Created by Aesir Titan on 2016-08-28.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "UIImageView+ATGetColor.h"

@implementation UIImageView (ATGetColor)

#pragma mark - get red green blue alpha
// get red green blue alpha with point
- (void)at_getRed:(nullable CGFloat *)red green:(nullable CGFloat *)green blue:(nullable CGFloat *)blue alpha:(nullable CGFloat *)alpha withPoint:(CGPoint)point{
    // ==================== [ filter ] ==================== //
    // frame of image
    const CGRect imageFrame = CGRectMake(0.0f, 0.0f,
                                         self.frame.size.width, self.frame.size.height);
    // Cancel if point is outside image coordinates
    if (!CGRectContainsPoint(imageFrame, point)) {
        return;
    }
    
    // ==================== [ function ] ==================== //
    // Create RGB color space
    const CGColorSpaceRef colorSpaceRGB  = CGColorSpaceCreateDeviceRGB();
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,1,1,8,4,colorSpaceRGB,kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpaceRGB);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -point.x, point.y- self.frame.size.height);
    CGContextDrawImage(context, imageFrame, self.image.CGImage);
    CGContextRelease(context);
    
    // Convert color values [0..255] to floats [0.0..1.0]
    *red   = (CGFloat)pixelData[0] / 255.0f;
    *green = (CGFloat)pixelData[1] / 255.0f;
    *blue  = (CGFloat)pixelData[2] / 255.0f;
    *alpha = (CGFloat)pixelData[3] / 255.0f;
    
}

// get red green blue alpha with point and completion
- (void)at_getRGBAWithPoint:(CGPoint)point completion:(void(^)(CGFloat red,CGFloat green,CGFloat blue,CGFloat alpha))completion {
    // ==================== [ function ] ==================== //
    CGFloat red,green,blue,alpha;
    [self at_getRed:&red green:&green blue:&blue alpha:&alpha withPoint:point];
    completion(red,green,blue,alpha);
}

// get red green blue alpha from circle with point and completion
- (void)at_getRGBAFromCircleWithPoint:(CGPoint)point completion:(void(^)(CGFloat red,CGFloat green,CGFloat blue,CGFloat alpha))completion {
    // ==================== [ filter ] ==================== //
    CGFloat inset = self.layer.borderWidth + self.layer.shadowRadius + 1;
    CGFloat r = 0.5 * (self.frame.size.width - inset);
    CGFloat x = point.x - r - 0.75*inset;
    CGFloat y = point.y - r - 0.75*inset;
    // ==================== [ function ] ==================== //
    // When the touch point is inside palette coordinates.
    if (powf(x,2) + powf(y, 2) < powf(r, 2)) {
        [self at_getRGBAWithPoint:point completion:completion];
    }
}


#pragma mark - get color
// get color with point
- (UIColor *)at_getColorWithPoint:(CGPoint)point{
    // ==================== [ filter ] ==================== //
    // frame of image
    const CGRect imageFrame = CGRectMake(0.0f, 0.0f,
                                         self.frame.size.width, self.frame.size.height);
    // Cancel if point is outside image coordinates
    if (!CGRectContainsPoint(imageFrame, point)) {
        return nil;
    }
    
    // ==================== [ function ] ==================== //
    // get color with point
    CGFloat red,green,blue,alpha;
    [self at_getRed:&red green:&green blue:&blue alpha:&alpha withPoint:point];
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
}

// get color with point and completion
- (void)at_getColorWithPoint:(CGPoint)point completion:(void(^)(UIColor *color))completion {
    // ==================== [ function ] ==================== //
    UIColor *color = [self at_getColorWithPoint:point];
    if (color && completion) {
        completion(color);
    }
}

// get color from circle with point and completion
- (void)at_getColorFromCircleWithPoint:(CGPoint)point completion:(void(^)(UIColor *color))completion {
    // ==================== [ filter ] ==================== //
    CGFloat inset = self.layer.borderWidth + self.layer.shadowRadius + 1;
    CGFloat r = 0.5 * (self.frame.size.width - inset);
    CGFloat x = point.x - r - 0.75*inset;
    CGFloat y = point.y - r - 0.75*inset;
    // ==================== [ function ] ==================== //
    // When the touch point is inside palette coordinates.
    if (powf(x,2) + powf(y, 2) < powf(r, 2)) {
        [self at_getColorWithPoint:point completion:completion];
    }
}


@end
