//
//  StatusView.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-19.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "StatusView.h"


@interface StatusView ()

// device name
@property (weak, nonatomic) IBOutlet UILabel *detail_DeviceName;
// description
@property (weak, nonatomic) IBOutlet UILabel *detail_Description;

// scene icon
@property (weak, nonatomic) IBOutlet UIButton *detail_SceneIcon;
// scene image
@property (weak, nonatomic) IBOutlet UIButton *detail_SceneImage;
// scene name
@property (weak, nonatomic) IBOutlet UITextField *detail_SceneName;
// brightness
@property (weak, nonatomic) IBOutlet UILabel *detail_Brightness;
// color
@property (weak, nonatomic) IBOutlet UILabel *detail_ColorMode;
// timer
@property (weak, nonatomic) IBOutlet UILabel *detail_TimerMode;

@end

@implementation StatusView

#pragma mark - view events

- (void)awakeFromNib{
    [self layoutIfNeeded];
    self.detail_SceneIcon.layer.cornerRadius = 0.5 * self.detail_SceneIcon.width;
    
    // subscribeRAC
    [self subscribeRAC];
    // handle button events
    [self handleButtonEvents];
    // handle textField events
    [self handleTextFieldEvents];
    // update UI
    [self updateUI];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

// handle button events
- (void)handleButtonEvents{
    // select image
    [self.detail_SceneIcon at_addTouchUpInsideHandler:^(UIButton * _Nonnull sender) {
        atCentral.aProfiles.randomSelectImage();
        [self.detail_SceneIcon setImage:atCentral.aProfiles.icon forState:UIControlStateNormal];
    }];
    
}

// handle textField events
- (void)handleTextFieldEvents{
    // start editing
    [self.detail_SceneName at_addEditingBeginHandler:^(UITextField * _Nonnull sender) {
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect frame = self.frame;
            frame.origin.y -= 50;
            self.frame = frame;
            [self layoutIfNeeded];
        } completion:nil];
    }];
    
    // editing end
    [self.detail_SceneName at_addEditingEndOnExitHandler:^(UITextField * _Nonnull sender) {
        atCentral.aProfiles.title = sender.text;
    }];
    [self.detail_SceneName at_addEditingEndHandler:^(UITextField * _Nonnull sender) {
        atCentral.aProfiles.title = sender.text;
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect frame = self.frame;
            frame.origin.y += 50;
            self.frame = frame;
            [self layoutIfNeeded];
        } completion:nil];
    }];
    
}

#pragma mark - private methods

// subscribeRAC
- (void)subscribeRAC{
    
    [atCentral.didSendData subscribeNext:^(id x) {
        [self updateUI];
    }];
    
}

// update UI
- (void)updateUI{
    // save cache
    CBPeripheral *peripheral = atCentral.aPeripheral;
    ATProfiles *aProfiles = atCentral.aProfiles;
    // update device label
    if (peripheral) {
        self.detail_DeviceName.text = peripheral.name;
        self.detail_Description.text = [NSString stringWithFormat:@"已连接至%@蓝牙灯",peripheral.name];
    }else{
        self.detail_DeviceName.text = @"未连接任何设备";
        self.detail_Description.text = @"请连接至少一台蓝牙灯设备";
    }
    // update scene name label
    self.detail_SceneName.text = aProfiles.title;
    // update scene image
    [self.detail_SceneIcon setImage:aProfiles.icon forState:UIControlStateNormal];
    // update scene brightness label
    NSNumber *brightness = [NSNumber numberWithFloat:aProfiles.brightness];
    NSString *brightnessStr = [NSNumberFormatter localizedStringFromNumber:brightness numberStyle:NSNumberFormatterPercentStyle];
    self.detail_Brightness.text = [NSString stringWithFormat:@"当前亮度: %@",brightnessStr];
    // update scene color mode label
    switch (aProfiles.colorMode) {
        case ATColorModeNone: {
            self.detail_ColorMode.text = @"单色模式";
            break;
        }
        case ATColorModeSaltusStep3: {
            self.detail_ColorMode.text = @"三色跳变";
            break;
        }
        case ATColorModeSaltusStep7: {
            self.detail_ColorMode.text = @"七色跳变";
            break;
        }
        case ATColorModeGratation: {
            self.detail_ColorMode.text = @"三色渐变";
            break;
        }
    }
    
    // update scene timer label
    if (aProfiles.timer) {
        self.detail_TimerMode.text = [NSString stringWithFormat:@"%ld分钟后关灯",aProfiles.timer];
    } else{
        self.detail_TimerMode.text = @"未开启定时关灯";
    }
    [self layoutIfNeeded];
    
}





@end
