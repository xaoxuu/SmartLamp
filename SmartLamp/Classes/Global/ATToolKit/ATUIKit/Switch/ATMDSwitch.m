//
//  ATMDSwitch.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-20.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "ATMDSwitch.h"

@implementation ATMDSwitch

- (void)awakeFromNib{
    [super awakeFromNib];
    [self _initUI];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self _initUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self _initUI];
    }
    return self;
}

+ (instancetype)switchWithView:(UIView *)view thumbColor:(UIColor *)thumb trackColor:(UIColor *)track {
    return [[self alloc] initWithView:view thumbColor:thumb trackColor:track];
}

- (instancetype)initWithView:(UIView *)view thumbColor:(UIColor *)thumb trackColor:(UIColor *)track {
    if (self = [super initWithFrame:view.bounds]) {
        [self _initUI];
        self.thumbOn = thumb;
        self.trackOn = track;
        [view addSubview:self];
    }
    return self;
}


// init UI
- (void)_initUI{
    self.trackOff = atColor.background;
}

- (void)at_lightStyle {
    self.thumbOn = atColor.theme.light;
    self.trackOn = atColor.theme.light.light;
}

- (void)at_normalStyle {
    self.thumbOn = atColor.theme;
    self.trackOn = atColor.theme.light;
}





@end
