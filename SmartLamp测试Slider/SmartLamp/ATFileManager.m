//
//  ATFileManager.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-05-10.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "ATFileManager.h"

@implementation ATFileManager

+ (void)saveCache:(ATProfiles *)aProfiles{
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:aProfiles];
    [data writeToFile:[self cachePath] atomically:YES];
    
}

+ (ATProfiles *)readCache{
    
    NSData *data = [NSData dataWithContentsOfFile:[self cachePath]];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
}

// 保存文件
+ (BOOL)saveFile:(ATFileType)file withPlist:(NSMutableArray *)plist{
    
    NSString *path;
    
    BOOL result = NO;
    switch (file) {
        case ATFileTypeDevice: //
            path = [self docPathWithFileName:@"ConnectedDeviceList"];
            
            result = [plist writeToFile:path atomically:YES];
            
            return result;
        case ATFileTypeProfilesList: //
            path = [self docPathWithFileName:@"ProfilesList"];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:plist];
            result = [data writeToFile:path atomically:YES];
            return result;
    }
    
    
}

// 读取文件
+ (NSMutableArray *)readFile:(ATFileType)file{
    
    NSString *path;
    NSMutableArray *plist = [NSMutableArray array];
    switch (file) {
        case ATFileTypeDevice: //
            path = [self docPathWithFileName:@"ConnectedDeviceList"];
            plist = [NSMutableArray arrayWithContentsOfFile:path];
            if (!plist.count) {
                plist = [NSMutableArray array];
            }
            return plist;
        case ATFileTypeProfilesList: //
            path = [self docPathWithFileName:@"ProfilesList"];
            NSData *data = [NSData dataWithContentsOfFile:path];
            plist = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            if (!plist.count) {
                plist = [NSMutableArray array];
            }
            return plist;
    }
 
}


+ (void)removeFile:(ATFileType)file{
    
    NSString *path;
    NSFileManager *fm = [NSFileManager defaultManager];
    switch (file) {
        case ATFileTypeDevice:
            path = [self docPathWithFileName:@"ConnectedDeviceList"];
            break;
        case ATFileTypeProfilesList: //
            path = [self docPathWithFileName:@"ProfilesList"];
            break;

    }
    [fm removeItemAtPath:path error:nil];
    return;
    
}



// 获取 Document 下的文件完整路径
+ (NSString *)docPathWithFileName:(NSString *)fileName{
    
    /*======================[ 获取路径 ]======================*/
    // document
    NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // 合并路径 ( 文件夹路径 + 文件名 )
    NSString *filePath = [[documentPath objectAtIndex:0]
                          stringByAppendingPathComponent:fileName];
    filePath = [filePath stringByAppendingPathExtension:@"plist"];
    
    
    return filePath;
    
}

// 获取缓存文件路径
+ (NSString *)cachePath{
    
    NSArray *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    // 合并路径 ( 文件夹路径 + 文件名 )
    NSString *filePath = [[cachePath objectAtIndex:0]
                          stringByAppendingPathComponent:@"aProfiles"];
    filePath = [filePath stringByAppendingPathExtension:@"plist"];
    
    return filePath;
    
}





@end
