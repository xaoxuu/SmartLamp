//
//  ATDBManager.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-08.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ATDBManager.h"
#import <FMDB/FMDB.h>
#import <FMDB/FMDatabaseAdditions.h>

static NSArray *keys = nil;

static FMDatabase *database;
static BOOL isExist = NO;
static NSString *path;
ATDBManager *atDatabase = nil;
@implementation ATDBManager

+ (void)load{
    [self defaultManager];
}

+ (instancetype)defaultManager {
    if (!atDatabase) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            atDatabase = [[ATDBManager alloc] init];
        });
    }
    return atDatabase;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createTable];
    }
    return self;
}



- (void)createTable{
    path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    path = [path stringByAppendingPathComponent:@"NewsList.json"];
    NSFileManager *fm = [NSFileManager defaultManager];
    isExist = [fm fileExistsAtPath:path];
    // init table
    database = [FMDatabase databaseWithPath:path];
    // create
    [self executeTable:^BOOL{
        return [database executeUpdate:(@"create table if not exists NewsList (ID integer Primary key autoincrement, title varchar(128) , pubDate varchar(128) , source varchar(128) , imageurls varchar(128) , channelId varchar(128) , link varchar(128))")];
    }];
    
}


- (BOOL)insertNewsList:(NSArray<NSDictionary *> *)list{
    [self executeTable:^BOOL{
        FMResultSet *result = [database executeQuery:@"select * from NewsList"];
        NSUInteger count = 0;
        while ([result next]) {
            count++;
            if (count > 100) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
                [self createTable];
            }
        }
        return YES;
    }];
    
    return [self executeTable:^BOOL{
        for (NSMutableDictionary *dict in list) {
            [database executeUpdate:@"insert into NewsList (title,pubDate,source,imageurls,channelId,link) values (?,?,?,?,?,?)",dict[@"title"],dict[@"pubDate"],dict[@"source"],dict[@"imageurls"],dict[@"channelId"],dict[@"link"]];
        }
        return YES;
    }];
}

- (BOOL)insertNews:(NSDictionary *)dict{
    return [self executeTable:^BOOL{
        return [database executeUpdate:@"insert into NewsList (title,pubDate,source,imageurls,channelId,link) values (?,?,?,?,?,?)",dict[@"title"],dict[@"pubDate"],dict[@"source"],dict[@"imageurls"],dict[@"channelId"],dict[@"link"]];
    }];
}

- (BOOL)deleteNews:(NSDictionary *)dict{
    return [self executeTable:^BOOL{
        return [database executeUpdate:@"delete from NewsList where (title = ? and pubDate = ?  and source = ? and imageurls = ? and channelId = ? and link = ?)",dict[@"title"],dict[@"pubDate"],dict[@"source"],dict[@"imageurls"],dict[@"channelId"],dict[@"link"]];
    }];
}


- (NSArray<NSDictionary *> *)queryCount:(NSUInteger)count{
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:count];
    if (isExist) {
        // select * from NewsList id limit 0 , 2
        [self executeTable:^BOOL{
            FMResultSet *result = [database executeQuery:@"select * from NewsList"];
            
            for (int i=0; i<count; i++) {
                [result next];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[@"title"] = [result objectForColumnName:@"title"];
                dict[@"pubDate"] = [result objectForColumnName:@"pubDate"];
                dict[@"source"] = [result objectForColumnName:@"source"];
                dict[@"imageurls"] = [result objectForColumnName:@"imageurls"];
                dict[@"channelId"] = [result objectForColumnName:@"channelId"];
                dict[@"link"] = [result objectForColumnName:@"link"];
                
                [list addObject:dict];
            }
            
            return YES;
        }];
    }
    return list;
}


- (BOOL)executeTable:(BOOL (^)())exe{
    @synchronized (self) {
        // 1. open
        if (!database.open) {
            return NO;
        }
        // 2. exe
        BOOL ret = exe();
        // 3. close
        [database close];
        return ret;
    }
}




@end
