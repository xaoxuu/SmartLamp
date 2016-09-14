//
//  ATHeaderView.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-02.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ATHeaderView.h"
#import "ATMDButton.h"

@interface ATHeaderView ()

// app title
@property (weak, nonatomic) IBOutlet UILabel *appTitle;
// over view
@property (weak, nonatomic) IBOutlet UIView *overView;
// connect button
@property (weak, nonatomic) IBOutlet ATMDButton *connectButton;
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
    
    self.backgroundColor = atColor.theme;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 2;
    self.layer.shadowOpacity = 0.7;
    
}

// handle control events
- (void)handleControlEvents{
    // connect button
    [self.connectButton at_addTouchUpInsideHandler:^(UIButton * _Nonnull sender) {
        // connect or disconnect
        atCentral.connectOrDisconnect();
    }];   
    
}

// subscribeRAC
- (void)subscribeRAC{
    // connect success
    [atCentral.didConnect subscribeNext:^(id x) {
        if ([x boolValue]) {
            self.deviceStatusImage.image = [UIImage imageNamed:@"home_power"];
            self.deviceName.text = atCentral.aPeripheral.name;
            self.deviceStatus.text = [NSString stringWithFormat:@"已连接至:%@",atCentral.aPeripheral.name];
        } else{
            self.deviceStatusImage.image = [UIImage imageNamed:@"home_disconnect"];
            self.deviceName.text = @"未连接设备";
            self.deviceStatus.text = [NSString stringWithFormat:@"已断开连接"];
        }
        
    }];
    
    // notification
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"deviceStatus" object:nil] subscribeNext:^(id x) {
        if ([x isKindOfClass:[NSString class]]) {
            self.deviceStatus.text = [NSString stringWithFormat:@"%@",x];
        }
    }];
}


@end
