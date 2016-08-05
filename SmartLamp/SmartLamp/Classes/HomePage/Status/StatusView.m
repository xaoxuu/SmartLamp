//
//  StatusView.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-19.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "StatusView.h"
#import "HomeViewController.h"

@interface StatusView ()

// device name
@property (weak, nonatomic) IBOutlet UILabel *detail_DeviceName;
// description
@property (weak, nonatomic) IBOutlet UILabel *detail_Description;

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
    [[self.detail_SceneImage rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        // image
        UIImage *image;
        // do-while loop
        do {
            int index = arc4random()%8;
            NSString *imageName = [@"scene" stringByAppendingFormat:@"%d",index];
            image = [UIImage imageNamed:imageName];
        } while ([image isEqual:self.detail_SceneImage.currentImage]);
        [self.detail_SceneImage setImage:image forState:UIControlStateNormal];
        atCentralManager.currentProfiles.image = self.detail_SceneImage.currentImage;
    }];
    
}

// handle textField events
- (void)handleTextFieldEvents{
    // start editing
    [[self.detail_SceneName rac_signalForControlEvents:UIControlEventEditingDidBegin] subscribeNext:^(UITextField *sender) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.frame;
            frame.origin.y -= 50;
            self.frame = frame;
            [self layoutIfNeeded];
        }];
    }];
    // editing end
    [[self.detail_SceneName rac_signalForControlEvents:UIControlEventEditingDidEnd] subscribeNext:^(UITextField *sender) {
        atCentralManager.currentProfiles.title = sender.text;
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.frame;
            frame.origin.y += 50;
            self.frame = frame;
            [self layoutIfNeeded];
        }];
    }];
    // editing end
    [[self.detail_SceneName rac_signalForControlEvents:UIControlEventEditingDidEndOnExit] subscribeNext:^(UITextField *sender) {
        atCentralManager.currentProfiles.title = sender.text;
    }];
}

#pragma mark - private methods

// subscribeRAC
- (void)subscribeRAC{
    
    [atCentralManager.didSendData subscribeNext:^(id x) {
        [self updateUI];
    }];
    
}

// apply scene mode
- (void)setAProfiles:(ATProfiles *)aProfiles{
    atCentralManager.currentProfiles = aProfiles;
    [self updateUI];
}

// update UI
- (void)updateUI{
    // save cache
    CBPeripheral *peripheral = atCentralManager.connectedPeripheral;
    ATProfiles *aProfiles = atCentralManager.currentProfiles;
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
    [self.detail_SceneImage setImage:aProfiles.image forState:UIControlStateNormal];
    // update scene brightness label
    NSNumber *brightness = [NSNumber numberWithFloat:aProfiles.brightness];
    NSString *brightnessStr = [NSNumberFormatter localizedStringFromNumber:brightness numberStyle:NSNumberFormatterPercentStyle];
    self.detail_Brightness.text = [NSString stringWithFormat:@"当前亮度: %@",brightnessStr];
    // update scene color mode label
    switch (aProfiles.colorAnimation) {
        case ColorAnimationNone: {
            self.detail_ColorMode.text = @"单色模式";
            break;
        }
        case ColorAnimationSaltusStep3: {
            self.detail_ColorMode.text = @"三色跳变";
            break;
        }
        case ColorAnimationSaltusStep7: {
            self.detail_ColorMode.text = @"七色跳变";
            break;
        }
        case ColorAnimationGratation: {
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
