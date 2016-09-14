//
//  ATSlider.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-02.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATSlider : UISlider

// thumb
@property (strong, nonatomic) UIImageView *thumb;

// creator
+ (instancetype)sliderWithFrame:(CGRect)frame tintColor:(UIColor *)tint;
+ (instancetype)sliderWithFrame:(CGRect)frame tintColor:(UIColor *)tint thumbImage:(NSString *)image;

// optation
- (ATSlider *(^)(CGFloat))at_animatedValue;

// setting
- (ATSlider *(^)(UIColor *))at_minimumTrackTintColor;
- (ATSlider *(^)(UIColor *))at_maximumTrackTintColor;

- (ATSlider *(^)(CGFloat))at_minimumValue;
- (ATSlider *(^)(CGFloat))at_maximumValue;

- (ATSlider *(^)(NSString *))at_minimumValueImage;
- (ATSlider *(^)(NSString *))at_maximumValueImage;


@end

// child class
#import "ATMaterialSlider.h"

