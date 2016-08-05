//
//  ATToolBar.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-19.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ATToolBar.h"

static NSUInteger buttonW = 58;


@interface ATToolBar ()

// scrollview
@property (strong, nonatomic) UIScrollView *scrollView;
// 最后一个按钮
@property (weak, nonatomic) UIButton *lastBtn;
// 线
@property (strong, nonatomic) CALayer *line;

@end

@implementation ATToolBar

// 构造方法
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles action:(void (^)(NSUInteger index))btnAction {
	
    if (self = [super initWithFrame:frame]) {
        // 初始化scrollview
        [self _initScrollViewWithFrame:frame];
        // 初始化线
        [self _initLine];
        // 设置标题
        self.titles = titles;
        // 按钮事件
        self.btnAction = btnAction;
        // 布局按钮
        [self _layoutButtons];
        
    }
    return self;
    
}

// 布局按钮
- (void)_layoutButtons{
    CGFloat buttonH = self.frame.size.height;
    for (int i=0; i<_titles.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*buttonW, 0, buttonW, buttonH)];
        [btn setTitle:_titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:atColor.themeColor_light forState:UIControlStateNormal];
        [btn setTitleColor:atColor.backgroundColor forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [_scrollView addSubview:btn];
        if (!i) {
            _lastBtn = btn;
            [self action:btn];
        }
    }
    _scrollView.contentSize = CGSizeMake(_titles.count * buttonW, 0);
    
}

// 选中索引
- (void)selectIndex:(NSUInteger)index{
    [self action:self.scrollView.subviews[index]];
}

// 按钮事件
- (void)action:(UIButton *)sender{
    _lastBtn.selected = NO;
    _lastBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _lastBtn = sender;
    _lastBtn.selected = YES;
    _lastBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
    if (self.btnAction) {
        self.btnAction(_lastBtn.tag);
    }
    
    _line.position = CGPointMake(sender.center.x, sender.frame.size.height - 1);
    
}

// 初始化scrollview
- (void)_initScrollViewWithFrame:(CGRect)frame{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    [self addSubview:_scrollView];
}

// 初始化线
- (void)_initLine{
    _line = [[CALayer alloc] init];
    _line.backgroundColor = atColor.backgroundColor.CGColor;
    _line.frame = CGRectMake(0, 0, buttonW, 2);
    [_scrollView.layer addSublayer:_line];
}



@end
