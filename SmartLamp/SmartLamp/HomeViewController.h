//
//  HomeViewController.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-04-21.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "ViewController.h"

@interface HomeViewController : ViewController

// 正在扫描的对话框
@property (strong, nonatomic) SCLAlertView *alertForScaning;
// 正在连接的对话框
@property (strong, nonatomic) SCLAlertView *alertForConnecting;
// 连接成功的对话框
@property (strong, nonatomic) SCLAlertView *alertForConnectSuccess;

// 定时器
@property (strong, nonatomic) NSTimer *myTimer;
@property (assign, nonatomic) CGFloat myTimerProgress;

// 弹出未发现设备
- (void)showAlertWithDeviceNotFoundWithAction:(void (^)())action;
// 弹出正在连接的对话框
- (SCLAlertView *)showAlertWithConnecting;
// 弹出连接成功的对话框
- (void)showAlertWithConnectSuccess;

@end
