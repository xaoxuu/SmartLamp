//
//  DiscoverModel.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-28.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Info,List,Themes;
@interface DiscoverModel : NSObject


@property (nonatomic, strong) Info *info;

@property (nonatomic, strong) NSArray<List *> *list;


@end
@interface Info : NSObject

@property (nonatomic, copy) NSString *maxid;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, copy) NSString *maxtime;

@property (nonatomic, assign) NSInteger page;

@end

@interface List : NSObject

@property (nonatomic, copy) NSString *created_at;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *is_gif;

@property (nonatomic, copy) NSString *image2;

@property (nonatomic, copy) NSString *voicetime;

@property (nonatomic, copy) NSString *voicelength;

@property (nonatomic, copy) NSString *forward;

@property (nonatomic, copy) NSString *playfcount;

@property (nonatomic, copy) NSString *repost;

@property (nonatomic, copy) NSString *image1;

@property (nonatomic, strong) NSArray *top_cmt;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) NSInteger theme_type;

@property (nonatomic, copy) NSString *hate;

@property (nonatomic, copy) NSString *image0;

@property (nonatomic, copy) NSString *comment;

@property (nonatomic, copy) NSString *passtime;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *tag;

@property (nonatomic, copy) NSString *playcount;

@property (nonatomic, copy) NSString *cdn_img;

@property (nonatomic, copy) NSString *theme_name;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, copy) NSString *favourite;

@property (nonatomic, copy) NSString *from;

@property (nonatomic, strong) NSArray<Themes *> *themes;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *height;

@property (nonatomic, copy) NSString *jie_v;

@property (nonatomic, copy) NSString *videotime;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *bookmark;

@property (nonatomic, copy) NSString *cai;

@property (nonatomic, copy) NSString *screen_name;

@property (nonatomic, copy) NSString *profile_image;

@property (nonatomic, copy) NSString *love;

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *mid;

@property (nonatomic, assign) NSInteger theme_id;

@property (nonatomic, copy) NSString *original_pid;

@property (nonatomic, copy) NSString *sina_v;

@property (nonatomic, copy) NSString *image_small;

@property (nonatomic, copy) NSString *weixin_url;

@property (nonatomic, copy) NSString *voiceuri;

@property (nonatomic, copy) NSString *videouri;

@property (nonatomic, copy) NSString *width;

@end

@interface Themes : NSObject

@property (nonatomic, copy) NSString *theme_id;

@property (nonatomic, copy) NSString *theme_type;

@property (nonatomic, copy) NSString *theme_name;

@end

