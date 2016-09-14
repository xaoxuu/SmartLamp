//
//  UIView+ATExtension.m
//  ATFoundation
//
//  Created by Aesir Titan on 2016-08-31.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "UIView+ATExtension.h"
#import "Foundation+CoreGraphics.h"
//#import "Foundation+ATLogExtension.h"

inline UIView *UIViewWithHeight(CGFloat height){
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, height)];
}


@implementation UIView (ATExtension)

// find view's super controller
- (UIViewController *)controller{
    UIResponder *responder = self;
    while ((responder = [responder nextResponder])){
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    }
    // ATLogFail(@"controller not found!");
    return nil;
}

- (void)at_removeAllSubviews:(Class)subClass {
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        if (!subClass || [subview isKindOfClass:subClass]) {
            [subview removeFromSuperview];
        }
    }];
}

- (void)at_eachSubview:(Class)subClass action:(void (^)(__kindof UIView *subview))action {
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        if (subview && action) {
            if (!subClass || [subview isKindOfClass:subClass]) {
                action(subview);
            }
        }
    }];
}

+ (instancetype)at_roundedViewWithFrame:(CGRect)rect {
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 0.5 * fmin(rect.size.width, rect.size.height);
    return view;
}


@end
