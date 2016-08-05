//
//  DiscoverTableHeaderView.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-02.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "DiscoverTableHeaderView.h"

@interface DiscoverTableHeaderView ()


@end


@implementation DiscoverTableHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupToolbar];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupToolbar];
    }
    return self;
}

- (void)setupToolbar{
    self.backgroundColor = atColor.backgroundColor;
    self.layer.shadowRadius = 1;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowOpacity = 0.15;
    self.atToolbar = [ATToolBar toolbarWithTitleView:self titles:@[@"头条",@"IT",@"本地"] titleColor:atColor.themeColor action:^(NSUInteger index) {
        
    }];
}





@end
