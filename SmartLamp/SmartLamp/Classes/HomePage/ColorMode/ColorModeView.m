//
//  ColorModeView.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-19.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ColorModeView.h"
#import "UIImageView+GetColorAtPixel.h"
#import "ATRadioButton.h"
#import "CALayer+ATLayer.h"

@interface ColorModeView ()

// palette
@property (weak, nonatomic) IBOutlet UIImageView *palette;
// palette view
@property (weak, nonatomic) IBOutlet UIView *paletteView;
// circle
@property (strong, nonatomic) UIImageView *circle;
// color animation view
@property (weak, nonatomic) IBOutlet UIView *colorAnimationBtnView;
// gesture signal
@property (strong, nonatomic) RACSignal *gesture;

@end

@implementation ColorModeView

#pragma mark - view events

- (void)awakeFromNib{
    [self layoutIfNeeded];
    
    // init UI
    [self _initUI];
    // subscribeRAC
    [self subscribeRAC];
    // setup gesture
    [self setupGestureRecognizer];
    
}

// animation button events
- (IBAction)animationBtn:(UIButton *)sender {
    atCentralManager.currentProfiles.colorAnimation = sender.tag;
    [atCentralManager letSmartLampPerformColorAnimation];
}

#pragma mark - private methods

// init UI
- (void)_initUI{
    self.palette.layer.at_shadowOpacity(0.5).at_shadowOffset(CGSizeZero).at_shadowRadius(2);
}

// subscribeRAC
- (void)subscribeRAC{
    
    // turn on
    [atCentralManager.didPerformColorAnimation subscribeNext:^(id x) {
        if (![x boolValue]) {
            [self deSelectAllButton];
        }
    }];
    
}

// setup gesture
- (void)setupGestureRecognizer{
    // tap
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [self.paletteView addGestureRecognizer:tap];
    // pan
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] init];
    [self.paletteView addGestureRecognizer:pan];
    
    // merge tap and pan gesture
    self.gesture = [tap.rac_gestureSignal merge:pan.rac_gestureSignal];
    [self.gesture subscribeNext:^(UIGestureRecognizer *sender) {
        // touch point
        CGPoint point = [sender locationInView:self.palette];
        // color from touch point
        [self.palette at_getColorFromCircleWithPoint:point completion:^(UIColor *color) {
            // update color
            atCentralManager.currentProfiles.color = color;
            [atCentralManager letSmartLampUpdateColor];
            atCentralManager.currentProfiles.colorAnimation = ColorAnimationNone;
            // update UI
            [self updateCircleWithPoint:point];
            [self deSelectAllButton];
        }];
    }];
    
}

// deselect all button
- (void)deSelectAllButton{
    for (ATRadioButton *btn in self.colorAnimationBtnView.subviews) {
        [btn deSelectAllButton];
    }
}

// update circle point
- (void)updateCircleWithPoint:(CGPoint)point{
    CGSize size = self.circle.frame.size;
    point.x -= size.width * 0.5;
    point.y -= size.height * 0.5;
    self.circle.frame = (CGRect){point,size};
    [self layoutIfNeeded];
}


#pragma mark lazy load

// circle
-(UIImageView *)circle{
    if (!_circle) {
        self.circle = [[UIImageView alloc] initWithFrame:(CGRect){0,0,20,20}];
        self.circle.image = [UIImage imageNamed:@"Icon_Circle"];
        [self.circle setUserInteractionEnabled:NO];
        [self.palette addSubview:_circle];
    }
    return _circle;
}

@end
