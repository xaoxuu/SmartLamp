//
//  NetworkManager.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-28.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NetworkManager;
extern NetworkManager *atNetwork;
@interface NetworkManager : NSObject


// url
@property (copy, nonatomic) NSString *url;

typedef NS_ENUM(NSUInteger, ListType){
    ListTypeHot,
    ListTypeNew,
};

// per
@property (assign, nonatomic) NSUInteger per;


typedef NS_ENUM(NSUInteger, ContentType){
    ContentTypeAll,
    ContentTypeImage,
    ContentTypeText,
    ContentTypeAudio,
    ContentTypeVideo
};
// type
@property (assign, nonatomic) ContentType contentType;

- (NSMutableDictionary *)parameter;

+ (instancetype)sharedManager;
- (NSMutableDictionary *)parameterWithContentType:(ContentType)contentType maxtime:(NSString *)maxtime page:(NSUInteger)page;

@end
