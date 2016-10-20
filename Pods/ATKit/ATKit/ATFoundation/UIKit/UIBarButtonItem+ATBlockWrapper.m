//
//  UIBarButtonItem+ATBlock.m
//  ATFoundation
//
//  Created by Aesir Titan on 2016-09-02.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "UIBarButtonItem+ATBlockWrapper.h"
@import ObjectiveC.runtime;

static const void *UIBarButtonItemATBlockWrapperKey = &UIBarButtonItemATBlockWrapperKey;

@interface UIBarButtonItem (BlocksKitPrivate)

- (void)at_handleAction:(UIBarButtonItem *)sender;

@end

@implementation UIBarButtonItem (ATBlockWrapper)


- (void)at_handleAction:(UIBarButtonItem *)sender
{
    void (^block)(id) = objc_getAssociatedObject(self, UIBarButtonItemATBlockWrapperKey);
    if (block) block(sender);
}

+ (instancetype)at_itemWithSystem:(UIBarButtonSystemItem)systemItem action:(void (^)(id sender))action {
    return [[self alloc] at_initWithSystem:systemItem action:action];
}

- (instancetype)at_initWithSystem:(UIBarButtonSystemItem)systemItem action:(void (^)(id sender))action AT_INITIALIZER {
    self = [self initWithBarButtonSystemItem:systemItem target:self action:@selector(at_handleAction:)];
    if (!self) return nil;
    
    objc_setAssociatedObject(self, UIBarButtonItemATBlockWrapperKey, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    return self;
}

+ (instancetype)at_itemWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style action:(void (^)(id sender))action {
    return [[self alloc] at_initWithImage:image style:style action:action];
}

- (instancetype)at_initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style action:(void (^)(id sender))action AT_INITIALIZER {
    self = [self initWithImage:image style:style target:self action:@selector(at_handleAction:)];
    if (!self) return nil;
    
    objc_setAssociatedObject(self, UIBarButtonItemATBlockWrapperKey, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    return self;
}

+ (instancetype)at_itemWithImage:(UIImage *)image landscapeImagePhone:(UIImage *)landscapeImagePhone style:(UIBarButtonItemStyle)style action:(void (^)(id sender))action {
    return [[self alloc] at_initWithImage:image landscapeImagePhone:landscapeImagePhone style:style action:action];
}

- (instancetype)at_initWithImage:(UIImage *)image landscapeImagePhone:(UIImage *)landscapeImagePhone style:(UIBarButtonItemStyle)style action:(void (^)(id sender))action AT_INITIALIZER {
    self = [self initWithImage:image landscapeImagePhone:landscapeImagePhone style:style target:self action:@selector(at_handleAction:)];
    if (!self) return nil;
    
    objc_setAssociatedObject(self, UIBarButtonItemATBlockWrapperKey, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    return self;
}

+ (instancetype)at_itemWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style action:(void (^)(id sender))action {
    return [[self alloc] at_initWithTitle:title style:style action:action];
}

- (instancetype)at_initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style action:(void (^)(id sender))action AT_INITIALIZER {
    self = [self initWithTitle:title style:style target:self action:@selector(at_handleAction:)];
    if (!self) return nil;
    
    objc_setAssociatedObject(self, UIBarButtonItemATBlockWrapperKey, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    return self;
}



@end
