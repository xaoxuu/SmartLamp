//
//  SmartLampConst.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-09-11.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "SmartLampConst.h"


inline CGFloat HeightWithTextFontMaxWidth(NSString *text,UIFont *font,CGFloat maxWidth){
    NSDictionary *dict = @{NSFontAttributeName:font};
    
    return [text boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil].size.height;
}



@implementation SmartLampConst

@end
