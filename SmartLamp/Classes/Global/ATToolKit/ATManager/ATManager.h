//
//  ATManager.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-06.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATManager : NSObject

#pragma mark - life circle

#pragma mark creator
// please call this method in app delegate
+ (instancetype)defaultManager;

@end
