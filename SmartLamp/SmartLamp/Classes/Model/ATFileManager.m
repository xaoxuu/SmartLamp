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


#pragma mark - 📂📂📂📂📂📂📂📂📂📂 缓存
// 读取缓存
+ (ATProfiles *)readCache{
    
    NSData *data = [NSData dataWithContentsOfFile:[self cachePath]];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
}
// 保存缓存
+ (void)saveCache:(ATProfiles *)aProfiles{
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:aProfiles];
    [data writeToFile:[self cachePath] atomically:YES];
    
}

#pragma mark - 📂📂📂📂📂📂📂📂📂📂 情景模式
// 读情景模式文件
+ (NSMutableArray<ATProfiles *> *)readProfilesList{
    NSString *path = [self docPathWithFileName:FILE_PROFILES];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSMutableArray *plist = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (!plist.count) {
        plist = [NSMutableArray array];
    }
    return plist;
}
// 保存情景模式
+ (BOOL)saveProfilesList:(NSMutableArray<ATProfiles *> *)plist {
    NSString *path = [self docPathWithFileName:FILE_PROFILES];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:plist];
    return [data writeToFile:path atomically:YES];
}
// 插入元素
+ (void)insertProfiles:(ATProfiles *)aProfiles toIndex:(NSUInteger)index {
    NSMutableArray *plist = [self readProfilesList];
    [plist insertObject:aProfiles atIndex:index];
    [self saveProfilesList:plist];
}
// 删除第一个元素
+ (void)removeProfilesFirstObject {
    NSMutableArray *plist = [self readProfilesList];
    [plist removeObjectAtIndex:0];
    [self saveProfilesList:plist];
}
+ (void)removeProfiles:(ATProfiles *)aProfiles {
    NSMutableArray *plist = [self readProfilesList];
    if ([plist containsObject:aProfiles]) {
        [plist removeObject:aProfiles];
        LOG(@"删除成功");
    } else{
        LOG(@"删除失败");
    }
    
    [self saveProfilesList:plist];
}
// 删除指定位置的元素
+ (void)removeProfilesObjectAtIndex:(NSUInteger)index {
    NSMutableArray *plist = [self readProfilesList];
    [plist removeObjectAtIndex:index];
    [self saveProfilesList:plist];
}
// 删除最后一个元素
+ (void)removeProfilesLastObject {
    NSMutableArray *plist = [self readProfilesList];
    [plist removeLastObject];
    [self saveProfilesList:plist];
}
// 删除情景模式列表文件
+ (void)deleteProfilesFile {
    NSString *path;
    NSFileManager *fm = [NSFileManager defaultManager];
    path = [self docPathWithFileName:FILE_PROFILES];
    [fm removeItemAtPath:path error:nil];
}


#pragma mark - 📂📂📂📂📂📂📂📂📂📂 设备列表
+ (NSMutableArray *)readDeviceList {
    NSString *path = [self docPathWithFileName:FILE_DEVICE];
    NSMutableArray *plist = [NSMutableArray arrayWithContentsOfFile:path];
    if (!plist.count) {
        plist = [NSMutableArray array];
    }
    return plist;
}
+ (BOOL)saveDeviceList:(NSMutableArray *)plist {
    NSString *path = [self docPathWithFileName:FILE_DEVICE];
    return [plist writeToFile:path atomically:YES];
}
+ (void)deleteDeviceFile {
    NSString *path;
    NSFileManager *fm = [NSFileManager defaultManager];
    path = [self docPathWithFileName:FILE_DEVICE];
    [fm removeItemAtPath:path error:nil];
}

#pragma mark - 🚫🚫🚫🚫🚫🚫🚫🚫🚫🚫 私有方法


// 获取 Document 下的文件完整路径
+ (NSString *)docPathWithFileName:(NSString *)fileName{
    
    /*======================[ 获取路径 ]======================*/
    // document
    NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // 合并路径 ( 文件夹路径 + 文件名 )
    NSString *filePath = [[documentPath objectAtIndex:0]
                          stringByAppendingPathComponent:fileName];
    filePath = [filePath stringByAppendingPathExtension:FILE_PLIST];
    return filePath;
    
}

// 获取缓存文件路径
+ (NSString *)cachePath{
    
    NSArray *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    // 合并路径 ( 文件夹路径 + 文件名 )
    NSString *filePath = [[cachePath objectAtIndex:0]
                          stringByAppendingPathComponent:FILE_CACHE];
    filePath = [filePath stringByAppendingPathExtension:FILE_PLIST];
    
    return filePath;
    
}









@end
