//
//  UITextView+ATExtension.m
//  ATFoundation
//
//  Created by Aesir Titan on 2016-09-07.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "UITextView+ATExtension.h"


@import ObjectiveC.runtime;

static const void *UITextViewATExtensionKey_SuperView = &UITextViewATExtensionKey_SuperView;

@interface UITextView ()

// super view
@property (strong, nonatomic) UIView *at_superview;


@end


@implementation UITextView (ATExtension)


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
- (void)_keyBoardWillHide:(NSNotification *)note {
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

- (CGFloat)at_heightWithText:(NSString *)text heightRange:(ATFloatRange)range{
    CGSize constraint = CGSizeMake(self.contentSize.width , CGFLOAT_MAX);
    CGRect size = [text boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                        context:nil];
    CGFloat textHeight = size.size.height + range.minValue;
    if (textHeight > range.maxValue) {
        textHeight = range.maxValue;
        [self scrollRectToVisible:CGRectMake(0, textHeight, 0, 0) animated:YES];
    }
    return textHeight;
}


#pragma mark - private methods

- (UIView *)at_superview{
    return objc_getAssociatedObject(self, UITextViewATExtensionKey_SuperView);
}

- (void)setAt_superview:(UIView *)at_superview{
    objc_setAssociatedObject(self, UITextViewATExtensionKey_SuperView, at_superview, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



@end
