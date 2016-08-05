//
//  ATHeaderView.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-02.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ATHeaderView.h"
#import "ATSwitch.h"

@interface ATHeaderView ()

// app title
@property (weak, nonatomic) IBOutlet UILabel *appTitle;
// over view
@property (weak, nonatomic) IBOutlet UIView *overView;
// connect button
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
// switch
@property (weak, nonatomic) IBOutlet ATSwitch *switchButton;

// status image
@property (weak, nonatomic) IBOutlet UIImageView *deviceStatusImage;
// device name
@property (weak, nonatomic) IBOutlet UILabel *deviceName;
// status detail
@property (weak, nonatomic) IBOutlet UILabel *deviceStatus;

@end

@implementation ATHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self _initUI];
    // subscribeRAC
    [self subscribeRAC];
    // handle events
    [self handleControlEvents];
    
}

// init UI
- (void)_initUI{
    self.appTitle.tintColor = atColor.themeColor_dark;
    self.backgroundColor = atColor.themeColor;
    self.tintColor = atColor.themeColor_dark;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 2;
    self.layer.shadowOpacity = 0.7;
    [self.switchButton at_whiteColorStyle];
}

// handle control events
- (void)handleControlEvents{
    // connect button
    [[self.connectButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        // connect or disconnect
        [atCentralManager connectOrDisconnect];
    }];
    // switch
    [[self.switchButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UISwitch *sender) {
        // turn on or turn off
        [self.switchButton setOn:!sender.on animated:YES];
        [atCentralManager letSmartLampTurnOnIf:!sender.on];
    }];
    
}

// subscribeRAC
- (void)subscribeRAC{
    // connect success
    [atCentralManager.didConnectSuccess subscribeNext:^(id x) {
        self.deviceStatusImage.image = [UIImage imageNamed:@"home_power"];
        self.deviceName.text = atCentralManager.connectedPeripheral.name;
        self.deviceStatus.text = [NSString stringWithFormat:@"已连接至:%@",atCentralManager.connectedPeripheral.name];
    }];
    // disconnect
    [atCentralManager.didDisconnect subscribeNext:^(id x) {
        self.deviceStatusImage.image = [UIImage imageNamed:@"home_disconnect"];
        self.deviceName.text = @"未连接设备";
        self.deviceStatus.text = [NSString stringWithFormat:@"已断开连接"];
    }];

    // turn on
    [atCentralManager.didTurnOn subscribeNext:^(id x) {
        [self.switchButton setOn:YES animated:YES];
    }];
    // turn off
    [atCentralManager.didTurnOff subscribeNext:^(id x) {
        [self.switchButton setOn:NO animated:YES];
    }];
}


@end
