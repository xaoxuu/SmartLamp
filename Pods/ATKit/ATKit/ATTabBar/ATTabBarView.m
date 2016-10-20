//
//  ATTabBarView.m
//  ATTabBarControllerDemo
//
//  Created by Aesir Titan on 2016-08-23.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "ATTabBarView.h"

const static CGFloat sMargin = 32;
static CGFloat sHeight = 40;
const static CGFloat sLineHeight = 2;

@interface ATTabBarView () <UIScrollViewDelegate>

// count
@property (assign, nonatomic) NSUInteger count;

// scrollview
@property (strong, nonatomic) UIScrollView *titleScrollView;
// titles
//@property (strong, nonatomic) NSArray<NSString *> *titles;
// title buttons
@property (strong, nonatomic) NSMutableArray<UIButton *> *titleButtons;
// the last button
@property (weak, nonatomic) UIButton *lastBtn;
// line
@property (strong, nonatomic) CALayer *line;
// button events
@property (copy, nonatomic) void (^btnAction)(NSUInteger index);

// content scroll view
@property (strong, nonatomic) UIScrollView *contentScrollView;
// request content block
@property (copy, nonatomic) UIView *(^content)(NSUInteger index);
// cached views
@property (strong, nonatomic) NSMutableDictionary *cachedViews;

// current index
@property (assign, nonatomic) NSUInteger index;


@end

static UIColor *normalColor;
static UIColor *highlightedColor;

static inline NSString *NSStringFromInteger(NSInteger index){
    return [NSString stringWithFormat:@"%ld",(long)index];
}

static inline CGFloat widthOf(UIView *view){
    return view.frame.size.width;
}

static inline CGFloat heightOf(UIView *view){
    return view.frame.size.height;
}

@implementation ATTabBarView

+ (instancetype)tabBarWithTitleView:(UIView *)titleView items:(void(^)(NSMutableArray<UIButton *> *items))items contentView:(UIView *)contentView content:(UIView *(^)(NSUInteger index))content action:(void (^)(NSUInteger index))action{
    return [[self alloc] initWithTitleView:titleView items:items contentView:contentView content:content action:action];
}

- (instancetype)initWithTitleView:(UIView *)titleView items:(void(^)(NSMutableArray<UIButton *> *items))items contentView:(UIView *)contentView content:(UIView *(^)(NSUInteger index))content action:(void (^)(NSUInteger index))action{
    if (self = [super initWithFrame:titleView.bounds]) {
        [self setupItemsWithItems:items];
        
        [self setupContentView:contentView content:content];
        
        [self setupTitleView:titleView action:action];
    }
    return self;
}

+ (instancetype)tabBarWithTitleView:(UIView *)titleView titles:(NSArray<NSString *> *)titles titleColor:(UIColor *)titleColor contentView:(UIView *)contentView content:(UIView *(^)(NSUInteger index))content action:(void (^)(NSUInteger index))action{
    return [[self alloc] initWithTitleView:titleView titles:titles titleColor:titleColor contentView:contentView content:content action:action];
}


- (instancetype)initWithTitleView:(UIView *)titleView titles:(NSArray<NSString *> *)titles titleColor:(UIColor *)titleColor contentView:(UIView *)contentView content:(UIView *(^)(NSUInteger index))content action:(void (^)(NSUInteger index))action{
    if (self = [super initWithFrame:titleView.bounds]) {
        [self setupItemsWithTitles:titles titleColor:titleColor];
        
        [self setupContentView:contentView content:content];
        
        [self setupTitleView:titleView action:action];
        
    }
    return self;
}

#pragma mark - init methods

- (void)setupItemsWithItems:(void(^)(NSMutableArray<UIButton *> *items))items{
    self.titleButtons = [NSMutableArray array];
    // request buttons
    items(self.titleButtons);
    // init property
    self.count = self.titleButtons.count;
    sHeight = self.frame.size.height;
    // set tint color
    self.tintColor = self.titleButtons[0].tintColor;
    CGFloat red,green,blue,alpha;
    [self.tintColor getRed:&red green:&green blue:&blue alpha:&alpha];
    highlightedColor = self.tintColor;
    normalColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.7 * alpha];
    
}


// setup property
- (void)setupItemsWithTitles:(NSArray<NSString *> *)titles titleColor:(UIColor *)titleColor{
    self.titleButtons = [NSMutableArray array];
    self.count = titles.count;
    sHeight = self.frame.size.height;
    // set tint color
    self.tintColor = titleColor;
    CGFloat red,green,blue,alpha;
    [titleColor getRed:&red green:&green blue:&blue alpha:&alpha];
    highlightedColor = titleColor;
    normalColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.7 * alpha];
    // set buttons
    for (int i=0; i<self.count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:normalColor forState:UIControlStateNormal];
        [btn setTitleColor:highlightedColor forState:UIControlStateSelected];
        [self.titleButtons addObject:btn];
    }
    
}


// setup content view
- (void)setupContentView:(UIView *)contentView content:(UIView *(^)(NSUInteger index))content{
    // init and add to superview
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:contentView.bounds];
    [contentView addSubview:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)]];
    [contentView addSubview:self.contentScrollView];
    // do something
    self.contentScrollView.delegate = self;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.scrollEnabled = YES;
    const CGFloat contentWidth = self.count * contentView.bounds.size.width;
    self.contentScrollView.contentSize = CGSizeMake(contentWidth, 0);
    self.contentScrollView.pagingEnabled = YES;
    
    // content
    self.cachedViews = [NSMutableDictionary dictionaryWithCapacity:self.count];
    self.content = content;
    
}


// setup title view
- (void)setupTitleView:(UIView *)titleView action:(void (^)(NSUInteger index))action{
    // init and add to superview
    self.titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.titleScrollView.showsVerticalScrollIndicator = NO;
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    self.titleScrollView.bounces = NO;
    [titleView addSubview:self.titleScrollView];
    // setup line
    self.line = [[CALayer alloc] init];
    self.line.backgroundColor = highlightedColor.CGColor;
    self.line.frame = CGRectMake(0, heightOf(self)-sLineHeight, 0, sLineHeight);
    [self.titleScrollView.layer addSublayer:self.line];
    // layout buttons
    CGFloat lastX=0;
    NSMutableArray *buttons = self.titleButtons;
    for (int i=0; i<self.count; i++) {
        UIButton *btn = self.titleButtons[i];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = i;
        [btn sizeToFit];
        
        CGRect frame = btn.frame;
        frame.origin.x = lastX;
        frame.size.width += sMargin;
        frame.size.height = sHeight;
        btn.frame = frame;
        [self.titleScrollView addSubview:btn];
        lastX += frame.size.width;
        [btn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.titleScrollView.contentSize = CGSizeMake(lastX, 0);
    // action
    self.btnAction = action;
    
    // select first button
    self.lastBtn = buttons[0];
    [self action:buttons[0]];
    [self moveIndicatorToLeft:0 width:widthOf(buttons[0]) animated:NO];
    
    
    // keep alive
    [titleView insertSubview:self atIndex:0];
    
}


#pragma mark control method

- (void (^)(NSUInteger))selectIndex{
    return ^(NSUInteger index){
        if (index>=self.count) {
            index = self.count - 1;
        }
        [self action:self.titleScrollView.subviews[index]];
    };
}

// button events
- (void)action:(UIButton *)sender{
    self.lastBtn.selected = NO;
    self.lastBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.lastBtn = sender;
    self.lastBtn.selected = YES;
    self.lastBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
    // adjust title content
    [self adjustTitleOffsetWith:sender];
    // scroll
    [self contentScrollToIndex:sender.tag];
    // user action
    if (self.btnAction) {
        self.btnAction(self.lastBtn.tag);
    }
    
    self.index = self.lastBtn.tag;
}

- (void)adjustTitleOffsetWith:(UIButton *)sender{
    CGPoint currentOffset = self.titleScrollView.contentOffset;
    CGFloat left = sender.frame.origin.x - currentOffset.x;
    CGFloat right = left + sender.frame.size.width;
    CGPoint offset = currentOffset;
    
    if (left < sMargin){
        offset.x = sender.frame.origin.x - sMargin;
        if (offset.x < 0) {
            offset.x = 0;
        }
    }
    if (right > self.frame.size.width - sMargin) {
        offset.x = (sender.frame.origin.x + sender.frame.size.width) - self.frame.size.width + sMargin;
        if (offset.x > self.titleScrollView.contentSize.width - self.titleScrollView.frame.size.width) {
            
            offset.x = self.titleScrollView.contentSize.width - self.titleScrollView.frame.size.width;
        }
    }
    [self.titleScrollView setContentOffset:offset animated:YES];
}

// scroll to index
- (void)contentScrollToIndex:(NSUInteger)index{
    // load views
    [self loadViewsWithIndex:index];
    // scroll
    CGPoint offset = CGPointMake(index * self.contentScrollView.frame.size.width, 0);
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0.1f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.contentScrollView setContentOffset:offset animated:NO];
    } completion:^(BOOL finished) {
        
    }];
}



- (void)loadViewsWithIndex:(NSUInteger)index{
    
    // load current view
    [self requestViewWithIndex:index];
    
    // load previous view
    if (index > 0) {
        [self requestViewWithIndex:index - 1];
    }
    
    // load next view
    if (index < self.count - 1) {
        [self requestViewWithIndex:index + 1];
    }
    
}

- (void)requestViewWithIndex:(NSUInteger)index{
    UIView *view = self.cachedViews[NSStringFromInteger(index)];
    if (!view) {
        // request and cache view
        UIView *view = self.content(index);
        const CGFloat width = self.contentScrollView.frame.size.width;
        const CGFloat height = self.contentScrollView.frame.size.height;
        view.frame = CGRectMake(index * width, 0, width, height);
        self.cachedViews[NSStringFromInteger(index)] = view;
        [self.contentScrollView addSubview:view];
    }
}


- (void)moveIndicatorToLeft:(CGFloat)left width:(CGFloat)width animated:(BOOL)animated {
    CGRect frame = self.line.frame;
    frame.origin.x = left;
    frame.size.width = width;
    if (animated) {
        [UIView animateWithDuration:0.5f
                         animations:^{
                             self.line.frame = frame;
                         }];
    } else {
        self.line.frame = frame;
    }
    
}

- (void)moveIndicatorWithScrollViewContentOffset:(CGFloat)offset{
    offset = offset - self.contentScrollView.frame.size.width * self.index;
    
    CGFloat left0 = self.titleButtons[self.index].frame.origin.x;
    CGFloat width0 = self.titleButtons[self.index].frame.size.width;
    CGFloat left1 = left0;
    CGFloat width1 = width0;
    if (offset > 0) {
        if (self.index < self.count - 1) {
            left1 = self.titleButtons[self.index + 1].frame.origin.x;
            width1 = self.titleButtons[self.index + 1].frame.size.width;
        } else{
        }
    } else if (offset < 0){
        if (self.index > 0) {
            left1 = self.titleButtons[self.index - 1].frame.origin.x;
            width1 = self.titleButtons[self.index - 1].frame.size.width;
        } else{
            
        }
        
    }
    
    CGFloat x = self.line.frame.origin.x;
    CGFloat width = self.line.frame.size.width;
    CGFloat ratio = fabs(offset / self.contentScrollView.frame.size.width);
    
    // move : (width1 - x + left1)
    // move : offset
    // (width1 - x + left1) / width1 = ratio
    CGFloat offset_x = left1 - left0;
    x =left0 + offset_x * ratio;
    
    // move : (width-width0)/(width1-width0)
    // move : offset
    // (width-width0)/(width1-width0) / (width1-width0) = ratio
    CGFloat offset_width = width1 - width0;
    width = width0 + offset_width * ratio;
    
    [self moveIndicatorToLeft:x width:width animated:NO];
    
}

#pragma mark - scroll view delegate

// will begin dragging
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}

// scrolling
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self moveIndicatorWithScrollViewContentOffset:scrollView.contentOffset.x];
    
}

// did end decelerating (end scroll)
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // select index
    self.selectIndex((NSUInteger)scrollView.contentOffset.x/self.frame.size.width);
    
}



@end
