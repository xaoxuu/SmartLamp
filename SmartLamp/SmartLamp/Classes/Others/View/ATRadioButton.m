//
//  ATRadioButton.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-02.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ATRadioButton.h"

@implementation ATRadioButton

#pragma mark - public methods
// deselect all button
- (void)deSelectAllButton{
    // asynchrone queue
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (UIView *view in self.superview.subviews) {
            if ([view isKindOfClass:[ATRadioButton class]]) {
                ATRadioButton * btn = (ATRadioButton *)view;
                if (btn.selected) {
                    // main thread main queue update UI
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [btn setSelected:NO];
                    });
                }
            }
        }
    });

}
// deselect all button but ignore self
- (void)deSelectAllButtonIgnoreSelf{
    // asynchrone queue
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (UIView *view in self.superview.subviews) {
            if ([view isKindOfClass:[ATRadioButton class]]) {
                ATRadioButton * btn = (ATRadioButton *)view;
                if (![btn isEqual:self] && btn.selected) {
                    // main thread main queue update UI
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [btn setSelected:NO];
                    });
                }
            }
        }
    });

}


// touch began
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!self.selected) {
        [super touchesBegan:touches withEvent:event];
        [self deSelectAllButtonIgnoreSelf];
    }
}

// touch ended
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!self.selected) {
        [super touchesEnded:touches withEvent:event];
        [self setSelected:YES];
    }
}


@end
