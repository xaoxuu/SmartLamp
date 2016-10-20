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

@implementation ATFileManager

#pragma mark - cache

// read cache
+ (ATProfiles *)readCache{

    return FILE_PROFILES.cachePath.readArchivedPlist;
    
}

// save cache
+ (void)saveCache:(ATProfiles *)aProfiles{
    
    FILE_PROFILES.cachePath.savePlist(aProfiles);
    
}



#pragma mark - profiles

// read profiles
+ (NSMutableArray<ATProfiles *> *)readProfilesList{
    
    NSMutableArray *file = FILE_PROFILES.docPath.readArchivedPlist;
    if (!file.count) file = [NSMutableArray array];
    return file;
    
}
// save profiles
+ (void)saveProfilesList:(NSMutableArray<ATProfiles *> *)file{

    FILE_PROFILES.docPath.saveArchivedPlist(file);
    
}
// insert a profiles
+ (void)insertProfiles:(ATProfiles *)aProfiles toIndex:(NSUInteger)index{
    
    NSMutableArray *file = [self readProfilesList];
    [file insertObject:aProfiles atIndex:index];
    [self saveProfilesList:file];
}
// remove first object
+ (void)removeProfilesFirstObject {
    NSMutableArray *file = [self readProfilesList];
    [file removeObjectAtIndex:0];
    [self saveProfilesList:file];
}
// remove a profiles
+ (void)removeProfiles:(ATProfiles *)aProfiles {
    NSMutableArray *file = [self readProfilesList];
    BOOL ret;
    if ([file containsObject:aProfiles]) {
        [file removeObject:aProfiles];
        ret = YES;
    } else{
        ret = NO;
    }
    ATLogBOOL(ret);
    [self saveProfilesList:file];
}
// remove a profiles at index
+ (void)removeProfilesObjectAtIndex:(NSUInteger)index {
    NSMutableArray *file = [self readProfilesList];
    [file removeObjectAtIndex:index];
    [self saveProfilesList:file];
}
// remove last object
+ (void)removeProfilesLastObject {
    NSMutableArray *file = [self readProfilesList];
    [file removeLastObject];
    [self saveProfilesList:file];
}
// delete file
+ (void)deleteProfilesFile {
    
    FILE_PROFILES.docPath.removePlist;
    
}


#pragma mark - device

// read device list
+ (NSMutableArray *)readDeviceList {

    NSMutableArray *file = FILE_DEVICE.docPath.readArchivedPlist;
    if (!file.count) file = [NSMutableArray array];
    return file;
    
}
// save device list
+ (void)saveDeviceList:(NSMutableArray *)file {
    
    FILE_DEVICE.docPath.savePlist(file);
    
}
// delete file
+ (void)deleteDeviceFile {
    
    FILE_DEVICE.docPath.removePlist;
    
}


@end
