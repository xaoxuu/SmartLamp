//
//  ATCarouselView.m
//  ATCarouselView
//
//  Created by Aesir Titan on 2016-08-25.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "ATCarouselView.h"

#define selfWidth  self.bounds.size.width
#define selfHeight self.bounds.size.height

static CGFloat margin = 8;

@interface ATCarouselView () <UIScrollViewDelegate>

// images
@property (copy, nonatomic) void (^requestImage)(UIImageView *imageView,NSUInteger index);
// titles
@property (copy, nonatomic) NSString *(^requestTitle)(NSUInteger index);
// indicator
@property (copy, nonatomic) void (^requestIndicator)(UIPageControl *indicator);
// action
@property (copy, nonatomic) void (^requestTapAction)(NSUInteger index);
// scroll view
@property (strong, nonatomic) UIScrollView *scrollView;
// image views
//@property (strong, nonatomic) NSMutableArray<UIImageView *> *imageViews;
// page control
@property (strong, nonatomic) UIPageControl *pageControl;

// timer
@property (strong, nonatomic) NSTimer *timer;

// tap
//@property (copy, nonatomic) void (^tapAction)(NSUInteger);

// current index
@property (assign, nonatomic) NSUInteger index;

// count of pages
@property (assign, nonatomic) NSUInteger count;

// label
@property (strong, nonatomic) UILabel *label;

// titles
@property (strong, nonatomic) NSArray<NSString *> *titles;

// timeout
@property (assign, nonatomic) NSTimeInterval timeout;


@end

@implementation ATCarouselView

#pragma mark - creator


+ (instancetype)carouselWithView:(UIView *)view
                           count:(NSUInteger)count
                           image:(void (^)(UIImageView *imageView,NSUInteger index))image
                           title:(NSString *(^)(NSUInteger index))title
                       indicator:(void (^)(UIPageControl *indicator))indicator
                         timeout:(NSTimeInterval)timeout
                          action:(void (^)(NSUInteger index))action{
    return [[self alloc] initWithView:view count:count image:image title:title indicator:indicator timeout:timeout action:action];
}
- (instancetype)initWithView:(UIView *)view
                       count:(NSUInteger)count
                       image:(void (^)(UIImageView *imageView,NSUInteger index))image
                       title:(NSString *(^)(NSUInteger index))title
                   indicator:(void (^)(UIPageControl *indicator))indicator
                     timeout:(NSTimeInterval)timeout
                      action:(void (^)(NSUInteger index))action{
    if (self = [self initWithFrame:view.bounds]) {
        [view addSubview:self];
        self.count = count;
        self.requestImage = image;
        self.requestTitle = title;
        self.requestIndicator = indicator;
        self.timeout = timeout;
        self.requestTapAction = action;
        [self loadCarouselView];
    }
    return self;
}


- (void)loadCarouselView{
    // init property
    self.clipsToBounds = YES;
    self.index = 0;
    
    // setup
    [self _initScrollView];
    [self _initImageViews];
    [self _initPageControl];
    [self _initTitleLabel];
    [self _initGestureAction];
    if (self.timeout) {
        [self _initTimer];
    }
    
    // start
    [self updateContent];
    
}

//
- (void)_initScrollView{
    if (!_scrollView) {
        // create it
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        [self addSubview:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)]];
        [self addSubview:_scrollView];
        // style
        _scrollView.bounces = NO;
        _scrollView.scrollEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollsToTop = NO;
        // content size
        _scrollView.contentSize = CGSizeMake(selfWidth * self.count, 0);
    }
}
// setup image views
- (void)_initImageViews{
    CGFloat imageX = 0;
    for (NSUInteger i=0; i<self.count; i++) {
        // creat
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:self.bounds];
        // request image
        if (self.requestImage) {
            self.requestImage(imgv,i);
        }
        // setting
        imgv.clipsToBounds = YES;
        imgv.contentMode = UIViewContentModeScaleAspectFill;
        imgv.frame = CGRectMake(imageX, 0, selfWidth, selfHeight);
        imageX += selfWidth;
        [self.scrollView addSubview:imgv];
    }
}

// setup page control
- (void)_initPageControl{
    // optional
    if (self.requestIndicator) {
        self.pageControl = [[UIPageControl alloc] init];
        // frame
        CGRect frame = self.pageControl.frame;
        frame.origin.x = selfWidth / 2;
        frame.origin.y = selfHeight - frame.size.height - margin;
        self.pageControl.frame = frame;
        // request setting
        self.requestIndicator(self.pageControl);
        // pages
        self.pageControl.numberOfPages = self.count;
        [self addSubview:_pageControl];
    }
    
}

- (void)_initTitleLabel{
    // optional
    if (self.requestTitle) {
        // init and add to superview
        self.label = [[UILabel alloc] init];
        [self addSubview:self.label];
        self.label.font = [UIFont systemFontOfSize:14];
        self.label.textColor = [UIColor whiteColor];
        if (!_label.text.length) {
            self.label.text = @"测试数据";
        }
        [self.label sizeToFit];
        
        [self updateLabelFrame];
        
    }
}

- (void)_initGestureAction{
    if (self.requestTapAction) {
        // init and add to superview
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapMethod:)];
        [self addGestureRecognizer:tap];
    }
    
}

// tap action
- (void)_tapMethod:(UITapGestureRecognizer *)sender{
    if (self.requestTapAction) {
        self.requestTapAction(self.index);
    }
}
// start animation
- (void)_initTimer{
    self.timer = [NSTimer timerWithTimeInterval:self.timeout target:self selector:@selector(slidingWithTimer) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self startAutoSlide];
}

// frame
- (void)setFrame:(CGRect)frame{
    CGPoint offset = self.scrollView.contentOffset;
    [super setFrame:frame];
    // set scroll view frame
    self.scrollView.frame = frame;
    // reset offset
    self.scrollView.contentOffset = offset;
    // set image frame
    for (UIImageView *imgv in self.scrollView.subviews) {
        CGRect imgvFrame = imgv.frame;
        imgvFrame.size.height = frame.size.height;
        imgv.frame = imgvFrame;
    }
    [self updateLabelFrame];
}
- (void)updateLabelFrame{
    CGRect frame = self.label.frame;
    frame.origin.x = margin;
    frame.size.width = self.frame.size.width - 2*margin;
    frame.origin.y = selfHeight - frame.size.height - margin;
    if (self.requestIndicator) {
        CGFloat bottomInset = selfHeight - self.pageControl.frame.origin.y - self.pageControl.frame.size.height;
        if (bottomInset < 2*margin + frame.size.height) {
            frame.origin.y = self.pageControl.frame.origin.y - frame.size.height - 0.5*margin;
        } else{
            frame.origin.y = selfHeight - frame.size.height - margin;
        }
    }
    self.label.frame = frame;
}

- (void)updateContent{
    // update label
    if (self.label) {
        self.label.text = self.requestTitle(self.index);
    }
    // update page
    self.pageControl.currentPage = self.index;
}

// animating
- (void)slidingWithTimer{
    self.index++;
    if (self.index >= self.count) {
        self.index = 0;
    }
    // scroll
    [self.scrollView setContentOffset:CGPointMake(selfWidth * self.index, 0) animated:YES];
    
    [self updateContent];
}

-(void)startAutoSlide{
    if ([self.timer isValid]) {
        [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.timeout]];
    }
}

-(void)stopAutoSlide{
    if ([self.timer isValid]) {
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}

#pragma mark - scroll view delegate

// will begin dragging
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopAutoSlide];
}

// scrolling
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

// did end decelerating (end scroll)
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self startAutoSlide];
    NSUInteger index = self.scrollView.contentOffset.x / selfWidth;
    self.index = index;
    self.pageControl.currentPage = self.index;
    [self.scrollView setContentOffset:CGPointMake(index*selfWidth, 0) animated:YES];
    [self updateContent];
}

// did scroll to top
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    
}


@end
