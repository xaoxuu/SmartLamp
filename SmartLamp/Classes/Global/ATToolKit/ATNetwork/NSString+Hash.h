//
//  NSString+Hash.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-13.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Hash)

- (NSString *)md5String;
- (NSString *)sha1String;
- (NSString *)sha256String;
- (NSString *)sha512String;

- (NSString *)hmacSHA1StringWithKey:(NSString *)key;
- (NSString *)hmacSHA256StringWithKey:(NSString *)key;
- (NSString *)hmacSHA512StringWithKey:(NSString *)key;


@end
