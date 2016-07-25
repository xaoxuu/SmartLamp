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
// 设备名
@property (weak, nonatomic) IBOutlet UILabel *detail_DeviceName;
// 设备描述
@property (weak, nonatomic) IBOutlet UILabel *detail_Description;
// 情景模式名
@property (weak, nonatomic) IBOutlet UITextField *detail_SceneName;
// 亮度
@property (weak, nonatomic) IBOutlet UILabel *detail_Brightness;
// 颜色模式
@property (weak, nonatomic) IBOutlet UILabel *detail_ColorMode;
// 定时模式
@property (weak, nonatomic) IBOutlet UILabel *detail_TimerMode;


@end

@implementation StatusView

#pragma mark - 视图事件

- (void)awakeFromNib{
    [self layoutIfNeeded];
    // 设置通知
    [self _setupNotification];
    // 更新UI内容
    [self updateUI];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

#pragma mark - 控件事件

// 选择图片
- (IBAction)sceneImageTapped:(UIButton *)sender {
    // 图片
    UIImage *image;
    // 这里用do-while为了防止两次出现同样的内容, 优化体验
    do {
        int index = arc4random()%8;
        NSString *imageName = [@"scene" stringByAppendingFormat:@"%d",index];
        image = [UIImage imageNamed:imageName];
    } while ([image isEqual:self.detail_SceneImage.currentImage]);
    [self.detail_SceneImage setImage:image forState:UIControlStateNormal];
    atCentralManager.currentProfiles.image = self.detail_SceneImage.currentImage;
    
}
// 开始输入
- (IBAction)inputBegin:(UITextField *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        frame.origin.y -= 50;
        self.frame = frame;
        [self layoutIfNeeded];
    }];
}
// 编辑结束
- (IBAction)editEndOnExit:(UITextField *)sender {
    atCentralManager.currentProfiles.title = sender.text;
}
// 编辑结束
- (IBAction)inputDone:(UITextField *)sender {
    atCentralManager.currentProfiles.title = sender.text;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        frame.origin.y += 50;
        self.frame = frame;
        [self layoutIfNeeded];
    }];
}


#pragma mark - 私有方法
// 设置通知
- (void)_setupNotification{
    
    [atNotificationCenter addObserver:self selector:@selector(receiveStatusNotification:) name:NOTI_BLE_STATUS object:NOTI_BLE_STATUS_CHANGE];
    
}
// 灯状态通知
- (void)receiveStatusNotification:(NSNotification *)noti{
    if ([noti.name isEqualToString:NOTI_BLE_STATUS]) {
        if([noti.object isEqualToString:NOTI_BLE_STATUS_CHANGE]){
            [self updateUI];
        }
    }
}
// 应用情景模式
- (void)setAProfiles:(ATProfiles *)aProfiles{
    atCentralManager.currentProfiles = aProfiles;
    [self updateUI];
}

// 更新UI
- (void)updateUI{
    CBPeripheral *peripheral = atCentralManager.connectedPeripheral;
    ATProfiles *aProfiles = atCentralManager.currentProfiles;
    if (peripheral) {
        self.detail_DeviceName.text = peripheral.name;
        self.detail_Description.text = [NSString stringWithFormat:@"已连接至%@蓝牙灯",peripheral.name];
    }else{
        self.detail_DeviceName.text = @"未连接任何设备";
        self.detail_Description.text = @"请连接至少一台蓝牙灯设备";
    }
    
    
    self.detail_SceneName.text = aProfiles.title;
    [self.detail_SceneImage setImage:aProfiles.image forState:UIControlStateNormal];
    
    NSNumber *brightness = [NSNumber numberWithFloat:aProfiles.brightness];
    NSString *brightnessStr = [NSNumberFormatter localizedStringFromNumber:brightness numberStyle:NSNumberFormatterPercentStyle];
    self.detail_Brightness.text = [NSString stringWithFormat:@"当前亮度: %@",brightnessStr];
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
    if (aProfiles.timer) {
        self.detail_TimerMode.text = [NSString stringWithFormat:@"%ld分钟后关灯",aProfiles.timer];
    } else{
        self.detail_TimerMode.text = @"未开启定时关灯";
    }
    [self layoutIfNeeded];
    
}





@end
