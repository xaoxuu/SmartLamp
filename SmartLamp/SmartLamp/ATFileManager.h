//
//  ATFileManager.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-05-10.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATFileManager : NSObject



// 文件枚举
typedef NS_ENUM(NSUInteger,ATFileType){
    // 情景模式配置文件
    ATFileTypeProfilesList,
    // 已连接过的蓝牙设备列表文件
    ATFileTypeDevice,
    
};

// 保存缓存
+ (void)saveCache:(ATProfiles *)aProfiles;

// 读取缓存
+ (ATProfiles *)readCache;

// 保存文件
+ (BOOL)saveFile:(ATFileType)file withPlist:(NSMutableArray *)plist;

// 读取文件
+ (NSMutableArray *)readFile:(ATFileType)file;

// 删除文件
+ (void)removeFile:(ATFileType)file;


@end
