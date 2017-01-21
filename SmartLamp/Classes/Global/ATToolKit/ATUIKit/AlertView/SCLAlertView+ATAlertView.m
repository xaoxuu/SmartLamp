//
//  SCLAlertView+ATAlertView.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-19.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "SCLAlertView+ATAlertView.h"

@implementation SCLAlertView (ATAlertView)



#pragma mark - 快速弹窗

+ (void)at_showNotice:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration {
    
    SCLAlertView *alert = [SCLAlertView at_SCLAlertViewWithColor:nil];
    [alert showNotice:vc title:title subTitle:subTitle closeButtonTitle:closeButtonTitle duration:duration];
    
}

+ (void)at_showSuccess:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration {
    
    SCLAlertView *alert = [SCLAlertView at_SCLAlertViewWithDefaultColor];
    [alert showSuccess:vc title:title subTitle:subTitle closeButtonTitle:closeButtonTitle duration:duration];
    
}

+ (void)at_showWarning:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration {
    SCLAlertView *alert = [SCLAlertView at_SCLAlertViewWithDefaultColor];
    [alert showWarning:vc title:title subTitle:subTitle closeButtonTitle:closeButtonTitle duration:duration];
}

+ (void)at_showError:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration {
    SCLAlertView *alert = [SCLAlertView at_SCLAlertViewWithDefaultColor];
    [alert showError:vc title:title subTitle:subTitle closeButtonTitle:closeButtonTitle duration:duration];
}

+ (void)at_showWaiting:(UIViewController *)vc title:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration {
    SCLAlertView *alert = [SCLAlertView at_SCLAlertViewWithColor:nil];
    [alert showWaiting:vc title:title subTitle:subTitle closeButtonTitle:closeButtonTitle duration:duration];
}


#pragma mark - 创建弹窗实例

+ (instancetype)at_SCLAlertViewWithColor:(UIColor *)color {
    
    SCLAlertView *alert = [SCLAlertView at_SCLAlertViewWithDefaultColor];
    color ? alert.customViewColor = color : [UIColor colorWithRed:0.4 green:0.8 blue:1.0 alpha:1.0];
    return alert;
}

+ (instancetype)at_SCLAlertViewWithDefaultColor {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.showAnimationType = SCLAlertViewShowAnimationFadeIn;
    alert.hideAnimationType = SCLAlertViewHideAnimationFadeOut;
    alert.backgroundType = SCLAlertViewBackgroundBlur;
    return alert;
}




@end
