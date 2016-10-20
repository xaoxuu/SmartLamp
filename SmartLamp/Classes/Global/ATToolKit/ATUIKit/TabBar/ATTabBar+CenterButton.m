//
//  ATTabBar+CenterButton.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-10.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ATTabBar+CenterButton.h"

static UIButton *centerBtn;
static void (^centerBtnAction)(UIButton *);
static NSTimeInterval animationTimeout = 24.0f;
static ATAnimationView *animation;

@implementation ATTabBar (CenterButton)

#pragma mark - override



// setup center button
- (void)setupCenterButton:(UIButton * __nonnull)button action:(void (^__nullable)())action{
    // filter
    if (button){
        [self setupCenterButton:button];
        [self setupCenterButtonAction:action];
    }
}

// start animation
- (void)startAnimation {
    [self addSubview:animation];
    [animation addScanAnimation];
    centerBtn.enabled = NO;
    [self performSelector:@selector(stopAnimation) withObject:nil afterDelay:animationTimeout];
}

// stop animation
- (void)stopAnimation {
    [animation removeFromSuperview];
    [animation removeScanAnimation];
    centerBtn.enabled = YES;
}


- (void)setupCenterButton:(UIButton *)button{
    centerBtn = button;
    // frame
    const CGFloat btnW = self.width / 5;
    const CGFloat btnH = self.height;
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
    
    // center button and animation
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // center button
        centerBtn.width = btnW;
        centerBtn.height = btnH;
        centerBtn.centerX = self.width * 0.5;
        centerBtn.centerY = self.height * 0.5;
        [self addSubview:centerBtn];
        // animation
        animation = [[ATAnimationView alloc] initWithFrame:centerBtn.frame];
        // set size first
        animation.widthAndHeightEqual(45);
        // set center
        animation.centerEqual(centerBtn);
        
    });
}

- (void)setupCenterButtonAction:(void (^__nullable)(UIButton *))action{
    centerBtnAction = action;
    [centerBtn addTarget:self action:@selector(centerBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark lazy load

// center button action
- (void)centerBtnTapped:(UIButton *)sender{
    if (centerBtnAction) {
        centerBtnAction(sender);
    }
}




@end
