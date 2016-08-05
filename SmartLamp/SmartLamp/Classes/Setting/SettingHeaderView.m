//
//  SettingHeaderView.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-02.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "SettingHeaderView.h"

@implementation SettingHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _headerImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return self;
}

@end
