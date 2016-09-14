//
//  DeviceTableViewCell.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-19.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceTableViewCell : UITableViewCell
// model
@property (weak, nonatomic) CBPeripheral *model;
// image
@property (weak, nonatomic) IBOutlet UIImageView *cell_image;
// title
@property (weak, nonatomic) IBOutlet UILabel *cell_title;
// detail
@property (weak, nonatomic) IBOutlet UILabel *cell_detail;
// switch
@property (weak, nonatomic) IBOutlet UISwitch *cell_switch;

@end
