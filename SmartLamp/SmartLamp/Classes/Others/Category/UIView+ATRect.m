//
//  UIView+ATRect.m
//  QNZ
//
//  Created by Aesir Titan on 2016-07-12.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "UIView+ATRect.h"

@implementation UIView (ATRect)
- (CGPoint)at_origin
{
    return self.frame.origin;
}

- (void)setAt_origin:(CGPoint)at_origin
{
    CGRect frame = self.frame;
    frame.origin = at_origin;
    self.frame = frame;
}
- (CGSize)at_size
{
    return self.frame.size;
}

- (void)setAt_size:(CGSize)at_size
{
    CGRect frame = self.frame;
    frame.size = at_size;
    self.frame = frame;
}

- (CGFloat)at_width
{
    return self.frame.size.width;
}

- (CGFloat)at_height
{
    return self.frame.size.height;
}

- (void)setAt_width:(CGFloat)at_width
{
    CGRect frame = self.frame;
    frame.size.width = at_width;
    self.frame = frame;
}

- (void)setAt_height:(CGFloat)at_height
{
    CGRect frame = self.frame;
    frame.size.height = at_height;
    self.frame = frame;
}

- (CGFloat)at_x
{
    return self.frame.origin.x;
}

- (void)setAt_x:(CGFloat)at_x
{
    CGRect frame = self.frame;
    frame.origin.x = at_x;
    self.frame = frame;
}

- (CGFloat)at_y
{
    return self.frame.origin.y;
}

- (void)setAt_y:(CGFloat)at_y
{
    CGRect frame = self.frame;
    frame.origin.y = at_y;
    self.frame = frame;
}

- (CGFloat)at_centerX
{
    return self.center.x;
}

- (void)setAt_centerX:(CGFloat)at_centerX
{
    CGPoint center = self.center;
    center.x = at_centerX;
    self.center = center;
}

- (CGFloat)at_centerY
{
    return self.center.y;
}

- (void)setAt_centerY:(CGFloat)at_centerY
{
    CGPoint center = self.center;
    center.y = at_centerY;
    self.center = center;
}

- (CGFloat)at_right
{
    //    return self.at_x + self.at_width;
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)at_bottom
{
    //    return self.at_y + self.at_height;
    return CGRectGetMaxY(self.frame);
}

- (void)setAt_right:(CGFloat)at_right
{
    self.at_x = at_right - self.at_width;
}

- (void)setAt_bottom:(CGFloat)at_bottom
{
    self.at_y = at_bottom - self.at_height;
}
@end
