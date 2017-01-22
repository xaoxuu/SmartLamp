//
//  ATProgressHUD.h
//  ATKit
//
//  Created by Aesir Titan on 2016-09-12.
//  Copyright © 2016 Titan Studio. All rights reserved.
//
/****************************************************
 
 个人主页：      https://xaoxuu.com
 团队GitHub主页：https://github.com/TitanStudio
 ATKit项目主页： https://xaoxuu.com/atkit
 
 ****************************************************/



#import <UIKit/UIKit.h>

#define atMarkSelfView [ATProgressHUD at_target:self.view showInfo:@"抱歉，此功能尚未开发！" duration:1]
#define atMarkSelf [ATProgressHUD at_target:self showInfo:@"抱歉，此功能尚未开发！" duration:1]

@interface ATProgressHUD : UIView

+ (void)at_target:(UIView *)target showInfo:(NSString *)info duration:(NSTimeInterval)duration;

+ (void)at_target:(UIView *)target point:(CGPoint)point showInfo:(NSString *)info duration:(NSTimeInterval)duration;


@end
