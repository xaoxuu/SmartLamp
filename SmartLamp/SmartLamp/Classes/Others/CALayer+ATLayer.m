//
//  CALayer+ATLayer.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-05.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "CALayer+ATLayer.h"

@implementation CALayer (ATLayer)

#pragma mark - shadow

- (CALayer *(^)(UIColor *))at_shadowColor{
    return ^(UIColor *color){
        self.shadowColor = color.CGColor;
        return self;
    };
}

- (CALayer *(^)(CGSize))at_shadowOffset{
    return ^(CGSize size){
        self.shadowOffset = size;
        return self;
    };
}

- (CALayer *(^)(CGFloat))at_shadowRadius{
    return ^(CGFloat radius){
        self.shadowRadius = radius;
        return self;
    };
}

- (CALayer *(^)(float))at_shadowOpacity{
    return ^(float opacity){
        self.shadowOpacity = opacity;
        return self;
    };
}

#pragma mark - border

- (CALayer *(^)(UIColor *))at_borderColor{
    return ^(UIColor *color){
        self.borderColor = color.CGColor;
        return self;
    };
}

- (CALayer *(^)(CGFloat))at_borderWidth{
    return ^(CGFloat width){
        self.borderWidth = width;
        return self;
    };
}

#pragma mark - corner

- (CALayer *(^)(CGFloat))at_cornerRadius{
    return ^(CGFloat radius){
        self.cornerRadius = radius;
        return self;
    };
}


@end
