//
//  UIBarButtonItem+ATItem.m
//  QNZ
//
//  Created by Aesir Titan on 2016-07-12.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "UIBarButtonItem+ATItem.h"

@implementation UIBarButtonItem (ATItem)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    return [[self alloc] initWithCustomView:button];
}


+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage action:(void (^)())action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];

    [button at_addTouchUpInsideHandler:^(UIButton * _Nonnull sender) {
        if (action) {
            action();
        }
    }];
    [button sizeToFit];
    return [[self alloc] initWithCustomView:button];
    
}


@end
