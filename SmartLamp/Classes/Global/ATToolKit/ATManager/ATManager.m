//
//  ATManager.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-06.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ATManager.h"

ATManager *atManager = nil;

@implementation ATManager


#pragma mark - life circle

// allocWithZone
+ (id) allocWithZone:(NSZone *)zone{
    if (!atManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if (!atManager) {
                atManager = [super allocWithZone:zone];
            }
        });
    }
    return atManager;
}

// init
- (instancetype) init{
    if (!atManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if (!atManager) {
                atManager = [[ATManager alloc] init];
            }
        });
    }
    // init property here
    
    
    
    return atManager;
}

// copyWithZone
+ (id)copyWithZone:(struct _NSZone *)zone{
    return [self sharedManager];
}

// copyWithZone
- (id)copyWithZone:(struct _NSZone *)zone{
    return [ATManager sharedManager];
}

// mutableCopyWithZone
+ (id)mutableCopyWithZone:(struct _NSZone *)zone{
    return [self sharedManager];
}

// mutableCopyWithZone
- (id)mutableCopyWithZone:(struct _NSZone *)zone{
    return [ATManager sharedManager];
}

// copy
+ (id)copy{
    return [ATManager sharedManager];
}

#pragma mark creator

// defaultCentralManager
+ (instancetype)defaultManager{
    return [self sharedManager];
}

// sharedCentralManager
+ (instancetype)sharedManager{
    if (!atManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if (!atManager) {
                atManager = [[ATManager alloc]init];
            }
        });
    }
    return atManager;
}


@end
