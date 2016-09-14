//
//  ATProgressHUD.h
//  ATKit
//
//  Created by Aesir Titan on 2016-09-12.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

//  >>>>>>>>>>>>>>>>>>>>  Aesir Titan  <<<<<<<<<<<<<<<<<<<<
//  >>                                                   <<
//  >>  http://ayan.site                                 <<  (我的主页)
//  >>  http://github.com/AesirTitan)                    <<  (github主页)
//  >>  http://nexusonline.github.io)                    <<  (macOS应用下载站)
//  >>  http://www.jianshu.com/notebooks/6236581/latest) <<  (ATKit使用文档)
//  >>                                                   <<
//  >>>>>>>>>>>>>>>>>>>>  Aesir Titan  <<<<<<<<<<<<<<<<<<<<



#import <UIKit/UIKit.h>

#define atMarkSelfView [ATProgressHUD at_target:self.view showInfo:@"抱歉，此功能尚未开发！" duration:1]
#define atMarkSelf [ATProgressHUD at_target:self showInfo:@"抱歉，此功能尚未开发！" duration:1]

@interface ATProgressHUD : UIView

+ (void)at_target:(UIView *)target showInfo:(NSString *)info duration:(NSTimeInterval)duration;

+ (void)at_target:(UIView *)target point:(CGPoint)point showInfo:(NSString *)info duration:(NSTimeInterval)duration;


@end
