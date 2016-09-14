//
//  NSString+Extension.m
//  ATFoundation
//
//  Created by Aesir Titan on 2016-08-30.
//  Copyright © 2016 Titan Studio. All rights reserved.
//


#import "NSString+ATExtension.h"


NSString *NSStringFromInt32(int x){
    return [NSString stringWithFormat:@"%d",x];
}

NSString *NSStringFromNSInteger(NSInteger x){
    return [NSString stringWithFormat:@"%ld",(long)x];
}

NSString *NSStringFromNSUInteger(NSUInteger x){
    return [NSString stringWithFormat:@"%ld",(unsigned long)x];
}

NSString *NSStringFromCGFloat(CGFloat x){
    return [NSString stringWithFormat:@"%lf",x];
}

NSString *NSStringFromPointer(id x){
    return [NSString stringWithFormat:@"%p",x];
}


NSString *NSStringFromRandom(ATRandomStringType type, ATUIntegerRange length){
    switch (type) {
        case ATRandomName: {
            return [NSString stringWithRandomNameWithLength:length];
            break;
        }
        case ATRandomPassword: {
            return [NSString stringWithRandomPasswordWithLength:length];
            break;
        }
        case ATRandomLowerString: {
            return [NSString stringWithRandomLowerStringWithLength:length];
            break;
        }
        case ATRandomUpperString: {
            return [NSString stringWithRandomUpperStringWithLength:length];
            break;
        }
        case ATRandomCapitalizeString: {
            return [NSString stringWithRandomCapitalizeStringWithLength:length];
            break;
        }
    }
}



@implementation NSString (ATRandomExtension)


+ (NSString *)stringWithRandomLowerStringWithLength:(ATUIntegerRange)length{
    NSUInteger randomLength = ATRandomUIntegerFrom(length);
    NSMutableString *str = [NSMutableString string];
    for (NSUInteger i=0; i<randomLength; i++) {
        [str appendFormat:@"%c",97 + arc4random_uniform(26)];
    }
    return str;
}

+ (NSString *)stringWithRandomUpperStringWithLength:(ATUIntegerRange)length{
    NSUInteger randomLength = ATRandomUIntegerFrom(length);
    NSMutableString *str = [NSMutableString string];
    for (NSUInteger i=0; i<randomLength; i++) {
        [str appendFormat:@"%c",65 + arc4random_uniform(26)];
    }
    return str;
}

+ (NSString *)stringWithRandomCapitalizeStringWithLength:(ATUIntegerRange)length{
    NSUInteger randomLength = ATRandomUIntegerFrom(length);
    NSMutableString *str = [NSMutableString string];
    [str appendFormat:@"%c",65 + arc4random_uniform(26)];
    for (NSUInteger i=0; i<randomLength-1; i++) {
        [str appendFormat:@"%c",97 + arc4random_uniform(26)];
    }
    return str;
}

+ (NSString *)stringWithRandomNameWithLength:(ATUIntegerRange)length{
    // first name
    NSUInteger randomLength = ATRandomUIntegerFrom(length);
    NSMutableString *str = [NSMutableString string];
    [str appendFormat:@"%c",65 + arc4random_uniform(26)];
    for (NSUInteger i=0; i<randomLength-1; i++) {
        [str appendFormat:@"%c",97 + arc4random_uniform(26)];
    }
    
    [str appendString:@" "];
    
    // last name
    randomLength = length.minValue + (NSUInteger)arc4random_uniform((int)length.maxValue-(int)length.minValue);
    [str appendFormat:@"%c",65 + arc4random_uniform(26)];
    for (NSUInteger i=0; i<randomLength-1; i++) {
        [str appendFormat:@"%c",97 + arc4random_uniform(26)];
    }
    return str;
}

+ (NSString *)stringWithRandomPasswordWithLength:(ATUIntegerRange)length{
    // first name
    NSUInteger randomLength = ATRandomUIntegerFrom(length);
    NSMutableString *str = [NSMutableString string];
    for (NSUInteger i=0; i<randomLength; i++) {
        [str appendFormat:@"%c",32 + arc4random_uniform(95)];
    }
    return str;
}

@end
