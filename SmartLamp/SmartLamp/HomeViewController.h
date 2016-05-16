//
//  HomeViewController.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-04-21.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "ViewController.h"

@interface HomeViewController : ViewController


// 已经连接过的设备列表
@property (strong, nonatomic) NSArray *connectedDevice;

@property (strong, nonatomic) SCLAlertView *alertForScaning;
@property (strong, nonatomic) SCLAlertView *alertForConnecting;




- (void)showAlertWithDeviceNotFoundWithAction:(void (^)())action;

- (SCLAlertView *)showAlertWithConnecting;
- (void)showAlertWithConnectSuccess;

@end
