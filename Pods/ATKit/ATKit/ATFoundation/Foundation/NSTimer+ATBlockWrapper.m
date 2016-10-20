//
//  NSTimer+ATBlockWrapper.m
//  ATFoundation
//
//  Created by Aesir Titan on 2016-09-02.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "NSTimer+ATBlockWrapper.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"

@implementation NSTimer (ATBlockWrapper)


+ (instancetype)at_scheduleTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats usingBlock:(void (^)(NSTimer *timer))block{
    NSTimer *timer = [self at_timerWithTimeInterval:interval repeats:repeats usingBlock:block];
    [NSRunLoop.currentRunLoop addTimer:timer forMode:NSRunLoopCommonModes];
    return timer;
}

+ (instancetype)at_timerWithTimeInterval:(NSTimeInterval)inSeconds repeats:(BOOL)repeats usingBlock:(void (^)(NSTimer *timer))block{
    NSParameterAssert(block != nil);
    CFAbsoluteTime seconds = fmax(inSeconds, 0.0001);
    CFAbsoluteTime interval = repeats ? seconds : 0;
    CFAbsoluteTime fireDate = CFAbsoluteTimeGetCurrent() + seconds;
    return (__bridge_transfer NSTimer *)CFRunLoopTimerCreateWithHandler(NULL, fireDate, interval, 0, 0, (void(^)(CFRunLoopTimerRef))block);
}

- (BOOL)at_isRunning{
    return self.timeInterval > self.fireDate.timeIntervalSinceNow;
}

- (BOOL)at_pause{
    if ([self isValid]) {
        [self setFireDate:[NSDate distantFuture]];
        return YES;
    } else{
        return NO;
    }
}
- (BOOL)at_resume{
    if ([self isValid]) {
        [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.timeInterval]];
        return YES;
    } else{
        return NO;
    }
}

- (BOOL)at_turnover{
    if (self.at_isRunning) {
        [self at_pause];
    } else{
        [self at_resume];
    }
    return self.at_isRunning;
}


@end

#pragma clang diagnostic pop