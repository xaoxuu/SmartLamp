//
//  ATColorManager.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-14.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ATColorManager.h"
static ATColorManager *manager;

@implementation ATColorManager

#pragma mark - theme color
// theme color
- (UIColor *)themeColor{
    return self.blue;
}
// dark theme color
- (UIColor *)themeColor_dark{
    return self.blue_dark;
}
// light theme color
- (UIColor *)themeColor_light{
    return self.blue_light;
}
// background color
- (UIColor *)backgroundColor{
    return UIColor.whiteColor;
}

#pragma mark random color
// random color
- (UIColor *)randomColor {
    return [UIColor colorWithRed:(float)(arc4random()%256)/256 green:(float)(arc4random()%256)/256 blue:(float)(arc4random()%256)/256 alpha:1.0];
}


#pragma mark - all color

#pragma mark system
- (UIColor *)clear{
    return [UIColor clearColor];
}

#pragma mark blue
- (UIColor *)blue_light{
    return [UIColor colorWithRed:0.73 green:0.87 blue:0.98 alpha:1.00];
}
- (UIColor *)blue{
    return [UIColor colorWithRed:0.13 green:0.58 blue:0.95 alpha:1.00];
}
- (UIColor *)blue_dark{
    return [UIColor colorWithRed:0.09 green:0.46 blue:0.82 alpha:1.00];
}

#pragma mark light blue
- (UIColor *)lightBlue_light{
    return [UIColor colorWithRed:0.70 green:0.89 blue:0.98 alpha:1.00];
}
- (UIColor *)lightBlue{
    return [UIColor colorWithRed:0.01 green:0.66 blue:0.95 alpha:1.00];
}
- (UIColor *)lightBlue_dark{
    return [UIColor colorWithRed:0.00 green:0.53 blue:0.82 alpha:1.00];
}

#pragma mark green
- (UIColor *)green_light{
    return [UIColor colorWithRed:0.7373 green:0.8824 blue:0.7255 alpha:1.0];
}
- (UIColor *)green{
    return [UIColor colorWithRed:0.1725 green:0.6902 blue:0.3176 alpha:1.0];
}
- (UIColor *)green_dark{
    return [UIColor colorWithRed:0.1843 green:0.4941 blue:0.1255 alpha:1.0];
}

#pragma mark yellow
- (UIColor *)yellow_light{
    return [UIColor colorWithRed:0.9765 green:0.949 blue:0.6824 alpha:1.0];
}
- (UIColor *)yellow{
    return [UIColor colorWithRed:0.9608 green:0.9059 blue:0.3882 alpha:1.0];
}
- (UIColor *)yellow_dark{
    return [UIColor colorWithRed:0.4627 green:0.4392 blue:0.2 alpha:1.0];
}

#pragma mark orange
//- (UIColor *)orange_light{
//    return
//}
- (UIColor *)orange{
    return [UIColor colorWithRed:0.9922 green:0.5255 blue:0.0353 alpha:1.0];
}
//- (UIColor *)orange_dark{
//    return
//}


#pragma mark - life circle

// allocWithZone
+ (id) allocWithZone:(NSZone *)zone{
    if (!manager) {
        // Thread synchronization, guarantee in the case of multi-threaded, also can create an object.
        @synchronized (self) {
            // It won't create a new instance as long as the instance is not released.
            if (!manager) {
                manager = [super allocWithZone:zone];
            }
        }
    }
    return manager;
}

// init
- (instancetype) init{
    if (!manager) {
        @synchronized(self) {
            if (!manager) {
                manager = [[ATColorManager alloc] init];
            }
        }
    }
    return manager;
}

// copyWithZone
+ (id)copyWithZone:(struct _NSZone *)zone
{
    return [self sharedColorManager];
}

// copyWithZone
- (id)copyWithZone:(struct _NSZone *)zone
{
    return [ATColorManager sharedColorManager];
}

// mutableCopyWithZone
+ (id)mutableCopyWithZone:(struct _NSZone *)zone
{
    return [self sharedColorManager];
}

// mutableCopyWithZone
- (id)mutableCopyWithZone:(struct _NSZone *)zone
{
    return [ATColorManager sharedColorManager];
}

// copy
+ (id)copy
{
    return [ATColorManager sharedColorManager];
}


#pragma mark creator

// defaultCentralManager
+ (instancetype)defaultColorManager{
    
    return [self sharedColorManager];
    
}

// sharedCentralManager
+ (instancetype)sharedColorManager{
    if (!manager) {
        // Thread synchronization, guarantee in the case of multi-threaded, also can create an object.
        @synchronized (self) {
            // It won't create a new instance as long as the instance is not released.
            if (!manager) {
                manager = [[ATColorManager alloc]init];
            }
        }
    }
    return manager;
}



@end
