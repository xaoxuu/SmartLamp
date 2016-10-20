//
//  ATNavigationView.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-05.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ATNavigationView.h"
#import "UIBarButtonItem+ATItem.h"

@interface ATNavigationView ()
// content view
@property (strong, nonatomic) UIView *titleView;

@property (strong, nonatomic) UILabel *lb_title;

@property (strong, nonatomic) UIButton *btn_left;
@property (strong, nonatomic) UIButton *btn_right;



@end

@implementation ATNavigationView


+ (instancetype)viewWithBarTintColor:(UIColor *)barTintColor height:(CGFloat)height title:(NSString *)title{
    return [[self alloc] initWithBarTintColor:barTintColor height:height title:title];
}

- (instancetype)initWithBarTintColor:(UIColor *)barTintColor height:(CGFloat)height title:(NSString *)title{
    if (self = [self initWithFrame:CGRectMake(0, 0, kScreenW, height)]) {
        self.backgroundColor = barTintColor;
        self.tintColor = [UIColor whiteColor];
        self.title = title;
        [self _initUI];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    // init and add to superview
    if (!self.lb_title) {
        self.lb_title = [[UILabel alloc] init];
        [self.titleView addSubview:self.lb_title];
        self.lb_title.font = [UIFont boldSystemFontOfSize:17];
        self.lb_title.textColor = [UIColor whiteColor];
        self.lb_title.centerX = self.centerX;
        self.lb_title.top = 11.75;
    }
    self.lb_title.text = title;
    [self.lb_title sizeToFit];
    self.lb_title.centerX = self.centerX;
    // style
}

- (UIView *)titleView{
    if (!_titleView) {
        // create it
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenW, 44)];
        [self addSubview:_titleView];
        // do something...
    }
    return _titleView;
}


// init UI
- (void)_initUI{
    // color
    
    // style
    
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowRadius = 1.0;
    
}


- (void)at_leftButtonWithImage:(NSString *)image action:(void (^)())action {
    [self.btn_left setImage:[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.btn_left setImage:[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateHighlighted];
    _btn_left.widthEqual(50).heightEqual(44);
    _btn_left.top = 0;
    _btn_left.left = 0;
    
    [self.btn_left at_addTouchUpInsideHandler:^(UIButton * _Nonnull sender) {
        if (action) {
            action();
        }
    } animatedScale:1.5 duration:0.6];
    
}

- (void)at_rightButtonWithImage:(NSString *)image action:(void (^)())action {
    [self.btn_right setImage:[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.btn_right setImage:[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateHighlighted];
    _btn_right.widthEqual(50).heightEqual(44);
    _btn_right.top = 0;
    _btn_right.right = self.titleView.width;
    [self.btn_right at_addTouchUpInsideHandler:^(UIButton * _Nonnull sender) {
        if (action) {
            action();
        }
    } animatedScale:1.5 duration:0.6];
        
}


- (UIButton *)btn_left{
    if (!_btn_left) {
        // create it
        _btn_left = [[UIButton alloc] init];
        [self.titleView addSubview:_btn_left];
        // do something...
        _btn_left.tintColor = [UIColor whiteColor];
        _btn_left.widthEqual(50).heightEqual(44);
        _btn_left.top = self.titleView.top;
        _btn_left.left = self.titleView.left;
    }
    return _btn_left;
}


- (UIButton *)btn_right{
    if (!_btn_right) {
        // create it
        _btn_right = [[UIButton alloc] init];
        [self.titleView addSubview:_btn_right];
        // do something...
        _btn_right.tintColor = [UIColor whiteColor];
        _btn_right.widthEqual(50).heightEqual(44);
        _btn_right.top = self.titleView.top;
        _btn_right.right = self.titleView.right;
    }
    return _btn_right;
}
@end
