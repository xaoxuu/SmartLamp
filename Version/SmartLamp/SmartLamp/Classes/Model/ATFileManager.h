//
//  ATFileManager.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-05-10.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface ATFileManager : NSObject

#pragma mark - 缓存
/**
 *	@author Aesir Titan, 2016-07-21 19:07:53
 *
 *	@brief 读取缓存
 *
 *	@return 情景模式文件
 */
+ (ATProfiles *)readCache;
/**
 *	@author Aesir Titan, 2016-07-21 19:07:05
 *
 *	@brief 保存缓存
 *
 *	@param aProfiles	情景模式文件
 */
+ (void)saveCache:(ATProfiles *)aProfiles;


#pragma mark - 情景模式
/**
 *	@author Aesir Titan, 2016-07-21 19:07:00
 *
 *	@brief 读取情景模式列表
 *
 *	@return 模型数组
 */
+ (NSMutableArray<ATProfiles *> *)readProfilesList;
/**
 *	@author Aesir Titan, 2016-07-21 19:07:15
 *
 *	@brief 保存情景模式列表
 *
 *	@param plist	模型数组
 *
 *	@return 是否成功
 */
+ (BOOL)saveProfilesList:(NSMutableArray<ATProfiles *> *)plist;
/**
 *	@author Aesir Titan, 2016-07-21 19:07:28
 *
 *	@brief 删除情景模式列表文件
 */
+ (void)deleteProfilesFile;
/**
 *	@author Aesir Titan, 2016-07-21 19:07:51
 *
 *	@brief 向指定位置插入元素
 *
 *	@param aProfiles	目标情景模式配置文件
 *	@param index		索引位置
 */
+ (void)insertProfiles:(ATProfiles *)aProfiles toIndex:(NSUInteger)index;
/**
 *	@author Aesir Titan, 2016-07-21 19:07:37
 *
 *	@brief 删除第一个元素
 */
+ (void)removeProfilesFirstObject;
/**
 *	@author Aesir Titan, 2016-07-23 18:07:55
 *
 *	@brief 删除指定元素
 *
 *	@param aProfiles	指定对象
 */
+ (void)removeProfiles:(ATProfiles *)aProfiles;
/**
 *	@author Aesir Titan, 2016-07-21 19:07:26
 *
 *	@brief 删除指定位置的元素
 *
 *	@param index	索引
 */
+ (void)removeProfilesObjectAtIndex:(NSUInteger)index;
/**
 *	@author Aesir Titan, 2016-07-21 19:07:42
 *
 *	@brief 删除最后一个元素
 */
+ (void)removeProfilesLastObject;

#pragma mark - 设备列表
/**
 *	@author Aesir Titan, 2016-07-21 19:07:00
 *
 *	@brief 保存设备列表
 *
 *	@param plist	模型数组
 *
 *	@return 是否成功
 */
+ (BOOL)saveDeviceList:(NSMutableArray *)plist;
/**
 *	@author Aesir Titan, 2016-07-21 19:07:25
 *
 *	@brief 读取设备列表
 *
 *	@return 模型数组
 */
+ (NSMutableArray *)readDeviceList;
/**
 *	@author Aesir Titan, 2016-07-21 19:07:51
 *
 *	@brief 删除设备列表文件
 */
+ (void)deleteDeviceFile;


@end
