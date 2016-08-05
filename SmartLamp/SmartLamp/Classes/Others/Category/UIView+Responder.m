//
//  UIView+Responder.m
//  GoingFarm
//
//  Created by Aesir Titan on 2016-07-26.
//  Copyright © 2016年 computer. All rights reserved.
//

#import "UIView+Responder.h"

@implementation UIView (Responder)

// find super controller
- (UIViewController *)at_superController {
    UIResponder *responder = self;
    while ((responder = [responder nextResponder])){
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    }
    return nil;
}

@end
