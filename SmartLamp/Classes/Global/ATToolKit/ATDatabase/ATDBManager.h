//
//  ATDBManager.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-08.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ATDBManager;

extern ATDBManager *atDatabase;

@interface ATDBManager : NSObject

// query
- (NSArray<NSDictionary *> *)queryCount:(NSUInteger)count;

// delete
- (BOOL)deleteNews:(NSDictionary *)dict;
// insert

// insert news list
- (BOOL)insertNewsList:(NSArray<NSDictionary *> *)list;

// create table
- (void)createTable;

// life circle
+ (instancetype)defaultManager;

@end
