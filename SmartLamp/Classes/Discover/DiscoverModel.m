//
//  DiscoverModel.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-28.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "DiscoverModel.h"

@implementation DiscoverModel


+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [List class]};
}
@end
@implementation Info

@end


@implementation List

+ (NSDictionary *)objectClassInArray{
    return @{@"themes" : [Themes class]};
}

@end


@implementation Themes

@end


