//
//  UIView+ATGestureExtension.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-09.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "UIView+ATGestureExtension.h"
#import "NSString+ATExtension.h"
#import "UIView+ATAnimationWrapper.h"
#import "Foundation+ATEventTarget.h"

// create a new target
#define ATDefaultTarget ATTargetWith(self, gesture, handler)

@import ObjectiveC.runtime;

static const void *UIViewGestureATBlockWrapperKey = &UIViewGestureATBlockWrapperKey;

static inline void ATBindGestureAndTarget(UIGestureRecognizer *gesture, ATEventTarget *target){
    [gesture addTarget:target action:@selector(handleEvent:)];
}

static inline ATEventTarget *ATTargetWith(UIView *obj, __kindof UIGestureRecognizer *gesture, id handler){
    // create a target with <handler>
    ATEventTarget *target = [ATEventTarget targetWithHandler:handler];
    // add a <gesture> to target
    [obj addGestureRecognizer:gesture];
    // save target (gesture + handler) to dictionary
    NSMutableDictionary *gestures = objc_getAssociatedObject(obj, UIViewGestureATBlockWrapperKey);
    if (!gestures) {
        gestures = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(obj, UIViewGestureATBlockWrapperKey, gestures, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    NSMutableSet *handlers = gestures[NSStringFromPointer(gesture)];
    if (!handlers) {
        handlers = [NSMutableSet set];
        gestures[NSStringFromPointer(gesture)] = handlers;
    }
    [handlers addObject:target];
    return target;
}


@implementation UIView (ATGestureExtension)

- (void)_addGestures:(__kindof UIGestureRecognizer *(^)(ATEventTarget *target))sender handler:(void (^)(__kindof UIGestureRecognizer *sender))handler{
    // create a target with <handler>
    ATEventTarget *target = [ATEventTarget targetWithHandler:handler];
    // add a <gesture> to target
    UIGestureRecognizer *gesture = sender(target);
    
    // save target (gesture + handler) to dictionary
    NSMutableDictionary *gestures = objc_getAssociatedObject(self, UIViewGestureATBlockWrapperKey);
    if (!gestures) {
        gestures = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, UIViewGestureATBlockWrapperKey, gestures, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    NSMutableSet *handlers = gestures[NSStringFromPointer(gesture)];
    if (!handlers) {
        handlers = [NSMutableSet set];
        gestures[NSStringFromPointer(gesture)] = handlers;
    }
    [handlers addObject:target];
}

#pragma mark tap / long press

- (void)at_addTapGestureHandler:(void (^)(UITapGestureRecognizer *sender))handler{
    
    UITapGestureRecognizer *gesture = [UITapGestureRecognizer new];
    ATBindGestureAndTarget(gesture, ATDefaultTarget);
    
}

- (void)at_addTapGesture:(void (^)(UITapGestureRecognizer *sender))tap handler:(void (^)(UITapGestureRecognizer *sender))handler{
    
    UITapGestureRecognizer *gesture = [UITapGestureRecognizer new];
    ATBindGestureAndTarget(gesture, ATDefaultTarget);
    // more setting
    if (tap) {
        tap(gesture);
    }
    
}

- (void)at_addTapGesture:(void (^)(UITapGestureRecognizer *sender))tap handler:(void (^)(UITapGestureRecognizer *sender))handler animatedScale:(CGFloat)scale duration:(NSTimeInterval)duration{
    
    UITapGestureRecognizer *gesture = [UITapGestureRecognizer new];
    ATEventTarget *target = ATDefaultTarget;
    ATBindGestureAndTarget(gesture, target);
    [target setupAnimationWithView:self scale:scale duration:duration];
    // more setting
    if (tap) {
        tap(gesture);
    }
    
}


- (void)at_addDoubleTapGesture:(void (^)(UITapGestureRecognizer *sender))doubleTap duration:(NSTimeInterval)duration handler:(void (^)(UITapGestureRecognizer *sender))handler{

    UITapGestureRecognizer *gesture = [UITapGestureRecognizer new];
    ATBindGestureAndTarget(gesture, ATDefaultTarget);
    // more setting
    gesture.numberOfTapsRequired = 2;
    if (doubleTap) {
        doubleTap(gesture);
    }
    
}

- (void)at_addLongPressGesture:(void (^)(UILongPressGestureRecognizer *))longPress handler:(void (^)(UILongPressGestureRecognizer *))handler{
    
    UILongPressGestureRecognizer *gesture = [UILongPressGestureRecognizer new];
    ATBindGestureAndTarget(gesture, ATDefaultTarget);
    // more setting
    gesture.minimumPressDuration = 2;
    if (longPress) {
        longPress(gesture);
    }
    
}


#pragma mark swipe / pan / screen edge pan

- (void)at_addSwipeGesture:(void (^)(UISwipeGestureRecognizer *sender))swipe handler:(void (^)(UISwipeGestureRecognizer *sender))handler {
    
    UISwipeGestureRecognizer *gesture = [UISwipeGestureRecognizer new];
    ATBindGestureAndTarget(gesture, ATDefaultTarget);
    // more setting
    if (swipe) {
        swipe(gesture);
    }
    
}

- (void)at_addPanGesture:(void (^)(UIPanGestureRecognizer *sender))pan handler:(void (^)(UIPanGestureRecognizer *sender))handler {
    
    UIPanGestureRecognizer *gesture = [UIPanGestureRecognizer new];
    ATBindGestureAndTarget(gesture, ATDefaultTarget);
    // more setting
    if (pan) {
        pan(gesture);
    }
    
}

- (void)at_addScreenEdgePanGesture:(void (^)(UIScreenEdgePanGestureRecognizer *sender))screenEdgePan handler:(void (^)(UIScreenEdgePanGestureRecognizer *sender))handler {
    
    UIScreenEdgePanGestureRecognizer *gesture = [UIScreenEdgePanGestureRecognizer new];
    ATBindGestureAndTarget(gesture, ATDefaultTarget);
    // more setting
    if (screenEdgePan) {
        screenEdgePan(gesture);
    }
    
}

#pragma mark pinch / rotation

- (void)at_addPinchGesture:(void (^)(UIPinchGestureRecognizer *sender))pinch handler:(void (^)(UIPinchGestureRecognizer *sender))handler {
    
    UIPinchGestureRecognizer *gesture = [UIPinchGestureRecognizer new];
    ATBindGestureAndTarget(gesture, ATDefaultTarget);
    // more setting
    if (pinch) {
        pinch(gesture);
    }
    
}

- (void)at_addRotationGesture:(void (^)(UIRotationGestureRecognizer *sender))rotation handler:(void (^)(UIRotationGestureRecognizer *sender))handler {
    
    UIRotationGestureRecognizer *gesture = [UIRotationGestureRecognizer new];
    ATBindGestureAndTarget(gesture, ATDefaultTarget);
    // more setting
    if (rotation) {
        rotation(gesture);
    }
    
}


@end



