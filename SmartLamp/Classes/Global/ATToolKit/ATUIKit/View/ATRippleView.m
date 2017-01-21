//
//  ATRippleView.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-26.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "ATRippleView.h"



@interface ATRippleView ()




@end
@implementation ATRippleView


- (void)awakeFromNib {
    // Initialization code
    [self initRippleLayer];
    [super awakeFromNib];
}

- (instancetype)init {
    if (self = [super init]) {
        [self initRippleLayer];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initRippleLayer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initRippleLayer];
    }
    return self;
}


- (void)initRippleLayer {
    if (!_rippleColor)
        _rippleColor = [UIColor colorWithWhite:0.8 alpha:0.1];
    
    _mdLayer = [[MDRippleLayer alloc] initWithSuperLayer:self.layer];
    _mdLayer.effectColor = _rippleColor;
    _mdLayer.rippleScaleRatio = 1;
    _mdLayer.effectSpeed = 300;
    
    _mdLayer.enableElevation = NO;
}

- (void)setRippleColor:(UIColor *)rippleColor {
    _rippleColor = rippleColor;
    [_mdLayer setEffectColor:rippleColor];
}


#pragma mark touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    CGPoint point = [touches.allObjects[0] locationInView:self];
    [_mdLayer startEffectsAtLocation:point];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [_mdLayer stopEffectsImmediately];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [_mdLayer stopEffects];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    [_mdLayer stopEffects];
}


@end
