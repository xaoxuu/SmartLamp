//
//  ATTabBar+CenterButton.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-10.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ATTabBar.h"
#import "ATAnimationView.h"

@interface ATTabBar (CenterButton)

// setup center button
- (void)setupCenterButton:(UIButton * __nonnull)button action:(void (^__nullable)())action;

// start animation
- (void)startAnimation;

// stop animation
- (void)stopAnimation;

@end
