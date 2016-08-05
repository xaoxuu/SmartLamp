//
//  ATTabBar.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-13.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ATTabBar.h"

@interface ATTabBar ()

// center button
@property (strong, nonatomic) UIButton *centerBtn;
// current animation mode
@property (assign, nonatomic) ATTabBarAnimationMode mode;

@end

static BOOL isDoubleTap = NO;
static NSNumber *lastTap;
@implementation ATTabBar

#pragma mark - private methods

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // hide separator
    [self hideSeparator];
    // init UI
    [self _initUI];
    // setup animation mode
    [self setupAnimationMode];
    // relayout and setup center button
    [self setupCenterButton];
    
    [self setupRAC];
    
}

// setup animation mode
- (void)setupAnimationMode{
    switch (_mode) {
        case ATTabBarAnimationModeRotation: {
            [self tabbarAnimationWithRotationMode];
            break;
        }
        case ATTabBarAnimationModeReversal: {
            [self tabbarAnimationWithReversalMode];
            break;
        }
    }
}

// rotation mode
- (void)tabbarAnimationWithRotationMode{
    for (int i=0; i<self.subviews.count; i++) {
        UIView *subview = self.subviews[i];
        // filter UITabBarButton
        if (subview.class != NSClassFromString(@"UITabBarButton")) continue;
        // animation
        [[subview rac_signalForSelector:@selector(touchesBegan:withEvent:)] subscribeNext:^(id x) {
            [UIView animateWithDuration:3.0f delay:0.0f usingSpringWithDamping:0.3f initialSpringVelocity:0.2f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                subview.subviews[0].transform = CGAffineTransformMakeRotation(M_PI);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.38f animations:^{
                    subview.subviews[0].transform = CGAffineTransformIdentity;
                }];
            }];
        }];
    }
}

// reversal mode
- (void)tabbarAnimationWithReversalMode{
    for (int i=0; i<self.subviews.count; i++) {
        UIView *subview = self.subviews[i];
        // filter UITabBarButton
        if (subview.class != NSClassFromString(@"UITabBarButton")) continue;
        // animation
        [[subview rac_signalForSelector:@selector(touchesBegan:withEvent:)] subscribeNext:^(id x) {
            [UIView animateWithDuration:3.0f delay:0.0f usingSpringWithDamping:0.3f initialSpringVelocity:0.3f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                subview.subviews[0].transform = CGAffineTransformMake(-1, 0, 0, 1, 0, 0);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.38f animations:^{
                    subview.subviews[0].transform = CGAffineTransformIdentity;
                }];
            }];
        }];
    }
}

// setup center button
- (void)setupCenterButton{
    
    [self.centerBtn addTarget:self action:@selector(centerBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    // frame
    const CGFloat btnW = self.at_width / 5;
    const CGFloat btnH = self.at_height;
    CGFloat tabBarButtonY = 0;
    // index
    int tabBarButtonIndex = 0;
    // setting
    for (UIView *subview in self.subviews) {
        // filter UITabBarButton
        if (subview.class != NSClassFromString(@"UITabBarButton")) continue;
        // setup frame
        CGFloat tabBarButtonX = tabBarButtonIndex * btnW;
        // right 2 buttons move right
        if (tabBarButtonIndex >= 2) {
            tabBarButtonX += btnW;
        }
        subview.frame = CGRectMake(tabBarButtonX, tabBarButtonY, btnW, btnH);
        // index++
        tabBarButtonIndex++;
    }
    
    // frame
    self.centerBtn.at_width = btnW;
    self.centerBtn.at_height = btnH;
    self.centerBtn.at_centerX = self.at_width * 0.5;
    self.centerBtn.at_centerY = self.at_height * 0.5;
    [self addSubview:self.centerBtn];
    
}

#pragma mark lazy load
// center button
- (UIButton *)centerBtn{
    if (!_centerBtn) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setImage:[UIImage imageNamed:@"tabbar_switch_off"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"tabbar_switch_off"] forState:UIControlStateSelected];
        _centerBtn = btn;
    }
    
    return _centerBtn;
}

// center button action
- (void)centerBtnTapped:(UIButton *)sender{
    
}

// creator
- (instancetype)initWithAnimationMode:(ATTabBarAnimationMode)mode {
    if (self = [self init]) {
        _mode = mode;
    }
    return self;
}

// hide separator
- (void)hideSeparator{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self.subviews lastObject] removeFromSuperview];
    });
}

// init UI
- (void)_initUI{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.backgroundColor = atColor.backgroundColor;
        self.layer.shadowOpacity = 0.1;
        self.layer.shadowOffset = CGSizeMake(0, -1);
        self.layer.shadowRadius = 1.0;
    });
}
- (RACSubject *)didDoubleTapped{
    if (!_didDoubleTapped) {
        _didDoubleTapped = [RACSubject subject];
    }
    return _didDoubleTapped;
}
// setup rac
- (void)setupRAC{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // setting
        for (NSUInteger i=0; i<self.subviews.count; i++) {
            UIView *subview = self.subviews[i];
            // filter UITabBarButton
            if (subview.class != NSClassFromString(@"UITabBarButton")) continue;
            [[subview rac_signalForSelector:@selector(touchesBegan:withEvent:)] subscribeNext:^(id x) {
                if (isDoubleTap && [lastTap isEqualToNumber:@(i)]) {
                    [self.didDoubleTapped sendNext:@(i)];
                    [self setIsDoubleTapNO];
                } else {
                    isDoubleTap = YES;
                    [self performSelector:@selector(setIsDoubleTapNO) withObject:nil afterDelay:0.5f];
                }
                lastTap = @(i);
            }];
        }
    });
}

- (instancetype)initWithAnimationMode:(ATTabBarAnimationMode)mode centerButton:(UIButton *)button action:(void (^)())action {
    if (self = [self initWithAnimationMode:mode]) {
        self.centerBtn = button;
    }
    return self;
}


- (void)setIsDoubleTapNO{
    if (isDoubleTap) {
        isDoubleTap = NO;
    }
}

@end
