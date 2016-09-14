//
//  ATFlatView.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-26.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "ATFlatView.h"

@implementation ATFlatView

- (void)initRippleLayer {
    [super initRippleLayer];
    self.mdLayer.enableElevation = NO;
}

@end
