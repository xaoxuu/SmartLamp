//
//  NewsModel.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-05.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

-(NSString *)description{
    
    NSMutableString *string = [@"" mutableCopy];
    [string appendFormat:@"title:%@\n",_title];
    [string appendFormat:@"nid  :%@\n",_nid];
    [string appendFormat:@"desc :%@\n",_desc];
    [string appendFormat:@"sentiment_display:%ld\n",_sentiment_display];
    [string appendFormat:@"contect:%@\n",_content];
    
    return string;
    
}

@end
