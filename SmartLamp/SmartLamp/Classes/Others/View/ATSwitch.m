//
//  ATSwitch.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-02.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ATSwitch.h"

@implementation ATSwitch

- (void)awakeFromNib{
    [super awakeFromNib];
    self.transform = CGAffineTransformMakeScale(0.7, 0.7);
    self.tintColor = atColor.themeColor_light;
    self.onTintColor = atColor.themeColor_light;
}


- (void)at_whiteColorStyle {
    self.thumbTintColor = atColor.backgroundColor;
}

- (void)at_themeColorStyle {
    self.thumbTintColor = atColor.themeColor;
}



@end
