//
//  UITextField+ATExtension.m
//  ATFoundation
//
//  Created by Aesir Titan on 2016-08-31.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "UITextField+ATExtension.h"
@import ObjectiveC.runtime;

static const void *UITextFieldATExtensionKey_ContentEdgeInsets = &UITextFieldATExtensionKey_ContentEdgeInsets;
static const void *UITextFieldATExtensionKey_SuperView = &UITextFieldATExtensionKey_SuperView;

@interface UITextField ()

// super view
@property (strong, nonatomic) UIView *at_superview;
// content edge inset
@property (assign, nonatomic) UIEdgeInsets contentEdgeInsets;

@end



@implementation UITextField (ATExtension)


- (void)at_clearText {
	self.text = @"";
}

- (void)at_adjustViewFrameWithKeyboard:(UIView *)view {
    self.at_superview = view;
    // 添加对键盘的监控
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

// 弹出键盘
- (void)_keyBoardWillShow:(NSNotification *) note {
    // 获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    // 获取键盘高度
    CGRect keyBoardBounds  = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = keyBoardBounds.size.height;
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 定义好动作
    void (^animation)(void) = ^void(void) {
        self.at_superview.transform = CGAffineTransformMakeTranslation(0, - keyBoardHeight);
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
    }
    
}

// 隐藏键盘
- (void)_keyBoardWillHide:(NSNotification *) note {
    // 获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 定义好动作
    void (^animation)(void) = ^void(void) {
        self.at_superview.transform = CGAffineTransformIdentity;
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
    }
}

#pragma mark - private methods
/*
+ (void)load{
    
    // exchange (textRectForBounds)
    Method textRectForBounds = class_getInstanceMethod([UITextField class], @selector(textRectForBounds:));
    Method at_textRectForBounds = class_getInstanceMethod([UITextField class], @selector(at_textRectForBounds:));
    method_exchangeImplementations(textRectForBounds, at_textRectForBounds);
    // exchage (editingRectForBounds)
    Method editingRectForBounds = class_getInstanceMethod([UITextField class], @selector(editingRectForBounds:));
    Method at_editingRectForBounds = class_getInstanceMethod([UITextField class], @selector(at_editingRectForBounds:));
    method_exchangeImplementations(editingRectForBounds, at_editingRectForBounds);
    
}
*/

- (UIEdgeInsets)contentEdgeInsets{
    NSValue *value = objc_getAssociatedObject(self, UITextFieldATExtensionKey_ContentEdgeInsets);
    return [value UIEdgeInsetsValue];
}

- (void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets{
    NSValue *value = [NSValue valueWithUIEdgeInsets:contentEdgeInsets];
    objc_setAssociatedObject(self, UITextFieldATExtensionKey_ContentEdgeInsets, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)at_superview{
    return objc_getAssociatedObject(self, UITextFieldATExtensionKey_SuperView);
}

- (void)setAt_superview:(UIView *)at_superview{
    objc_setAssociatedObject(self, UITextFieldATExtensionKey_SuperView, at_superview, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// 控制文本所在的的位置
- (CGRect)at_textRectForBounds:(CGRect)bounds{
    UIEdgeInsets inset = self.contentEdgeInsets;
    return CGRectMake(inset.left, inset.top, bounds.size.width - inset.left - inset.right, bounds.size.height - inset.top - inset.bottom);
}

// 控制编辑文本时所在的位置
- (CGRect)at_editingRectForBounds:(CGRect)bounds{
    UIEdgeInsets inset = self.contentEdgeInsets;
    return CGRectMake(inset.left, inset.top, bounds.size.width - inset.left - inset.right, bounds.size.height - inset.top - inset.bottom);
}



@end

