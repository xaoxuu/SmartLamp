//
//  NewsModel.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-05.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject


@property (nonatomic, copy) NSString *html;

@property (nonatomic, strong) NSArray *imageurls;

@property (nonatomic, copy) NSString *channelId;

@property (nonatomic, copy) NSString *link;

@property (nonatomic, copy) NSString *nid;

@property (nonatomic, copy) NSString *channelName;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *pubDate;

@property (nonatomic, assign) NSInteger sentiment_display;

@property (nonatomic, copy) NSString *source;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *content;




@end
