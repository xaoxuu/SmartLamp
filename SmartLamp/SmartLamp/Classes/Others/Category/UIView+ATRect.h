//
//  UIView+ATRect.h
//  QNZ
//
//  Created by Aesir Titan on 2016-07-12.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ATRect)
@property (nonatomic, assign) CGPoint at_origin;
@property (nonatomic, assign) CGSize  at_size;

@property (nonatomic, assign) CGFloat at_width;
@property (nonatomic, assign) CGFloat at_height;

@property (nonatomic, assign) CGFloat at_x;
@property (nonatomic, assign) CGFloat at_y;

@property (nonatomic, assign) CGFloat at_centerX;
@property (nonatomic, assign) CGFloat at_centerY;

@property (nonatomic, assign) CGFloat at_right;
@property (nonatomic, assign) CGFloat at_bottom;
@end
