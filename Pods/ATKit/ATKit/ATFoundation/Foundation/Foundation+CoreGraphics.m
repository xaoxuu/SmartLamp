//
//  Foundation+CoreGraphics.m
//  ATFoundation
//
//  Created by Aesir Titan on 2016-09-02.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "Foundation+CoreGraphics.h"


inline CGSize CGSizeUp(CGFloat upOffset){
    return CGSizeMake(0, -upOffset);
}

inline CGSize CGSizeDown(CGFloat downOffset){
    return CGSizeMake(0, downOffset);
}


inline CGRect CGRectWithTopMargin(CGFloat top){
    return CGRectMake(0, top, kScreenW, kScreenH-top);
}
inline CGRect CGRectWithTopAndBottomMargin(CGFloat top, CGFloat bottom){
    return CGRectMake(0, top, kScreenW, kScreenH-top-bottom);
}


inline ATUIntegerRange ATUIntegerRangeMake(NSUInteger minValue, NSUInteger maxValue){
    return (ATUIntegerRange){minValue,maxValue};
}

inline NSUInteger ATRandomUIntegerFrom(ATUIntegerRange length){
    return length.minValue + (NSUInteger)arc4random_uniform((int)length.maxValue-(int)length.minValue + 1);
}


inline CGRect CGRectWithViewInScreen(UIView *targetView){
    UIView *main = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    return [targetView.superview convertRect:targetView.frame toView:main];
}

inline ATFloatRange ATFloatRangeMake(CGFloat minValue, CGFloat maxValue){
    return (ATFloatRange){minValue,maxValue};
}

