//
//  UIBarButtonItem+ATBlock.h
//  ATFoundation
//
//  Created by Aesir Titan on 2016-09-02.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Foundation+ATMacros.h"

NS_ASSUME_NONNULL_BEGIN


@interface UIBarButtonItem (ATBlockWrapper)

+ (instancetype)at_itemWithSystem:(UIBarButtonSystemItem)systemItem action:(void (^)(id sender))action;

- (instancetype)at_initWithSystem:(UIBarButtonSystemItem)systemItem action:(void (^)(id sender))action AT_INITIALIZER;


+ (instancetype)at_itemWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style action:(void (^)(id sender))action;

- (instancetype)at_initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style action:(void (^)(id sender))action AT_INITIALIZER;


+ (instancetype)at_itemWithImage:(UIImage *)image landscapeImagePhone:(UIImage *)landscapeImagePhone style:(UIBarButtonItemStyle)style action:(void (^)(id sender))action;

- (instancetype)at_initWithImage:(UIImage *)image landscapeImagePhone:(UIImage *)landscapeImagePhone style:(UIBarButtonItemStyle)style action:(void (^)(id sender))action AT_INITIALIZER;

+ (instancetype)at_itemWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style action:(void (^)(id sender))action;

- (instancetype)at_initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style action:(void (^)(id sender))action AT_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
