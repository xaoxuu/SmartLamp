//
//  DeviceTableViewCell.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-19.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "DeviceTableViewCell.h"

@interface DeviceTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *content;

@end

@implementation DeviceTableViewCell

#pragma mark - 视图事件

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    // 初始化UI
    [self _initUI];
    // 设置通知
    [self _setupNotification];
    
}

#pragma mark - 控件事件
// switch
- (IBAction)cellSwitchTouchUp:(UISwitch *)sender {
    if (sender.on) {
        [atCentralManager connectSmartLamp:self.model];
        [sender setOn:YES animated:YES];
    }else{
        [atCentralManager disConnectSmartLamp];
        [sender setOn:NO animated:YES];
    }
}


#pragma mark - 私有方法

#pragma mark 初始化
// 初始化UI
- (void)_initUI{
    
    self.cell_switch.onTintColor = atColor.themeColor;
    
}

// 设置通知
- (void)_setupNotification{
    
    [atNotificationCenter addObserver:self selector:@selector(receiveConnectNotification:) name:NOTI_BLE_CONNECT object:nil];
    
}

#pragma mark 通知

// 连接状态通知
- (void)receiveConnectNotification:(NSNotification *)noti{
    if ([noti.name isEqualToString:NOTI_BLE_CONNECT]) {
        // 连接成功
        if ([noti.object isEqualToString:NOTI_BLE_CONNECT_SUCCESS]) {
            [self.cell_switch setOn:YES animated:YES];
        }
        // 连接失败
        else if ([noti.object isEqualToString:NOTI_BLE_CONNECT_FAIL]){
            [self.cell_switch setOn:NO animated:YES];
        }
        // 断开连接
        else if([noti.object isEqualToString:NOTI_BLE_CONNECT_DISCONNECT]){
            [self.cell_switch setOn:NO animated:YES];
        }
    }
}


@end
