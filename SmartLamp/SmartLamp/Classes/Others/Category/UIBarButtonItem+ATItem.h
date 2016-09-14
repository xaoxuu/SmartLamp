//
//  UIBarButtonItem+ATItem.h
//  QNZ
//
//  Created by Aesir Titan on 2016-07-12.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (ATItem)

/**
 *	@author Aesir Titan, 2016-07-24 20:07:21
 *
 *	@brief 创建一个BarButton
 *
 *	@param image		图片
 *	@param highImage	高亮图片
 *	@param target		target
 *	@param action		action
 *
 *	@return 返回一个BarButton
 */
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;
/**
 *	@author Aesir Titan, 2016-07-24 20:07:21
 *
 *	@brief 创建一个BarButton
 *
 *	@param image		图片
 *	@param highImage	高亮图片
 *	@param action		action
 *
 *	@return 返回一个BarButton
 */
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage action:(void (^)())action;

@end
