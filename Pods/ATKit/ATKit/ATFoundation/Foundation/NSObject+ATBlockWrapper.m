//
//  NSObject+ATBlockWrapper.h
//  ATFoundation
//
//  Created by Aesir Titan on 2016-09-02.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "NSObject+ATBlockWrapper.h"
#import "Foundation+ATMacros.h"


NS_INLINE dispatch_time_t ATTimeDelay(NSTimeInterval t) {
    return dispatch_time(DISPATCH_TIME_NOW, (uint64_t)(NSEC_PER_SEC * t));
}

NS_INLINE BOOL ATSupportsDispatchCancellation(void) {
#if DISPATCH_CANCELLATION_SUPPORTED
    return (&dispatch_block_cancel != NULL);
#else
    return NO;
#endif
}

static ATOperationToken ATDispatchCancellableBlock(dispatch_queue_t queue, NSTimeInterval delay, void(^block)(void)) {
    dispatch_time_t time = ATTimeDelay(delay);
    
#if DISPATCH_CANCELLATION_SUPPORTED
    if (ATSupportsDispatchCancellation()) {
        dispatch_block_t ret = dispatch_block_create(0, block);
        dispatch_after(time, queue, ret);
        return ret;
    }
#endif
    
    __block BOOL cancelled = NO;
    void (^wrapper)(BOOL) = ^(BOOL cancel) {
        if (cancel) {
            cancelled = YES;
            return;
        }
        if (!cancelled) block();
    };
    
    dispatch_after(time, queue, ^{
        wrapper(NO);
    });
    
    return wrapper;
}

@implementation NSObject (ATBlockWrapper)


- (ATOperationToken)at_delay:(NSTimeInterval)delay performInMainQueue:(void (^)(id obj))action {
    return [self at_delay:delay queue:dispatch_get_main_queue() perform:action];
}

+ (ATOperationToken)at_delay:(NSTimeInterval)delay performInMainQueue:(void (^)(void))action {
	return [self at_delay:delay queue:dispatch_get_main_queue() perform:action];
}

- (ATOperationToken)at_delay:(NSTimeInterval)delay performInBackground:(void (^)(id obj))action {
    return [self at_delay:delay queue:dispatch_get_global_queue(0, 0) perform:action];
}

+ (ATOperationToken)at_delay:(NSTimeInterval)delay performInBackground:(void (^)(void))action {
	return [self at_delay:delay queue:dispatch_get_global_queue(0, 0) perform:action];
}

- (ATOperationToken)at_delay:(NSTimeInterval)delay queue:(dispatch_queue_t)queue perform:(void (^)(id obj))action {
    NSParameterAssert(action != nil);
    return ATDispatchCancellableBlock(queue, delay, ^{
        action(self);
    });
}

+ (ATOperationToken)at_delay:(NSTimeInterval)delay queue:(dispatch_queue_t)queue perform:(void (^)(void))action {
    NSParameterAssert(action != nil);
    return ATDispatchCancellableBlock(queue, delay, action);
}

+ (void)at_cancelOperation:(ATOperationToken)token {
    NSParameterAssert(token != nil);
    
#if DISPATCH_CANCELLATION_SUPPORTED
    if (ATSupportsDispatchCancellation()) {
        dispatch_block_cancel((dispatch_block_t)token);
        return;
    }
#endif

    void (^wrapper)(BOOL) = (void(^)(BOOL))token;
    wrapper(YES);
}

@end
