//
//  ATEventTarget.m
//  ATFoundation
//
//  Created by Aesir Titan on 2016-09-01.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "Foundation+ATEventTarget.h"
#import "UIView+ATAnimationWrapper.h"

@implementation ATEventTarget


+ (instancetype)targetWithHandler:(void (^)(id sender))handler {
    return [[self alloc] initWithHandler:handler];
}

- (instancetype)initWithHandler:(void (^)(id sender))handler {
    if (self = [super init]) {
        self.handler = handler;
    }
    return self;
}

- (void)handleEvent:(id)sender{
    if (self.handler) {
        self.handler(sender);
    }
    if (self.view) {
        [self.view at_animatedScale:self.scale duration:self.duration completion:nil];
    }
}

- (void)setupAnimationWithView:(UIView *)view scale:(CGFloat)scale duration:(NSTimeInterval)duration {
    self.view = view;
    self.scale = scale;
    self.duration = duration;
}


@end
