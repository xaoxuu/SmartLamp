//
//  TitleButton.m
//  ATTabBarControllerDemo
//
//  Created by Aesir Titan on 2016-08-23.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "TitleButton.h"
#import "MDRippleLayer.h"

@interface TitleButton ()

// layer
@property (strong, nonatomic) MDRippleLayer *mdLayer;

@end

@implementation TitleButton

- (void)awakeFromNib{
    [super awakeFromNib];
    [self initRippleLayer];
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initRippleLayer];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initRippleLayer];
    }
    return self;
}
- (void)setRippleColor:(UIColor *)rippleColor {
    _rippleColor = rippleColor;
    [_mdLayer setEffectColor:rippleColor];
}


// init UI
- (void)initRippleLayer{
    if (!_rippleColor)
        _rippleColor = [UIColor colorWithWhite:0.5 alpha:1];
    
    _mdLayer = [[MDRippleLayer alloc] initWithSuperView:self];
    _mdLayer.effectColor = _rippleColor;
    _mdLayer.rippleScaleRatio = 1;
    _mdLayer.enableElevation = NO;
    
}

@end
