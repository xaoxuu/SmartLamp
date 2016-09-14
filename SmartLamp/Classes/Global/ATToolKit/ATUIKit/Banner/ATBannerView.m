//
//  ATBannerView.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-06.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "ATBannerView.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

// page control bottom margin
static CGFloat margin = 4;
static UIImage *placeholder;

#define selfWidth  self.bounds.size.width
#define selfHeight self.bounds.size.height

@class ATBannerView;

@interface ATBannerView () <UIScrollViewDelegate>

// scroll view
@property (strong, nonatomic) UIScrollView *scrollView;
// page control
@property (strong, nonatomic) UIPageControl *pageControl;

// timer
@property (strong, nonatomic) NSTimer *timer;

// tap
@property (copy, nonatomic) void (^tapAction)(NSUInteger);

// current index
@property (assign, nonatomic) NSUInteger index;

// count of pages
@property (assign, nonatomic) NSUInteger pageCount;

@end

@implementation ATBannerView

#pragma mark - creator

// create a banner and add to view
+ (instancetype)bannerWithView:(UIView *)view bundleImagesName:(NSString *)name count:(NSUInteger)count action:(void (^)(NSUInteger index))action{
    return [[self alloc] initWithView:view bundleImagesName:name count:count action:action];
}
// create a banner and add to view
- (instancetype)initWithView:(UIView *)view bundleImagesName:(NSString *)name count:(NSUInteger)count action:(void (^)(NSUInteger index))action{
    if (self = [self initWithFrame:view.bounds]) {
        // setup images
        [self setupImageViewsWithBundleName:name count:count];
        // setup page control
        [self setupPageControl];
        // setup gesture and action
        [self setupGestureWithAction:action];
        // start animation
        [self startAnimation];
        // add to view
        [view addSubview:self];
    }
    return self;
}

// create a banner and add to view
+ (instancetype)bannerWithView:(UIView *)view images:(NSArray<UIImage *> *)images action:(void (^)(NSUInteger index))action{
    return [[self alloc] initWithView:view images:images action:action];
}
// create a banner and add to view
- (instancetype)initWithView:(UIView *)view images:(NSArray<UIImage *> *)images action:(void (^)(NSUInteger index))action{
    if (self = [self initWithFrame:view.bounds]) {
        // setup images
        [self setupImageViewsWithImages:images];
        // setup page control
        [self setupPageControl];
        // setup gesture and action
        [self setupGestureWithAction:action];
        // start animation
        [self startAnimation];
        // add to view
        [view addSubview:self];
    }
    return self;
}

// create a banner and add to view
+ (instancetype)bannerWithView:(UIView *)view imageURLs:(NSArray<NSString *> *)imageURLs action:(void (^)(NSUInteger index))action{
    return [[self alloc] initWithView:view imageURLs:imageURLs action:action];
}
// create a banner and add to view
- (instancetype)initWithView:(UIView *)view imageURLs:(NSArray<NSString *> *)imageURLs action:(void (^)(NSUInteger index))action{
    if (self = [self initWithFrame:view.bounds]) {
        // setup images
        [self setupImageViewsWithImageURLs:imageURLs];
        // setup page control
        [self setupPageControl];
        // setup gesture and action
        [self setupGestureWithAction:action];
        // start animation
        [self startAnimation];
        // add to view
        [view addSubview:self];
    }
    return self;
}



// create a banner
+ (instancetype)bannerWithFrame:(CGRect)frame images:(NSArray<UIImage *> *)images action:(void (^)(NSUInteger index))action{
    return [[self alloc] initWithFrame:frame images:images action:action];
}
// create a banner 
- (instancetype)initWithFrame:(CGRect)frame images:(NSArray<UIImage *> *)images action:(void (^)(NSUInteger index))action{
    if (self = [self initWithFrame:frame]) {
        // setup images
        [self setupImageViewsWithImages:images];
        // setup page control
        [self setupPageControl];
        // setup gesture and action
        [self setupGestureWithAction:action];
        // start animation
        [self startAnimation];
    }
    return self;
}

// create a banner
+ (instancetype)bannerWithFrame:(CGRect)frame imageURLs:(NSArray<NSString *> *)imageURLs action:(void (^)(NSUInteger index))action{
    return [[self alloc] initWithFrame:frame imageURLs:imageURLs action:action];
}
// create a banner
- (instancetype)initWithFrame:(CGRect)frame imageURLs:(NSArray<NSString *> *)imageURLs action:(void (^)(NSUInteger index))action{
    if (self = [self initWithFrame:frame]) {
        // setup images
        [self setupImageViewsWithImageURLs:imageURLs];
        // setup page control
        [self setupPageControl];
        // setup gesture and action
        [self setupGestureWithAction:action];
        // start animation
        [self startAnimation];
    }
    return self;
}

// init
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]){
        
        _timeout = 5.0f;
        _index = 0;
        _pageCount = 0;
        
        self.clipsToBounds = YES;
        
    }
    return self;
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
        imgv.height = frame.size.height;
    }
}

// setup image views with bundle image
- (void)setupImageViewsWithBundleName:(NSString *)name count:(NSUInteger)count{
    // page count
    self.pageCount = count;
    // add images
    CGFloat imageX = 0;
    for (int i=0; i<count; i++) {
        NSString *path = [[NSBundle mainBundle] pathForResource:
                          [name stringByAppendingString:
                           [NSString stringWithFormat:@"%d",i]] ofType:@"png"];
        UIImage *img = [UIImage imageWithContentsOfFile:path];
        
        
        UIImageView *imgv = [[UIImageView alloc] initWithImage:img];
        imgv.clipsToBounds = YES;
        imgv.contentMode = UIViewContentModeScaleAspectFill;
        imgv.frame = CGRectMake(imageX, 0, selfWidth, selfHeight);
        imageX += selfWidth;
        [self.scrollView addSubview:imgv];
    }
    
}
// setup image views with images
- (void)setupImageViewsWithImages:(NSArray<UIImage *> *)images{
    // page count
    self.pageCount = images.count;
    // add images
    CGFloat imageX = 0;
    for (int i=0; i<images.count; i++) {
        UIImageView *imgv = [[UIImageView alloc] initWithImage:images[i]];
        imgv.clipsToBounds = YES;
        imgv.contentMode = UIViewContentModeScaleAspectFill;
        imgv.frame = CGRectMake(imageX, 0, selfWidth, selfHeight);
        imageX += selfWidth;
        [self.scrollView addSubview:imgv];
    }
    
}

// setup image views with image urls
- (void)setupImageViewsWithImageURLs:(NSArray<NSString *> *)URLs{
    // page count
    self.pageCount = URLs.count;
    // add images
    CGFloat imageX = 0;
    for (int i=0; i<URLs.count; i++) {
        UIImageView *imgv = [[UIImageView alloc] init];
        imgv.clipsToBounds = YES;
        [imgv sd_setImageWithURL:[NSURL URLWithString:URLs[i]] placeholderImage:placeholder];
        imgv.contentMode = UIViewContentModeScaleAspectFill;
        imgv.frame = CGRectMake(imageX, 0, selfWidth, selfHeight);
        imageX += selfWidth;
        [self.scrollView addSubview:imgv];
    }
}

// setup page control
- (void)setupPageControl{
    // init and add to superview
    _pageControl = [[UIPageControl alloc] init];
    [self addSubview:_pageControl];
    // pages
    _pageControl.numberOfPages = self.pageCount;
    // frame
    CGRect frame = _pageControl.frame;
    frame.origin.x = selfWidth / 2;
//    frame.origin.y = selfHeight - frame.size.height - margin;
    frame.origin.y = 20 + margin;
    _pageControl.frame = frame;
    
    [self setupScrollViewContentSize];
    
}

- (void)setupScrollViewContentSize{
    // content size
    _scrollView.contentSize = CGSizeMake(selfWidth * self.pageCount, 0);
}

// setup gesture
- (void)setupGestureWithAction:(void (^)(NSUInteger))action{
    // init and add to superview
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
    // setup action
    self.tapAction = action;
    
}

// tap action
- (void)tapAction:(UITapGestureRecognizer *)sender{
    if (self.tapAction) {
        self.tapAction(self.index);
    }
}


// start animation
- (void)startAnimation{
    self.timer = [NSTimer timerWithTimeInterval:self.timeout target:self selector:@selector(animatingWithTimer) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}



// animating
- (void)animatingWithTimer{
    // scroll
    [self.scrollView setContentOffset:CGPointMake(selfWidth * self.index, 0) animated:YES];
    // update page
    self.pageControl.currentPage = self.index;
    self.index++;
    if (self.index >= self.pageCount) {
        self.index = 0;
    }
}

// update page
- (void)updatePage{
    NSUInteger index = self.scrollView.contentOffset.x / selfWidth;
    self.index = index;
    self.pageControl.currentPage = self.index;
    [self.scrollView setContentOffset:CGPointMake(index*selfWidth, 0) animated:YES];
}

#pragma mark lazy load

- (UIScrollView *)scrollView{
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
        
    }
    return _scrollView;
    
}

#pragma mark - scroll view delegate

// will begin dragging
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}

// scrolling
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

// did end decelerating (end scroll)
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self updatePage];
}

// did scroll to top
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    
}


@end
