//
//  ATSlider.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-02.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ATSlider.h"
#import "ATSlider+Animation.h"

@implementation ATSlider

- (void)awakeFromNib{
    [super awakeFromNib];
    // init
    self.minimumTrackTintColor = atColor.theme;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.subviews.count >= 3) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            self.thumb = self.subviews[2];
        });
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self scaleAnimation];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    [self cancelScaleAnimation];
}

- (ATSlider *(^)(CGFloat))at_animatedValue{
    return ^(CGFloat value){
        [UIView animateWithDuration:0.38f animations:^{
            self.value = value;
        }];
        return self;
    };
}



+ (instancetype)sliderWithFrame:(CGRect)frame tintColor:(UIColor *)tint {
    return [[self alloc] initWithFrame:frame tintColor:tint];
}
- (instancetype)initWithFrame:(CGRect)frame tintColor:(UIColor *)tint {
    if (self = [super initWithFrame:frame]) {
        self.tintColor = tint;
    }
    return self;
}


+ (instancetype)sliderWithFrame:(CGRect)frame tintColor:(UIColor *)tint thumbImage:(NSString *)image {
    return [[self alloc] initWithFrame:frame tintColor:tint thumbImage:image];
}
- (instancetype)initWithFrame:(CGRect)frame tintColor:(UIColor *)tint thumbImage:(NSString *)image {
    if (self = [super initWithFrame:frame]) {
        self.tintColor = tint;
        [self setThumbImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    return self;
}


- (ATSlider *(^)(UIColor *))at_minimumTrackTintColor{
    return ^(UIColor *tint){
        self.minimumTrackTintColor = tint;
        return self;
    };
}
- (ATSlider *(^)(UIColor *))at_maximumTrackTintColor{
    return ^(UIColor *tint){
        self.maximumTrackTintColor = tint;
        return self;
    };
}

- (ATSlider *(^)(CGFloat))at_minimumValue{
    return ^(CGFloat value){
        self.minimumValue = value;
        return self;
    };
}
- (ATSlider *(^)(CGFloat))at_maximumValue{
    return ^(CGFloat value){
        self.maximumValue = value;
        return self;
    };
}

- (ATSlider *(^)(NSString *))at_minimumValueImage{
    return ^(NSString *image){
        self.minimumValueImage = [UIImage imageNamed:image];
        return self;
    };
}
- (ATSlider *(^)(NSString *))at_maximumValueImage{
    return ^(NSString *image){
        self.maximumValueImage = [UIImage imageNamed:image];
        return self;
    };
}



@end
