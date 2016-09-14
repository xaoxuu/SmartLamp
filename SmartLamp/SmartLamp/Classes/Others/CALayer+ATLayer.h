//
//  CALayer+ATLayer.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-05.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#define up1   CGSizeMake(0, -1)
#define down1 CGSizeMake(0, 1)

@interface CALayer (ATLayer)

#pragma mark - shadow

- (CALayer *(^)(UIColor *))at_shadowColor;

- (CALayer *(^)(CGSize))at_shadowOffset;

- (CALayer *(^)(CGFloat))at_shadowRadius;

- (CALayer *(^)(float))at_shadowOpacity;

#pragma mark - border

- (CALayer *(^)(UIColor *))at_borderColor;

- (CALayer *(^)(CGFloat))at_borderWidth;

#pragma mark - corner

- (CALayer *(^)(CGFloat))at_cornerRadius;

@end
