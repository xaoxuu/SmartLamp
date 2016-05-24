//
//  ATProfiles.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-05-10.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ATProfiles : NSObject <NSCoding>

// 动画枚举
typedef NS_ENUM(NSUInteger,ColorAnimation){
    
    ColorAnimationNone,
    ColorAnimationSaltusStep3,
    ColorAnimationSaltusStep7,
    ColorAnimationGratation,
    
};

// 情景模式名称
@property (copy, nonatomic) NSString *title;

// 情景模式的详情描述
@property (copy, nonatomic) NSString *detail;

// 情景模式的图标
@property (strong, nonatomic) UIImage *image;

// 定时关灯的时间
@property (assign, nonatomic) NSInteger timer;

// 颜色显示模式(动画还是单色)
@property (assign, nonatomic) ColorAnimation colorAnimation;

// 单色模式的颜色
@property (strong, nonatomic) UIColor *color;

// 单色模式的亮度
@property (assign, nonatomic) CGFloat brightness;

// 构造方法
+ (ATProfiles *)defaultProfiles;



@end
