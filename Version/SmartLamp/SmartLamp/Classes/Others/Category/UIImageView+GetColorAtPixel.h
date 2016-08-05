//
//  UIImageView+GetColorAtPixel.h
//  UIImageView+GetColorAtPixel
//
//  Created by Aesir Titan on 2016-05-20.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (GetColorAtPixel)

// Get color at pixel from UIImageView
// 从UIImageView中获取指定点的UIColor对象
- (UIColor *)at_getColorAtPixel:(CGPoint)point;

@end
