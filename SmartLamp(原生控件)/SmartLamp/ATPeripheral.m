//
//  ATPeripheral.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-04-28.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "ATPeripheral.h"


@implementation ATPeripheral

#pragma mark 📂 归档

// 归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_uuid forKey:@"uuid"];
    [aCoder encodeObject:_name forKey:@"name"];
}

// 解档
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        _uuid = [aDecoder decodeObjectForKey:@"uuid"];
        _name = [aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}



@end
