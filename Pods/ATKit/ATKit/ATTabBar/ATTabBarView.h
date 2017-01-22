//
//  ATTabBarView.h
//  ATTabBarControllerDemo
//
//  Created by Aesir Titan on 2016-08-23.
//  Copyright © 2016 Titan Studio. All rights reserved.
//
/****************************************************
 
   个人主页：      https://xaoxuu.com
   团队GitHub主页：https://github.com/TitanStudio
   ATKit项目主页： https://xaoxuu.com/atkit
 
 ****************************************************/


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
