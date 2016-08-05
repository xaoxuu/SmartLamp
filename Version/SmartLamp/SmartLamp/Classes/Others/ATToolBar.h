//
//  ATToolBar.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-19.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATToolBar : UIView

// 按钮事件
@property (copy, nonatomic) void (^btnAction)(NSUInteger index);

// 标题
@property (strong, nonatomic) NSArray *titles;

/**
 *	@author Aesir Titan, 2016-07-24 20:07:13
 *
 *	@brief 选择某个按钮
 *
 *	@param index	索引
 */
- (void)selectIndex:(NSUInteger)index;

// 构造方法
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles action:(void (^)(NSUInteger index))btnAction;

@end
