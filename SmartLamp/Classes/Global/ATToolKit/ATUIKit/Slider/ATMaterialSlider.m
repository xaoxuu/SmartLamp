//
//  ATMaterialSlider.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-10.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ATMaterialSlider.h"


@implementation ATMaterialSlider


- (void)awakeFromNib{
    [super awakeFromNib];
    // init
    self.minimumTrackTintColor = atColor.theme;
    [self setThumbImage:[UIImage imageNamed:@"icon_thumb"] forState:UIControlStateNormal];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.thumb.layer.cornerRadius = 0.5*self.thumb.frame.size.width;
        self.thumb.layer.borderColor = atColor.background.CGColor;
        self.thumb.layer.borderWidth = 2;
        self.thumb.layer.shadowOffset = CGSizeMake(0, 0);
        self.thumb.layer.shadowOpacity = 0.3;
        self.thumb.layer.shadowRadius = 1.0;
    });
}




@end
