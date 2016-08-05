//
//  ATFileManager.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-05-10.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "ATFileManager.h"

#define FILE_PROFILES @"profiles"
#define FILE_DEVICE   @"device"
#define FILE_CACHE    @"cache"
#define FILE_PLIST    @"plist"

@implementation ATFileManager

#pragma mark - cache

// read cache
+ (ATProfiles *)readCache{
    
    NSData *data = [NSData dataWithContentsOfFile:[self cachePath]];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
}

// save cache
+ (void)saveCache:(ATProfiles *)aProfiles{
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:aProfiles];
    [data writeToFile:[self cachePath] atomically:YES];
    
}


#pragma mark - profiles

// read profiles
+ (NSMutableArray<ATProfiles *> *)readProfilesList{
    NSString *path = [self docPathWithFileName:FILE_PROFILES];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSMutableArray *plist = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (!plist.count) {
        plist = [NSMutableArray array];
    }
    return plist;
}
// save profiles
+ (BOOL)saveProfilesList:(NSMutableArray<ATProfiles *> *)plist {
    NSString *path = [self docPathWithFileName:FILE_PROFILES];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:plist];
    return [data writeToFile:path atomically:YES];
}
// insert a profiles
+ (void)insertProfiles:(ATProfiles *)aProfiles toIndex:(NSUInteger)index {
    NSMutableArray *plist = [self readProfilesList];
    [plist insertObject:aProfiles atIndex:index];
    [self saveProfilesList:plist];
}
// remove first object
+ (void)removeProfilesFirstObject {
    NSMutableArray *plist = [self readProfilesList];
    [plist removeObjectAtIndex:0];
    [self saveProfilesList:plist];
}
// remove a profiles
+ (void)removeProfiles:(ATProfiles *)aProfiles {
    NSMutableArray *plist = [self readProfilesList];
    BOOL ret;
    if ([plist containsObject:aProfiles]) {
        [plist removeObject:aProfiles];
        ret = YES;
    } else{
        ret = NO;
    }
    ATLogResult(ret);
    [self saveProfilesList:plist];
}
// remove a profiles at index
+ (void)removeProfilesObjectAtIndex:(NSUInteger)index {
    NSMutableArray *plist = [self readProfilesList];
    [plist removeObjectAtIndex:index];
    [self saveProfilesList:plist];
}
// remove last object
+ (void)removeProfilesLastObject {
    NSMutableArray *plist = [self readProfilesList];
    [plist removeLastObject];
    [self saveProfilesList:plist];
}
// delete file
+ (void)deleteProfilesFile {
    NSString *path;
    NSFileManager *fm = [NSFileManager defaultManager];
    path = [self docPathWithFileName:FILE_PROFILES];
    [fm removeItemAtPath:path error:nil];
}


#pragma mark - device

// read device list
+ (NSMutableArray *)readDeviceList {
    NSString *path = [self docPathWithFileName:FILE_DEVICE];
    NSMutableArray *plist = [NSMutableArray arrayWithContentsOfFile:path];
    if (!plist.count) {
        plist = [NSMutableArray array];
    }
    return plist;
}
// save device list
+ (BOOL)saveDeviceList:(NSMutableArray *)plist {
    NSString *path = [self docPathWithFileName:FILE_DEVICE];
    return [plist writeToFile:path atomically:YES];
}
// delete file
+ (void)deleteDeviceFile {
    NSString *path;
    NSFileManager *fm = [NSFileManager defaultManager];
    path = [self docPathWithFileName:FILE_DEVICE];
    [fm removeItemAtPath:path error:nil];
}


#pragma mark - private methods

// file path in document
+ (NSString *)docPathWithFileName:(NSString *)fileName{
    // document path
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    // appending path
    NSString *filePath = [documentPath stringByAppendingPathComponent:fileName];
    filePath = [filePath stringByAppendingPathExtension:FILE_PLIST];
    return filePath;
    
}

// cache path
+ (NSString *)cachePath{
    // cache path
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    // appending path
    NSString *filePath = [cachePath stringByAppendingPathComponent:FILE_CACHE];
    filePath = [filePath stringByAppendingPathExtension:FILE_PLIST];
    return filePath;
    
}



@end
