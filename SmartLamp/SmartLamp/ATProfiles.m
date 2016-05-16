//
//  ATProfiles.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-05-10.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "ATProfiles.h"

@implementation ATProfiles

+ (instancetype)defaultProfiles{
    
    return [[self alloc] initWithDefault];
    
}

- (instancetype)initWithDefault{
    
    if (self = [super init]) {
        
        _title = @"情景模式";
        _detail = @"没有描述信息";
        _image = [UIImage imageNamed:@"smartLamp"];
        _timer = 0;//0代表不定时关机
        _colorAnimation = ColorAnimationNone;
        _color = [UIColor whiteColor];
    }
    
    return self;
    
}


#pragma mark 📂 归档解档

// 归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.detail forKey:@"detail"];
    [aCoder encodeObject:self.image forKey:@"image"];
    
    [aCoder encodeInteger:self.timer forKey:@"timer"];
    [aCoder encodeInteger:self.colorAnimation forKey:@"colorAnimation"];
    [aCoder encodeObject:self.color forKey:@"color"];
    
}

// 解档
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder // NS_DESIGNATED_INITIALIZER
{
    if(self = [super init])
    {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.detail = [aDecoder decodeObjectForKey:@"detail"];
        self.image = [aDecoder decodeObjectForKey:@"image"];
        
        self.timer = [aDecoder decodeIntegerForKey:@"timer"];
        self.colorAnimation = [aDecoder decodeIntegerForKey:@"colorAnimation"];
        self.color = [aDecoder decodeObjectForKey:@"color"];
        
        
    }
    return self;
}





@end
