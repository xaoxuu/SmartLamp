//
//  Foundation+ATLogExtension.m
//  Foundation
//
//  Created by Aesir Titan on 2016-08-13.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

// ==================== [ dictionary ] ==================== //
@implementation NSDictionary (ATLogExtension)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *str = [NSMutableString string];
    
    [str appendString:@"{\n"];
    
    // for-in all key-value
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [str appendFormat:@"\t%@ = %@,\n", key, obj];
    }];
    
    [str appendString:@"}"];
    
    // range of the last ','
    NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length) {
        // remove the last ','
        [str deleteCharactersInRange:range];
    }
    
    return str;
}
@end

// ==================== [ array ] ==================== //
@implementation NSArray (ATLogExtension)
- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *str = [NSMutableString string];
    
    [str appendString:@"[\n"];
    
    // for-in all objects
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [str appendFormat:@"%@,\n", obj];
    }];
    
    [str appendString:@"]"];
    
    // range of the last ','
    NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length) {
        // remove the last ','
        [str deleteCharactersInRange:range];
    }
    
    return str;
}
@end
