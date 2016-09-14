//
//  ATTabBarView.h
//  ATTabBarControllerDemo
//
//  Created by Aesir Titan on 2016-08-23.
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

@interface ATTabBarView : UIView

/*!
 *	@author Aesir Titan, 2016-08-24
 *
 *	@brief select index manual
 */
- (void (^)(NSUInteger))selectIndex;

#pragma mark - creator


+ (instancetype)tabBarWithTitleView:(UIView *)titleView items:(void(^)(NSMutableArray<UIButton *> *items))items contentView:(UIView *)contentView content:(UIView *(^)(NSUInteger index))content action:(void (^)(NSUInteger index))action;

+ (instancetype)tabBarWithTitleView:(UIView *)titleView titles:(NSArray<NSString *> *)titles titleColor:(UIColor *)titleColor contentView:(UIView *)contentView content:(UIView *(^)(NSUInteger index))content action:(void (^)(NSUInteger index))action;


@end