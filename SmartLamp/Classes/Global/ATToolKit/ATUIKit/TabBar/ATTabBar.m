//
//  ATTabBar.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-13.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ATTabBar.h"
#import "ATManager+View.h"
#import "ATTabBar+Animation.h"
#import "ATTabBar+CenterButton.h"

@interface ATTabBar ()

@end

static BOOL isDoubleTap = NO;
static NSUInteger lastTap;

@implementation ATTabBar


#pragma mark - creator

// creator
+ (instancetype)barWithAnimationMode:(ATTabBarAnimationMode)mode centerButton:(UIButton * __nonnull)button action:(void (^__nonnull)())action {
    return [[self alloc] initWithAnimationMode:mode centerButton:button action:action];
}

// creator
- (instancetype)initWithAnimationMode:(ATTabBarAnimationMode)mode centerButton:(UIButton * __nonnull)button action:(void (^__nonnull)())action {
    if (self = [self initWithAnimationMode:mode]) {
        // setup center button when layoutSubviews
        [[self rac_signalForSelector:@selector(layoutSubviews)] subscribeNext:^(id x) {
            // relayout and setup center button
            [self setupCenterButton:button action:action];
        }];
    }
    return self;
}

// creator
+ (instancetype)barWithAnimationMode:(ATTabBarAnimationMode)mode {
    return [[self alloc] initWithAnimationMode:mode];
}

// creator
- (instancetype)initWithAnimationMode:(ATTabBarAnimationMode)mode {
    if (self = [self init]) {
        // setupAnimationMode when layoutSubviews
        [[self rac_signalForSelector:@selector(layoutSubviews)] subscribeNext:^(id x) {
            [self setupAnimationMode:mode];
        }];
    }
    return self;
}

#pragma mark - private methods

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // init ui
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // init UI
        [self _initUI];
        // setup rac
        [self setupRAC];
    });
    
}


// init UI
- (void)_initUI{
    self.layer.shadowOpacity = 0.1;
    self.layer.shadowOffset = CGSizeMake(0, -1);
    self.layer.shadowRadius = 1.0;
    // hide separator
    [self removeSeparator];
}


// setup rac
- (void)setupRAC{
    // setting
    for (NSUInteger i=0; i<self.subviews.count; i++) {
        UIView *subview = self.subviews[i];
        // filter UITabBarButton
        if (subview.class != NSClassFromString(@"UITabBarButton")) continue;
        [[subview rac_signalForSelector:@selector(touchesBegan:withEvent:)] subscribeNext:^(id x) {
            if (isDoubleTap && lastTap == i) {
                [self.didDoubleTapped sendNext:@(i)];
                [self setIsDoubleTapNO];
            } else {
                isDoubleTap = YES;
                [self performSelector:@selector(setIsDoubleTapNO) withObject:nil afterDelay:0.5f];
            }
            lastTap = i;
        }];
    }
}


// remove separator
- (void)removeSeparator{
    [[self.subviews lastObject] removeFromSuperview];
}

// lazy load
- (RACSubject *)didDoubleTapped{
    if (!_didDoubleTapped) {
        _didDoubleTapped = [RACSubject subject];
    }
    return _didDoubleTapped;
}


- (void)setIsDoubleTapNO{
    if (isDoubleTap) {
        isDoubleTap = NO;
    }
}



@end
