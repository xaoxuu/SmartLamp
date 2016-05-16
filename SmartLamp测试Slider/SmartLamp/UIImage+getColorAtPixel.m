//
//  UIImage+getColorAtPixel.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-05-14.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "UIImage+getColorAtPixel.h"

@implementation UIImage (getColorAtPixel)

- (UIColor *)getColorAtPixel:(CGPoint)point inImageView:(UIImageView *)imageView{
    
    CGRect imageFrame = CGRectMake(0.0f, 0.0f, imageView.frame.size.width, imageView.frame.size.height);
    
    // Cancel if point is outside image coordinates
    if (!CGRectContainsPoint(imageFrame, point)) {
        return nil;
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -point.x, point.y- imageView.frame.size.height);
    CGContextDrawImage(context, imageFrame, imageView.image.CGImage);
    CGContextRelease(context);
    
    // Convert color values [0..255] to floats [0.0..1.0]
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
}

@end
