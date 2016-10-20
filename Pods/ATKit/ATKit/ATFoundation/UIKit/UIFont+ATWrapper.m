//
//  UIFont+ATWrapper.m
//  ATKit
//
//  Created by Aesir Titan on 2016-09-12.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "UIFont+ATWrapper.h"


inline UIFont *FontWithSize(CGFloat size){
    return [UIFont systemFontOfSize:size];
}

inline UIFont *BoldFontWithSize(CGFloat size){
    return [UIFont boldSystemFontOfSize:size];
}

inline CGFloat HeightWithTextFontWidth(NSString *text,UIFont *font,CGFloat width){
    NSDictionary *dict = @{NSFontAttributeName:font};
    return [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil].size.height;
}


@implementation UIFont (ATWrapper)

@end
