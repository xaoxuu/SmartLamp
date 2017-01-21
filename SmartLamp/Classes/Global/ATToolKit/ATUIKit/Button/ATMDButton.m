//
//  ATMDButton.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-20.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "ATMDButton.h"

@implementation ATMDButton


- (void)awakeFromNib{
    [self setupButtonStyle];
    [super awakeFromNib];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupButtonStyle];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupButtonStyle];
    }
    return self;
}


// setup btn style
- (void)setupButtonStyle{
    self.mdButtonType = MDButtonTypeFlat;
    self.backgroundColor = atColor.clear;
    self.rippleColor = atColor.theme.darkRatio(0.2);
    
}


@end
