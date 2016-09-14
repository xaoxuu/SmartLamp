//
//  ATNavigationBar.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-03.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ATNavigationBar.h"

@implementation ATNavigationBar

// create a bar with tint color
+ (instancetype)barWithBarTintColor:(UIColor *)barTintColor{
    return [[self alloc] initWithBarTintColor:barTintColor];
}

// create a bar with tint color
- (instancetype)initWithBarTintColor:(UIColor *)barTintColor{
    if (self = [self init]) {
        self.barTintColor = barTintColor;
        self.tintColor = [UIColor whiteColor];
    }
    return self;
}

// init
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _initUI];
    }
    return self;
}

// layout subviews
- (void)layoutSubviews{
    [super layoutSubviews];
    // hide separator
//    [self hideSeparator];
    // init UI
    [self _initUI];
    
}

// init UI
- (void)_initUI{
    // color
    NSDictionary * dict = [NSDictionary dictionaryWithObject:self.tintColor forKey:NSForegroundColorAttributeName];
    self.titleTextAttributes = dict;
    // style
    self.translucent = NO;
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowRadius = 1.0;
    
}



// hide separator copy these codes to view controller init method
- (void)hideSeparator{
//    if ([self.subviews[0].subviews[0] isKindOfClass:[UIImageView class]]) {
//        [self.subviews[0].subviews[0] removeFromSuperview];
//    }
}

@end
