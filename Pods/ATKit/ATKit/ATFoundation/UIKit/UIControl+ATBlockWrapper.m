//
//  UIControl+ATBlockWrapper.m
//  ATFoundation
//
//  Created by Aesir Titan on 2016-09-01.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "UIControl+ATBlockWrapper.h"
#import "Foundation+ATEventTarget.h"

#define ATDefaultTargetFor(UIControlEvents) ATTargetWith(self, UIControlEvents ,handler)

@import ObjectiveC.runtime;

static const void *UIControlATBlockWrapperKey = &UIControlATBlockWrapperKey;

#pragma mark Category

static inline ATEventTarget *ATTargetWith(__kindof UIControl *obj, UIControlEvents controlEvents, id handler){
    
    // create a target with <handler>
    ATEventTarget *target = [ATEventTarget targetWithHandler:handler];
    // add a event to target
    [obj addTarget:target action:@selector(handleEvent:) forControlEvents:controlEvents];
    
    // save target (controlEvents + handler) to dictionary
    NSMutableDictionary *events = objc_getAssociatedObject(obj, UIControlATBlockWrapperKey);
    if (!events) {
        events = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(obj, UIControlATBlockWrapperKey, events, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    NSNumber *key = @(controlEvents);
    NSMutableSet *handlers = events[key];
    if (!handlers) {
        handlers = [NSMutableSet set];
        events[key] = handlers;
    }
    [handlers addObject:target];
    
    return target;
}

@implementation UIControl (ATBlockWrapper)

- (void)at_addEventHandler:(void (^)(__kindof UIControl *sender))handler forControlEvents:(UIControlEvents)controlEvents{
    // add a control events to target
    ATDefaultTargetFor(controlEvents);
}

- (void)at_removeEventHandlersForControlEvents:(UIControlEvents)controlEvents{
    // get events
    NSMutableDictionary *events = objc_getAssociatedObject(self, UIControlATBlockWrapperKey);
    if (!events) {
        events = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, UIControlATBlockWrapperKey, events, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    // get handlers from events
    NSNumber *key = @(controlEvents);
    NSSet *handlers = events[key];
    // remove handler
    if (handlers){
        [handlers enumerateObjectsUsingBlock:^(id target, BOOL *stop) {
            [self removeTarget:target action:NULL forControlEvents:controlEvents];
        }];
        [events removeObjectForKey:key];
    }
    
}

- (NSUInteger)at_hasEventHandlersForControlEvents:(UIControlEvents)controlEvents{
    // get events
    NSMutableDictionary *events = objc_getAssociatedObject(self, UIControlATBlockWrapperKey);
    if (!events) {
        events = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, UIControlATBlockWrapperKey, events, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    // get handlers from events
    NSNumber *key = @(controlEvents);
    NSSet *handlers = events[key];
    
    return handlers.count;
    
}

@end


#pragma mark - UIButton

@implementation UIButton (ATBlockWrapper)

- (void)at_addEventHandler:(void (^)(UIButton *sender))handler forControlEvents:(UIControlEvents)controlEvents {
    // add a control events to target
    ATDefaultTargetFor(controlEvents);
}

- (void)at_addTouchDownHandler:(void (^)(UIButton *sender))handler{
    // add a control events to target
    ATDefaultTargetFor(UIControlEventTouchDown);
}

- (void)at_addTouchUpInsideHandler:(void (^)(UIButton *sender))handler{
    // add a control events to target
    ATDefaultTargetFor(UIControlEventTouchUpInside);
}

- (void)at_addTouchUpInsideHandler:(void (^)(UIButton *sender))handler animatedScale:(CGFloat)scale duration:(NSTimeInterval)duration{
    // add a control events to target
    ATEventTarget *target = ATDefaultTargetFor(UIControlEventTouchUpInside);
    [target setupAnimationWithView:self scale:scale duration:duration];
}


@end

#pragma mark - UISlider

@implementation UISlider (ATBlockWrapper)

- (void)at_addEventHandler:(void (^)(UISlider *sender))handler forControlEvents:(UIControlEvents)controlEvents {
    // add a control events to target
    ATDefaultTargetFor(controlEvents);
}

- (void)at_addTouchDownHandler:(void (^)(UISlider *sender))handler{
    // add a control events to target
    ATDefaultTargetFor(UIControlEventTouchDown);
}

- (void)at_addTouchDownHandler:(void (^)(UISlider *sender))handler animatedScale:(CGFloat)scale duration:(NSTimeInterval)duration{
    // add a control events to target
    ATEventTarget *target = ATDefaultTargetFor(UIControlEventTouchDown);
    [target setupAnimationWithView:self scale:scale duration:duration];
}

- (void)at_addValueChangedHandler:(void (^)(UISlider *sender))handler{
    // add a control events to target
    ATDefaultTargetFor(UIControlEventValueChanged);
}

- (void)at_addTouchUpHandler:(void (^)(UISlider *sender))handler{
    // add a control events to target
    ATDefaultTargetFor(UIControlEventTouchUpInside);
    ATDefaultTargetFor(UIControlEventTouchUpOutside);
}

- (void)at_addTouchUpHandler:(void (^)(UISlider *sender))handler animatedScale:(CGFloat)scale duration:(NSTimeInterval)duration{
    // add a control events to target
    ATEventTarget *target = ATDefaultTargetFor(UIControlEventTouchUpInside);
    [target setupAnimationWithView:self scale:scale duration:duration];
    target = ATDefaultTargetFor(UIControlEventTouchUpOutside);
    [target setupAnimationWithView:self scale:scale duration:duration];
}

@end


#pragma mark - UISwitch

@implementation UISwitch (ATBlockWrapper)

- (void)at_addEventHandler:(void (^)(UISwitch *sender))handler forControlEvents:(UIControlEvents)controlEvents {
    // add a control events to target
    ATDefaultTargetFor(controlEvents);
}

- (void)at_addTouchDownHandler:(void (^)(UISwitch *sender))handler{
    // add a control events to target
    ATDefaultTargetFor(UIControlEventTouchDown);
}

- (void)at_addValueChangedHandler:(void (^)(UISwitch *sender))handler{
    // add a control events to target
    ATDefaultTargetFor(UIControlEventValueChanged);
}

- (void)at_addTouchUpInsideHandler:(void (^)(UISwitch *sender))handler{
    // add a control events to target
    ATDefaultTargetFor(UIControlEventTouchUpInside);
}

@end


#pragma mark - UISegmentedControl

@implementation UISegmentedControl (ATBlockWrapper)

- (void)at_addEventHandler:(void (^)(UISegmentedControl *sender))handler forControlEvents:(UIControlEvents)controlEvents {
    // add a control events to target
    ATDefaultTargetFor(controlEvents);
}

- (void)at_addValueChangedHandler:(void (^)(UISegmentedControl *sender))handler{
    // add a control events to target
    ATDefaultTargetFor(UIControlEventValueChanged);
}

@end


#pragma mark - UITextField

@implementation UITextField (ATBlockWrapper)

- (void)at_addEventHandler:(void (^)(UITextField *sender))handler forControlEvents:(UIControlEvents)controlEvents {
    // add a control events to target
    ATDefaultTargetFor(controlEvents);
}

- (void)at_addEditingBeginHandler:(void (^)(UITextField *sender))handler{
    // add a control events to target
    ATDefaultTargetFor(UIControlEventEditingDidBegin);
}

- (void)at_addEditingBeginHandler:(void (^)(UITextField *sender))handler animatedScale:(CGFloat)scale duration:(NSTimeInterval)duration{
    // add a control events to target
    ATEventTarget *target = ATDefaultTargetFor(UIControlEventEditingDidBegin);
    [target setupAnimationWithView:self scale:scale duration:duration];
}

- (void)at_addEditingChangedHandler:(void (^)(UITextField *sender))handler{
    // add a control events to target
    ATDefaultTargetFor(UIControlEventEditingChanged);
}

- (void)at_addEditingEndOnExitHandler:(void (^)(UITextField *sender))handler{
    // add a control events to target
    ATDefaultTargetFor(UIControlEventEditingDidEndOnExit);
}

- (void)at_addEditingEndHandler:(void (^)(UITextField *sender))handler{
    // add a control events to target
    ATDefaultTargetFor(UIControlEventEditingDidEnd);
}

- (void)at_addEditingEndHandler:(void (^)(UITextField *sender))handler animatedScale:(CGFloat)scale duration:(NSTimeInterval)duration{
    // add a control events to target
    ATEventTarget *target =  ATDefaultTargetFor(UIControlEventEditingDidEnd);
    [target setupAnimationWithView:self scale:scale duration:duration];
}

@end




