//
//  NSObject+ATBlockWrapper.h
//  ATFoundation
//
//  Created by Aesir Titan on 2016-09-02.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef __nonnull id <NSObject, NSCopying> ATOperationToken;

@interface NSObject (ATBlockWrapper)


- (ATOperationToken)at_delay:(NSTimeInterval)delay performInMainQueue:(void (^)(id obj))action;


+ (ATOperationToken)at_delay:(NSTimeInterval)delay performInMainQueue:(void (^)(void))action;



- (ATOperationToken)at_delay:(NSTimeInterval)delay performInBackground:(void (^)(id obj))action;


+ (ATOperationToken)at_delay:(NSTimeInterval)delay performInBackground:(void (^)(void))action;


- (ATOperationToken)at_delay:(NSTimeInterval)delay queue:(dispatch_queue_t)queue perform:(void (^)(id obj))action;


+ (ATOperationToken)at_delay:(NSTimeInterval)delay queue:(dispatch_queue_t)queue perform:(void (^)(void))action;


+ (void)at_cancelOperation:(ATOperationToken)token;

@end

NS_ASSUME_NONNULL_END
