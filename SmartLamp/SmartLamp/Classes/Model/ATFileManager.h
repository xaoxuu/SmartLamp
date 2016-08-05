//
//  ATFileManager.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-05-10.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATFileManager : NSObject

#pragma mark - cache

/**
 *	@author Aesir Titan, 2016-07-21 19:07:53
 *
 *	@brief read cache
 *
 *	@return current profiles
 */
+ (ATProfiles *)readCache;
/**
 *	@author Aesir Titan, 2016-07-21 19:07:05
 *
 *	@brief save cache
 *
 *	@param aProfiles current profiles
 */
+ (void)saveCache:(ATProfiles *)aProfiles;


#pragma mark - profiles

/**
 *	@author Aesir Titan, 2016-07-21 19:07:00
 *
 *	@brief read profiles list
 *
 *	@return profiles list
 */
+ (NSMutableArray<ATProfiles *> *)readProfilesList;
/**
 *	@author Aesir Titan, 2016-07-21 19:07:15
 *
 *	@brief save profiles list
 *
 *	@param plist profiles list
 *
 *	@return result
 */
+ (BOOL)saveProfilesList:(NSMutableArray<ATProfiles *> *)plist;
/**
 *	@author Aesir Titan, 2016-07-21 19:07:28
 *
 *	@brief delete profiles list file
 */
+ (void)deleteProfilesFile;
/**
 *	@author Aesir Titan, 2016-07-21 19:07:51
 *
 *	@brief insert aProfiles to index
 *
 *	@param aProfiles	aProfiles
 *	@param index		index
 */
+ (void)insertProfiles:(ATProfiles *)aProfiles toIndex:(NSUInteger)index;
/**
 *	@author Aesir Titan, 2016-07-21 19:07:37
 *
 *	@brief remove first object
 */
+ (void)removeProfilesFirstObject;
/**
 *	@author Aesir Titan, 2016-07-23 18:07:55
 *
 *	@brief remove aProfiles
 *
 *	@param aProfiles	aProfiles
 */
+ (void)removeProfiles:(ATProfiles *)aProfiles;
/**
 *	@author Aesir Titan, 2016-07-21 19:07:26
 *
 *	@brief remove object at index
 *
 *	@param index	index
 */
+ (void)removeProfilesObjectAtIndex:(NSUInteger)index;
/**
 *	@author Aesir Titan, 2016-07-21 19:07:42
 *
 *	@brief remove last object
 */
+ (void)removeProfilesLastObject;


#pragma mark - device

/**
 *	@author Aesir Titan, 2016-07-21 19:07:00
 *
 *	@brief save device list
 *
 *	@param plist	device list
 *
 *	@return result
 */
+ (BOOL)saveDeviceList:(NSMutableArray *)plist;
/**
 *	@author Aesir Titan, 2016-07-21 19:07:25
 *
 *	@brief read device list
 *
 *	@return device list
 */
+ (NSMutableArray *)readDeviceList;
/**
 *	@author Aesir Titan, 2016-07-21 19:07:51
 *
 *	@brief delete device list file
 */
+ (void)deleteDeviceFile;


@end
