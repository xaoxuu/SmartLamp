//
//  NSString+ATFileStreamChainedWrapper.m
//  Foundation
//
//  Created by Aesir Titan on 2016-08-13.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "NSString+ATFileStreamChainedWrapper.h"
#import "Foundation+ATLogExtension.h"

static NSString *plist = @"plist";
static NSString *json  = @"json";
static NSString *txt   = @"txt";


@implementation NSString (ATFileStreamChainedWrapper)

#pragma mark - read

- (NSArray *)readArray{
    return [self readArrayWithExtension:plist];
}

- (NSDictionary *)readDictionary{
    return [self readDictionaryWithExtension:plist];
}

- (id)readArchivedPlist{
    return [self readArchivedFileWithExtension:plist];
}

- (id)readJson{
    NSString *jsonStr = [NSString stringWithContentsOfFile:self.extension(json) encoding:NSUTF8StringEncoding error:nil];
    if (jsonStr.length) {
        return [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    } else {
        return nil;
    }
}

- (NSString *)readTxt{
    return [NSString stringWithContentsOfFile:self.extension(txt) encoding:NSUTF8StringEncoding error:nil];
}

#pragma mark - save

- (BOOL(^)(id))savePlist{
    return ^(id file){
        return [self writeFile:file extension:plist completion:nil];
    };
}

- (BOOL(^)(NSObject<NSCoding> *))saveArchivedPlist{
    return ^(id file){
        return [self writeArchivedFile:file extension:plist completion:nil];
    };
}

#pragma mark - remove

- (BOOL)removePlist{
    return [self removeFileWithExtension:plist completion:nil];
}
- (BOOL)removeJson{
    return [self removeFileWithExtension:json completion:nil];
}
- (BOOL)removeTxt{
    return [self removeFileWithExtension:txt completion:nil];
}
- (BOOL)remove{
    return [self removeFileWithExtension:nil completion:nil];
}

#pragma mark - path

- (NSString *)mainBundlePath{
    NSString *path = [[NSBundle mainBundle] pathForResource:self ofType:nil];
    if (!path.length) {
        if ([self containsString:@"."]) {
            ATLogFail(@"path not found.");
        } else{
            ATLogFail(@"path not found, please append the file's extension.");
        }
    }
    return path;
}

- (NSString *)docPath{
    return self.path(NSDocumentDirectory);
}
- (NSString *)cachePath{
    return self.path(NSCachesDirectory);
}
- (NSString *)tempPath{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:self];
}

- (NSArray<NSString *> *(^)(NSString *))subpaths{
    return ^(NSString *extension){
        NSFileManager *fm = [NSFileManager defaultManager];
        NSMutableArray *allPlist = [NSMutableArray array];
        NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:self];
        NSString *path;
        while ((path = dirEnum.nextObject) != nil) {
            if (!extension.length || [path.lastPathComponent containsString:extension]) {
                [allPlist addObject:[self stringByAppendingPathComponent:path]];
            }
        }
        return allPlist;
    };
}

#pragma mark - all

- (id)readArchivedFile{
    return [self readArchivedFileWithExtension:nil];
}

- (BOOL(^)(id <NSCoding>))save{
    return ^(id file){
        return [self writeFile:file extension:nil completion:nil];
    };
}

- (NSString *(^)(NSSearchPathDirectory))path{
    return ^(NSSearchPathDirectory searchPathDirectory){
        NSString *path = NSSearchPathForDirectoriesInDomains(searchPathDirectory, NSUserDomainMask, YES)[0];
        return [path stringByAppendingPathComponent:self];
    };
}

- (NSString *(^)(NSString *))extension{
    return ^(NSString *extension){
        if (extension.length && ![self.lastPathComponent containsString:[@"."stringByAppendingString:extension]]) {
            return [self stringByAppendingPathExtension:extension];
        } else{
            return self;
        }
    };
}

- (NSString *)plist{
    return self.extension(@"plist");;
}

- (NSString *)json{
    return self.extension(@"json");;
}

- (NSString *)txt{
    return self.extension(@"txt");;
}


#pragma mark - private methods

#pragma mark read file

- (NSArray *)readArrayWithExtension:(NSString *)extension{
    return [NSArray arrayWithContentsOfFile:self.extension(extension)];
}

- (NSDictionary *)readDictionaryWithExtension:(NSString *)extension{
    return [NSDictionary dictionaryWithContentsOfFile:self.extension(extension)];
}

- (id)readArchivedFileWithExtension:(NSString *)extension{
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:self.extension(extension)]) {
        NSData *data = [NSData dataWithContentsOfFile:self.extension(extension)];
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    } else{
        return nil;
    }
}

#pragma mark write file

- (BOOL)writeFile:(__kindof NSObject *)file
                                extension:(NSString *)extension
                               completion:(void (^)())completion{
    BOOL result = (BOOL)file;
    if (!result) {
        ATLogFail(@"nothing to save.");
        return NO;
    }
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *path = self.extension(extension);
    
    // create dir if not exist
    NSString *dir = path.stringByDeletingLastPathComponent;
    result = [fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    if (!result) {
        ATLogFail(@"can not create the directory at path %@",dir);
        return NO;
    }
    
    // create file if not exist
    result = [fm createFileAtPath:path contents:nil attributes:nil];
    if (!result) {
        ATLogFail(@"can not create the file at path %@",path);
        return NO;
    }
    
    // save contents to file
    // NSString
    if ([file isKindOfClass:[NSString class]]) {
        NSString *strFile = (NSString *)file;
        result = [strFile writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
        if (!result) {
            ATLogFail(@"save string fail, path:[%@]",path);
            return NO;
        }
    }
    // NSArray
    else if ([file isKindOfClass:[NSArray class]]||[file isKindOfClass:[NSMutableArray class]]) {
        NSArray *arrFile = (NSArray *)file;
        result = [arrFile writeToFile:path atomically:YES];
        if (!result) {
            ATLogFail(@"save array fail, path:[%@]",path);
            return NO;
        }
    }
    // NSDictionary
    else if ([file isKindOfClass:[NSDictionary class]]||[file isKindOfClass:[NSMutableDictionary class]]){
        NSDictionary *dictFile = (NSDictionary *)file;
        result = [dictFile writeToFile:path atomically:YES];
        if (!result) {
            ATLogFail(@"save dictionary fail, path:[%@]",path);
            return NO;
        }
    }
    // others
    else{
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:file];
        result = [data writeToFile:path atomically:YES];
        if (!result) {
            ATLogFail(@"save archived file fail, path:[%@]",path);
            return NO;
        }
    }
    
    if (completion) {
        completion();
    }
    return result;
}


- (BOOL)writeArchivedFile:(__kindof NSObject *)file
        extension:(NSString *)extension
       completion:(void (^)())completion{
    BOOL result = (BOOL)file;
    if (!result) {
        ATLogFail(@"nothing to save.");
        return NO;
    }
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *path = self.extension(extension);
    
    // create dir if not exist
    NSString *dir = path.stringByDeletingLastPathComponent;
    result = [fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    if (!result) {
        ATLogFail(@"can not create the directory at path %@",dir);
        return NO;
    }
    
    // create file if not exist
    result = [fm createFileAtPath:path contents:nil attributes:nil];
    if (!result) {
        ATLogFail(@"can not create the file at path %@",path);
        return NO;
    }
    
    // save contents to file
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:file];
    result = [data writeToFile:path atomically:YES];
    if (!result) {
        ATLogFail(@"save archived file fail, path:[%@]",path);
        return NO;
    }
    
    if (completion) {
        completion();
    }
    return result;
}

#pragma mark remove file

- (BOOL)removeFileWithExtension:(NSString *)extension
                                     completion:(void (^)())completion{
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL result = [fm removeItemAtPath:self.extension(extension) error:nil];
    if (!result) ATLogFail(@"remove fail.");
    if (completion) {
        completion();
    }
    return result;
}


@end



