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


- (void)at_setThemeColor:(UIColor *)theme backgroundColor:(UIColor *)bgColor {
    self.themeColor = theme;
    self.backgroundColor = bgColor;
    
    
    
}


#pragma mark ♻️ 单例实现

// allocWithZone
+ (id) allocWithZone:(NSZone *)zone
{
    
    if (!manager) {  //防止频繁加锁
        
        // Thread synchronization, guarantee in the case of multi-threaded, also can create an object.
        // 线程同步, 保证在多线程的情况下, 也只能创建出一个对象
        @synchronized (self) {
            // It won't create a new instance as long as the instance is not released.
            // 只要实例没有被释放, 就不会创建新的实例
            if (!manager) {
                manager = [super allocWithZone:zone];
            }
        }
        
    }
    
    return manager;
    
}

// init
- (id) init
{
    
    if (!manager) {  //防止频繁加锁
        
        @synchronized(self) {  //多线程情况下，加锁，避免多次实例化
            
            if (!manager) {  //防止已经实例化的情况下，再次实例化
                
                manager = [[ATColorManager alloc] init];
                
            }
            
        }
        
    }
    #pragma mark 🍀 颜色
    // 在这里初始化对象属性
    _blueColor = [UIColor colorWithRed:0.13 green:0.58 blue:0.95 alpha:1.00];
    _blueColor_dark = [UIColor colorWithRed:0.09 green:0.46 blue:0.82 alpha:1.00];
    _blueColor_light = [UIColor colorWithRed:0.73 green:0.87 blue:0.98 alpha:1.00];
    
    _lightblueColor = [UIColor colorWithRed:0.01 green:0.66 blue:0.95 alpha:1.00];
    _lightblueColor_dark = [UIColor colorWithRed:0.00 green:0.53 blue:0.82 alpha:1.00];
    _lightblueColor_light = [UIColor colorWithRed:0.70 green:0.89 blue:0.98 alpha:1.00];
    
    _greenColor = [UIColor colorWithRed:0.1725 green:0.6902 blue:0.3176 alpha:1.0];
    _greenColor_dark = [UIColor colorWithRed:0.1843 green:0.4941 blue:0.1255 alpha:1.0];
    _greenColor_light = [UIColor colorWithRed:0.7373 green:0.8824 blue:0.7255 alpha:1.0];
    
    _redColor = [UIColor colorWithRed:0.8902 green:0.2157 blue:0.1686 alpha:1.0];
    _orangeColor = [UIColor colorWithRed:0.9922 green:0.5255 blue:0.0353 alpha:1.0];
    
    _yellowColor = [UIColor colorWithRed:0.9961 green:0.9176 blue:0.0 alpha:1.0];
    
    _yellow1Color = [UIColor colorWithRed:0.9608 green:0.9059 blue:0.3882 alpha:1.0];
    _yellow1Color_light = [UIColor colorWithRed:0.9765 green:0.949 blue:0.6824 alpha:1.0];
    _yellow1Color_dark = [UIColor colorWithRed:0.4627 green:0.4392 blue:0.2 alpha:1.0];
    
    
    
    _themeColor = _blueColor;
//    _themeColor = _orangeColor;
    _themeColor_dark = _blueColor_dark;
    _themeColor_light = _blueColor_light;
    
    _backgroundColor = [UIColor whiteColor];
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


#pragma mark 📦 构造方法

// 构造方法 defaultCentralManager  (可以用此方法快速创建一个单例对象)
+ (instancetype)defaultColorManager{
    
    return [self sharedColorManager];
    
}

// sharedCentralManager
+ (instancetype)sharedColorManager
{
    
    if (!manager) {  //防止频繁加锁
        
        // Thread synchronization, guarantee in the case of multi-threaded, also can create an object.
        // 线程同步, 保证在多线程的情况下, 也只能创建出一个对象
        @synchronized (self) {
            // It won't create a new instance as long as the instance is not released.
            // 只要实例没有被释放, 就不会创建新的实例
            if (!manager) {
                manager = [[ATColorManager alloc]init];
            }
        }
        
    }
    
    return manager;
    
}

- (UIColor *)randomColor {
    return [UIColor colorWithRed:(float)(arc4random()%256)/256 green:(float)(arc4random()%256)/256 blue:(float)(arc4random()%256)/256 alpha:1.0];
}




@end
