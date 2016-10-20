//
//  ATRaisedView.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-26.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "ATRaisedView.h"

@implementation ATRaisedView

- (void)initRippleLayer {
    [super initRippleLayer];
    self.mdLayer.enableElevation = YES;
}

@end
