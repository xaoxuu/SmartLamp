//
//  ATProfiles.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-05-10.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "ATProfiles.h"

static NSUInteger countOfSceneImages = 8;

@implementation ATProfiles

+ (instancetype)defaultProfiles{
    
    return [[ATProfiles alloc] init];
    
}

- (instancetype)init{
    
    if (self = [super init]) {
        _title = @"情景模式";
        _detail = @"没有描述信息";
        self.randomSelectImage();
        _image = [UIImage imageNamed:@"image_launch"];
        _timer = 0;//0代表不定时关机
        _colorMode = ATColorModeNone;
        _color = [UIColor whiteColor];
        _brightness = 1.0f;
    }
    return self;
    
}


#pragma mark archive and unarchive

// archive
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.detail forKey:@"detail"];
    [aCoder encodeObject:self.image forKey:@"image"];
    [aCoder encodeObject:self.icon forKey:@"icon"];
    [aCoder encodeInteger:self.timer forKey:@"timer"];
    [aCoder encodeInteger:self.colorMode forKey:@"colorMode"];
    [aCoder encodeObject:self.color forKey:@"color"];
    [aCoder encodeFloat:self.brightness forKey:@"brightness"];
    
}

// unarchive
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init]){
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.detail = [aDecoder decodeObjectForKey:@"detail"];
        self.image = [aDecoder decodeObjectForKey:@"image"];
        self.icon = [aDecoder decodeObjectForKey:@"icon"];
        self.timer = [aDecoder decodeIntegerForKey:@"timer"];
        self.colorMode = [aDecoder decodeIntegerForKey:@"colorMode"];
        self.color = [aDecoder decodeObjectForKey:@"color"];
        self.brightness = [aDecoder decodeFloatForKey:@"brightness"];
        
    }
    return self;
}

- (instancetype(^)())randomSelectImage {
    // image
    UIImage *image;
    // do-while loop
    do {
        int index = arc4random()%countOfSceneImages;
        NSString *imageName = [@"scene" stringByAppendingFormat:@"%d",index];
        image = [UIImage imageNamed:imageName];
    } while ([image isEqual:self.icon]);
    self.icon = image;
    
    return ^(){
        return self;
    };
}


@end
