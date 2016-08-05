//
//  DiscoverNavigation.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-02.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "DiscoverNavigation.h"

@implementation DiscoverNavigation

- (void)awakeFromNib{
    [super awakeFromNib];
    self.title.layer.shadowOffset = CGSizeMake(0, 0);
    self.title.layer.shadowRadius = 1.5;
    self.title.layer.shadowOpacity = 0.5;
}

@end
