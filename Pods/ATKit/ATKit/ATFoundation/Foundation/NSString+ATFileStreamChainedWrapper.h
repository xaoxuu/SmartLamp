//
//  NSString+ATFileStreamChainedWrapper.h
//  Foundation
//
//  Created by Aesir Titan on 2016-08-13.
//  Copyright © 2016 Titan Studio. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ATFileStreamChainedWrapper)

#pragma mark read

/*!
 *	@author Aesir Titan
 *
 *	@brief read a array
 *  读取一个数组或可变数组(自动追加.plist)
 *
 *	@return a array
 */
- (nullable __kindof NSArray *)readArray;

/*!
 *	@author Aesir Titan
 *
 *	@brief read a dictionary
 *  读取一个字典或可变字典(自动追加.plist)
 *
 *	@return a dictionary
 */
- (nullable __kindof NSDictionary *)readDictionary;

/*!
 *	@author Aesir Titan
 *
 *	@brief read a archived plist file
 *  解档一个已归档的plist文件(自动追加.plist)
 *
 *	@return a archived plist file
 */
- (nullable id)readArchivedPlist;

/*!
 *	@author Aesir Titan
 *
 *	@brief read a json file with NSJSONSerialization
 *  读取一个json文件(返回一个数组或字典)(自动追加.json)
 *
 *	@return a json file with NSJSONSerialization
 */
- (nullable id)readJson;

/*!
 *	@author Aesir Titan
 *
 *	@brief read a txt file
 *  读取一个纯文本文件(自动追加.txt)
 *
 *	@return a txt file
 */
- (nullable NSString *)readTxt;

/*!
 *	@author Aesir Titan
 *
 *	@brief read file
 *  解档一个已归档的文件
 *
 *	@return a file
 */
- (nullable id)readArchivedFile;

#pragma mark - save

/*!
 *	@author Aesir Titan
 *
 *	@brief save a plist file
 *  保存一个plist文件（自动追加.plist）
 *
 *	@return success or not
 */
- (BOOL(^)(id))savePlist;

/*!
 *	@author Aesir Titan
 *
 *	@brief save a archived plist file
 *  归档一个实现NSCoding协议的plist文件（自动追加.plist）
 *
 *	@return success or not
 */
- (BOOL(^)(NSObject<NSCoding> *))saveArchivedPlist;

/*!
 *	@author Aesir Titan
 *
 *	@brief save file
 *  归档一个文件
 *
 *	@return success or not
 */
- (BOOL(^)(id <NSCoding>))save;

#pragma mark - remove

/*!
 *	@author Aesir Titan
 *
 *	@brief remove a plist file
 *  删除一个plist文件（自动追加.plist）
 *
 *	@return success or not
 */
- (BOOL)removePlist;

/*!
 *	@author Aesir Titan
 *
 *	@brief remove a json file
 *  删除一个json文件（自动追加.json）
 *
 *	@return success or not
 */
- (BOOL)removeJson;

/*!
 *	@author Aesir Titan
 *
 *	@brief remove a txt file
 *  删除一个txt文件（自动追加.txt）
 *
 *	@return success or not
 */
- (BOOL)removeTxt;

/*!
 *	@author Aesir Titan
 *
 *	@brief remove a file
 *  删除一个文件
 *
 *	@return success or not
 */
- (BOOL)remove;

#pragma mark path

/*!
 *	@author Aesir Titan
 *
 *	@brief return a path in main bundle named 'self'
 *  self在mainBundle中的完整路径
 *
 *	@return a path in main bundle named 'self'
 */
- (nullable NSString *)mainBundlePath;

/*!
 *	@author Aesir Titan
 *
 *	@brief return a string's documents path
 *  self在documents中的完整路径
 *
 *	@return a string's documents path
 */
- (NSString *)docPath;

/*!
 *	@author Aesir Titan
 *
 *	@brief return a string's cache path
 *  self在cache中的完整路径
 *
 *	@return a string's cache path
 */
- (NSString *)cachePath;

/*!
 *	@author Aesir Titan
 *
 *	@brief return a string's temp path
 *  self在tmp中的完整路径
 *
 *	@return a string's temp path
 */
- (NSString *)tempPath;

/*!
 *	@author Aesir Titan
 *
 *	@brief return a string's path
 *  self在NSSearchPathDirectory中的完整路径
 *
 *	@return a string's path
 */
- (NSString *(^)(NSSearchPathDirectory))path;

#pragma mark - extension

/*!
 *	@author Aesir Titan
 *
 *	@brief append a string's extension
 *  追加一个扩展名
 *
 *	@return a string's path
 */
- (NSString *(^)(NSString *))extension;

/*!
 *	@author Aesir Titan
 *
 *	@brief append extension named '.plist' to current string
 *  追加.plist
 *
 *	@return a path
 */
- (NSString *)plist;

/*!
 *	@author Aesir Titan
 *
 *	@brief append extension named '.json' to current string
 *  追加.json
 *
 *	@return a path
 */
- (NSString *)json;

/*!
 *	@author Aesir Titan
 *
 *	@brief append extension named '.txt' to current string
 *  追加.txt
 *
 *	@return a path
 */
- (NSString *)txt;

#pragma mark - subpath

/*!
 *	@author Aesir Titan
 *
 *	@brief return all plist file paths
 *  self路径下的所有文件路径
 *
 *  @return a array contains all subpaths
 */
- (nullable NSArray<NSString *> *(^)(NSString *__nullable))subpaths;


@end

NS_ASSUME_NONNULL_END

