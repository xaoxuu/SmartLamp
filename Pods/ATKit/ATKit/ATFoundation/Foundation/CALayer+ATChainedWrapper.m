//
//  CALayer+ATChainedWrapper.m
//  ATKit
//
//  Created by Aesir Titan on 2016-09-02.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "CALayer+ATChainedWrapper.h"
#import "UIColorManager.h"

@implementation CALayer (ATChainedWrapper)

- (CALayer *(^)())at_maskToCircle{
    return ^{
        self.masksToBounds = YES;
        self.cornerRadius = 0.5 * fmin(self.frame.size.width, self.frame.size.height);
        return self;
    };
}

#pragma mark - shadow

- (CALayer *(^)(ATShadow type))at_shadow{
    return ^(ATShadow type){
        self.masksToBounds = NO;
        switch (type) {
                // for top bar
            case ATShadowDownLight: {
                self.shadowOpacity = 0.4;
                self.shadowRadius = 0.8;
                self.shadowOffset = CGSizeMake(0, 0.8);
                break;
            }
            case ATShadowDownNormal: {
                self.shadowOpacity = 0.5;
                self.shadowRadius = 1;
                self.shadowOffset = CGSizeMake(0, 1);
                break;
            }
                // for raised view
            case ATShadowDownFloat: {
                self.shadowOpacity = 0.4;
                self.shadowRadius = 3;
                self.shadowOffset = CGSizeMake(0, 2.8);
                break;
            }
                // for bottom bar
            case ATShadowUpLight: {
                self.shadowOpacity = 0.3;
                self.shadowRadius = 0.8;
                self.shadowOffset = CGSizeMake(0, -0.8);
                break;
            }
            case ATShadowUpNormal: {
                self.shadowOpacity = 0.4;
                self.shadowRadius = 0.8;
                self.shadowOffset = CGSizeMake(0, -0.8);
                break;
            }
                // for center views
            case ATShadowCenterLight: {
                self.shadowOpacity = 0.3;
                self.shadowRadius = 1;
                self.shadowOffset = CGSizeZero;
                break;
            }
            case ATShadowCenterNormal: {
                self.shadowOpacity = 0.7;
                self.shadowRadius = 1.2;
                self.shadowOffset = CGSizeZero;
                break;
            }
            case ATShadowCenterHeavy: {
                self.shadowOpacity = 0.8;
                self.shadowRadius = 1.5;
                self.shadowOffset = CGSizeZero;
                break;
            }
        }
        return self;
    };
    
}

#pragma mark - border

- (CALayer *(^)(CGFloat width))at_whiteBorder{
    return ^(CGFloat width){
        self.borderColor = [UIColor whiteColor].CGColor;
        self.borderWidth = width;
        return self;
    };
}

- (CALayer *(^)(CGFloat width))at_themeBorder{
    return ^(CGFloat width){
        self.borderColor = atColor.theme.CGColor;
        self.borderWidth = width;
        return self;
    };
}


@end



