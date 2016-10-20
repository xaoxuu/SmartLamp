//
//  NetworkManager.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-28.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "NetworkManager.h"
NetworkManager *atNetwork;
@interface NetworkManager ()


// data
@property (copy, nonatomic) NSString *a;

// data
@property (copy, nonatomic) NSString *c;

// type
@property (copy, nonatomic) NSString *type;

// param
@property (strong, nonatomic) NSMutableDictionary<NSString *,NSString *> *param;

@end

@implementation NetworkManager

+(void)load{
    atNetwork = [NetworkManager sharedManager];
}
+ (instancetype)sharedManager{
    if (!atNetwork) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            atNetwork = [[NetworkManager alloc] init];
        });
    }
    return atNetwork;
}

- (instancetype)init{
    if (!atNetwork) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            atNetwork = [super init];
        });
    }
    
    _url = @"http://api.budejie.com/api/api_open.php";
    _a = @"list";
    _c = @"data";
    
    _per = 10;
    _type = @"1";
    
    return self;
}



- (void)setContentType:(ContentType)contentType{
    _contentType = contentType;
    switch (contentType) {
        case ContentTypeAll: {
            _type = @"1";
            break;
        }
        case ContentTypeImage: {
            _type = @"10";
            break;
        }
        case ContentTypeText: {
            _type = @"29";
            break;
        }
        case ContentTypeAudio: {
            _type = @"31";
            break;
        }
        case ContentTypeVideo: {
            _type = @"41";
            break;
        }
    }
}

- (NSMutableDictionary *)parameter {
    if (!self.param) {
        self.param = [NSMutableDictionary dictionary];
    }
    self.param[@"a"] = self.a;
    self.param[@"c"] = self.c;
    
    return self.param;
}


- (NSMutableDictionary *)parameterWithContentType:(ContentType)contentType maxtime:(NSString *)maxtime page:(NSUInteger)page{
    self.contentType = contentType;
    if (!self.param) {
        self.param = [NSMutableDictionary dictionary];
    }
    
    self.param[@"a"] = self.a;
    self.param[@"c"] = self.c;
    self.param[@"type"] = self.type;
    if (maxtime) {
        self.param[@"maxtime"] = maxtime;
    } else{
        [self.param removeObjectForKey:@"maxtime"];
    }
    
    self.param[@"page"] = NSStringFromNSUInteger(page);
    self.param[@"per"] = NSStringFromNSUInteger(self.per);
    
    
    return self.param;
}


@end
