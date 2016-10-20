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
    
    ATMDSwitch *cell_switch = [ATMDSwitch switchWithView:self.contentView thumbColor:atColor.theme trackColor:atColor.theme.light];
    self.cell_switch = cell_switch;
    cell_switch.width = 60;
    cell_switch.height = 36;
    cell_switch.centerY = self.contentView.centerY;
    cell_switch.right = self.contentView.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    // init UI
    [self.cell_switch at_normalStyle];
    
    self.cell_image.clipsToBounds = NO;
    self.cell_image.layer.cornerRadius = 0.5 * fmin(self.cell_image.frame.size.width, self.cell_image.frame.size.height);
    
    // subscribeRAC
    [self subscribeRAC];
    // handle switch events
    [self handleSwitchEvents];
    
}

// handle switch events
- (void)handleSwitchEvents{
    [self.cell_switch at_addEventHandler:^(__kindof UISwitch * _Nonnull sender) {
        // do something
        if (self.cell_switch.on) {
            atCentral.connectSmartLamp(self.model);
        }else{
            atCentral.disConnectSmartLamp();
        }
    } forControlEvents:UIControlEventValueChanged];
    
    
}


#pragma mark - private methods

// subscribeRAC
- (void)subscribeRAC{
    [atCentral.didConnect subscribeNext:^(id x) {
        self.cell_switch.on = [x boolValue];
    }];
}







@end
