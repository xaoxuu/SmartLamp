//
//  DiscoverHeaderView.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-05.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "DiscoverHeaderView.h"
#import "ATManager+View.h"
#import "ATBannerView.h"
#import "ATCarouselView+Creator.h"
#import "WebViewController.h"

@interface DiscoverHeaderView ()

// banner
@property (strong, nonatomic) ATCarouselView *banner;
// header image
@property (strong, nonatomic) UIImageView *headerImage;

// masking
@property (strong, nonatomic) UIView *masking;


@end

static const NSUInteger countOfImages = 6;
static const CGFloat ratio = 1.2;
static const CGFloat minOpacity = 0.2;
static const CGFloat maxH = 160;

@implementation DiscoverHeaderView

+ (instancetype)headerWithHeight:(CGFloat)height{
    return [[self alloc] initWithHeight: height];
}

- (instancetype)initWithHeight:(CGFloat)height{
    if (self = [super initWithFrame:CGRectMake(0, 0, kScreenW, height)]) {
        [self setupBanner];
    }
    return self;
}

// setup masking
- (void)setupMasking{
    // init and add to superview
    self.masking = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.masking];
    self.masking.userInteractionEnabled = NO;
    // style
    self.masking.backgroundColor = atColor.black;
    self.masking.layer.opacity = minOpacity;
    
}

// setup banner
- (void)setupBanner{
    // init and add to superview
    
    self.banner = [ATCarouselView carouselWithView:self count:countOfImages bundleImageName:@"cover" titles:nil action:^(NSUInteger index) {
        WebViewController *web = [[WebViewController alloc] initWithTitle:@"Aesir Titan" urlStr:@"http://github.com/AesirTitan"];
        [self.controller.navigationController pushViewController:web animated:YES];
    }];
    self.layer.at_shadow(ATShadowDownNormal);
    [self setupMasking];
    
}

// frame
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.banner.height = self.height;
    self.masking.height = self.height;
    self.masking.layer.opacity = minOpacity + ratio - ratio * self.height / maxH;
}



@end
