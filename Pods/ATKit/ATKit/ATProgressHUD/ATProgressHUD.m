//
//  ATProgressHUD.m
//  ATKit
//
//  Created by Aesir Titan on 2016-09-12.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "ATProgressHUD.h"
#import "Foundation+CoreGraphics.h"
#import "UIView+ATFrameWrapper.h"
#import "UIColorManager.h"
#import "CALayer+ATChainedWrapper.h"

static UIView *sPopView;

static UIView *sMaskView;

// label
static UILabel *sLabel;

static BOOL isShowing = NO;

@implementation ATProgressHUD



+ (void)at_target:(UIView *)target showInfo:(NSString *)info duration:(NSTimeInterval)duration {
    if (!isShowing) {
        sPopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.6*kScreenW, 30)];
        [self _initMaskView];
        [self setupLabelWithContent:info];
        [self pushTo:target duration:duration];
    }
}

+ (void)at_target:(UIView *)target point:(CGPoint)point showInfo:(NSString *)info duration:(NSTimeInterval)duration {
    if (!isShowing) {
        sPopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.6*kScreenW, 30)];
        [self _initMaskView];
        [self setupLabelWithContent:info];
        [self moveToView:target point:point];
        [self pushTo:target duration:duration];
    }
}

// setup label
+ (void)setupLabelWithContent:(NSString *)content{
    // lanel
    sLabel = [[UILabel alloc] init];
    [sPopView addSubview:sLabel];
    sLabel.numberOfLines = 0;
    sLabel.text = content;
    sLabel.font = [UIFont systemFontOfSize:13];
    sLabel.textColor = atColor.theme;
    sLabel.width = sPopView.width - 32;
    sLabel.centerX = sPopView.centerX;
    sLabel.top = 16;
    [sLabel sizeToFit];
    
    // view
    sPopView.backgroundColor = [UIColor whiteColor];
    sPopView.layer.cornerRadius = 2;
    sPopView.layer.at_shadow(ATShadowDownFloat);
    sPopView.height = sLabel.top + sLabel.height + 16;
    sPopView.centerX = kScreenCenterX;
    sPopView.centerY = kScreenCenterY;
    
}

+ (void)moveToView:(UIView *)view point:(CGPoint)point{
    sPopView.center = point;
    if (sPopView.right > view.width) {
        sPopView.right = view.width - 8;
    }
    if (sPopView.bottom > view.height) {
        sPopView.bottom = view.height - 8;
    }
    if (sPopView.left < 0) {
        sPopView.left = 8;
    }
    if (sPopView.top < 0) {
        sPopView.top = 8;
    }
}


+ (void)pushTo:(UIView *)view duration:(NSTimeInterval)duration{
    [self _hideTips];
    
    [view addSubview:sPopView];
    if (!isShowing) {
        isShowing = YES;
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self _showTips];
        } completion:^(BOOL finished) {
            [self performSelector:@selector(_dismissAnimation) withObject:nil afterDelay:duration];
        }];
    }
}

+ (void)_dismissAnimation{
    if (isShowing) {
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self _hideTips];
        } completion:^(BOOL finished) {
            isShowing = NO;
            [sPopView removeFromSuperview];
        }];
    }
}

+ (void)_hideTips{
    sPopView.alpha = 0;
    sPopView.backgroundColor = [UIColor lightGrayColor];
    sPopView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    sMaskView.transform = CGAffineTransformIdentity;
}

+ (void)_showTips{
    sPopView.alpha = 1;
    sPopView.backgroundColor = [UIColor whiteColor];
    sPopView.transform = CGAffineTransformIdentity;
    sMaskView.transform = CGAffineTransformMakeScale(40, 40);
}

+ (void)_initMaskView{
    sMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    sMaskView.backgroundColor = [UIColor whiteColor];
    sMaskView.layer.at_maskToCircle();
    sMaskView.centerX = 0.5 * sPopView.width;
    sMaskView.centerY = 0.5 * sPopView.height;
    sPopView.maskView = sMaskView;
}


@end
