//
//  UIImage+getColorAtPixel.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-05-14.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (getColorAtPixel)

- (UIColor *)getColorAtPixel:(CGPoint)point inImageView:(UIImageView *)imageView;

@end
