//
//  DeviceTableViewCell.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-19.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "DeviceTableViewCell.h"

@interface DeviceTableViewCell ()

// content view
@property (weak, nonatomic) IBOutlet UIView *content;

@end

@implementation DeviceTableViewCell

#pragma mark - view events

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
    // init UI
    [self _initUI];
    // subscribeRAC
    [self subscribeRAC];
    // handle switch events
    [self handleSwitchEvents];
    
}

// handle switch events
- (void)handleSwitchEvents{
    [[self.cell_switch rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UISwitch *sender) {
        // do something
        if (sender.on) {
            [atCentralManager connectSmartLamp:self.model];
            [sender setOn:YES animated:YES];
        }else{
            [atCentralManager disConnectSmartLamp];
            [sender setOn:NO animated:YES];
        }
    }];
}


#pragma mark - private methods

// subscribeRAC
- (void)subscribeRAC{
    [atCentralManager.didConnectSuccess subscribeNext:^(id x) {
        [self.cell_switch setOn:YES animated:YES];
    }];
    [atCentralManager.didConnectFail subscribeNext:^(id x) {
        [self.cell_switch setOn:NO animated:YES];
    }];
    [atCentralManager.didDisconnect subscribeNext:^(id x) {
        [self.cell_switch setOn:NO animated:YES];
    }];
}


#pragma mark initialization methods

// init UI
- (void)_initUI{
    
    self.cell_switch.onTintColor = atColor.themeColor;
    
}





@end
