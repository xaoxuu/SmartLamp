//
//  ATRippleView.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-26.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDRippleLayer.h"

@interface ATRippleView : UIView

// layer
@property (strong, readonly, nonatomic) MDRippleLayer *mdLayer;
// ripple color
@property (strong, nonatomic) UIColor *rippleColor;

- (void)initRippleLayer;

@end
