//
//  ATRootViewController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-06-27.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "ATRootViewController.h"
#import "ATBaseTabBarController.h"
#import "UIViewController+ATScreenGesture.h"
#import "SCLAlertView.h"
//#import "ATLeftViewController.h"

@interface ATRootViewController ()

// left view
//@property (strong, nonatomic) ATLeftViewController *leftVC;
// main controller
@property (strong, nonatomic) ATBaseTabBarController *mainVC;

// alert for scaning
@property (strong, nonatomic) SCLAlertView *alertForScaning;
// alert for device found
@property (strong, nonatomic) SCLAlertView *alertForDeviceFound;
// alert for connecting
@property (strong, nonatomic) SCLAlertView *alertForConnecting;
// alert for connect success
@property (strong, nonatomic) SCLAlertView *alertForConnectSuccess;


@end

@implementation ATRootViewController

#pragma mark - view events

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // main controller
    _mainVC = [[ATBaseTabBarController alloc] init];
    [self at_initWithMainVC:_mainVC leftVC:nil];
    [self at_setAppThemeColor:atColor.themeColor];
    
    // set allows to show alert
    self.allowsShowAlert = YES;
    // subscribeRAC
    [self subscribeRAC];
    
}

// status bar
- (UIStatusBarStyle )preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - private methods

// subscribeRAC
- (void)subscribeRAC{
    
    // scaning
    [atCentralManager.didScaning subscribeNext:^(id x) {
        if (self.allowsShowAlert) {
            [self alertForScaning];
        }
    }];
    // device found
    [atCentralManager.didDeviceFound subscribeNext:^(id x) {
        if (self.allowsShowAlert) {
            [self alertForDeviceFound];
        }
    }];
    // device not found
    [atCentralManager.didNotFound subscribeNext:^(id x) {
        if (self.allowsShowAlert) {
            [self alertForDeviceNotFound];
        }
    }];
    // connect success
    [atCentralManager.didConnectSuccess subscribeNext:^(id x) {
        [self alertForConnectSuccess];
    }];
    // connect fail
    [atCentralManager.didConnectFail subscribeNext:^(id x) {
        [self alertForConnectFail];
    }];
    // disconnect
    [atCentralManager.didDisconnect subscribeNext:^(id x) {
        [self alertForDisconnectDevice];
    }];
}


#pragma mark alert view

// alert for scaning
- (SCLAlertView *)alertForScaning{
    if (!_alertForScaning) {
        SCLAlertView *alert = [SCLAlertView at_SCLAlertViewWithColor:atColor.themeColor];
        [alert addButton:@"隐藏窗口" actionBlock:^{
            atNotificationCenter_deviceStatus(@"正在扫描周围可用的蓝牙灯");
            self.alertForScaning = nil;
        }];
        [alert addButton:@"停止扫描" actionBlock:^{
            [atCentralManager stopScan];
            atNotificationCenter_deviceStatus(@"您终止了扫描");
            self.alertForScaning = nil;
        }];
        [alert showWaiting:self title:@"正在扫描" subTitle:@"正在扫描周围可用的蓝牙灯..." closeButtonTitle:nil duration:0.0];
        _alertForScaning = alert;
    }
    return _alertForScaning;
}

// alert for device not found
- (void)alertForDeviceNotFound{
    // hide device found view
    [self.alertForDeviceFound hideView];
    self.alertForDeviceFound = nil;
    SCLAlertView *alert = [SCLAlertView at_SCLAlertViewWithColor:atColor.themeColor];
    [alert addButton:@"继续扫描" actionBlock:^{
        [atCentralManager startScanWithAutoTimeout];
    }];
    [alert addButton:@"好的" actionBlock:^{
        atNotificationCenter_deviceStatus(@"未发现可用的蓝牙灯");
        [atCentralManager stopScan];
    }];
    [alert showError:self title:@"找不到蓝牙灯" subTitle:@"请检查手机蓝牙开关或者蓝牙灯电源是否已经打开。" closeButtonTitle:nil duration:0.0f];
}

// alert for device found
- (SCLAlertView *)alertForDeviceFound{
    // hide scaning view
    [self.alertForScaning hideView];
    self.alertForScaning = nil;
    if (!_alertForDeviceFound) {
        SCLAlertView *alert = [SCLAlertView at_SCLAlertViewWithColor:atColor.themeColor];
        for (CBPeripheral *model in atCentralManager.scanedDeviceList) {
            [alert addButton:model.name actionBlock:^{
                [atCentralManager connectSmartLamp:model];
                [self alertForConnecting];
                self.alertForDeviceFound = nil;
            }];
        }
        [alert addButton:@"取消" actionBlock:^{
            self.alertForDeviceFound = nil;
        }];
        [alert showNotice:self
                    title:@"发现设备"
                 subTitle:@"请选择要连接的设备:"
         closeButtonTitle:nil duration:0.0f];
        _alertForDeviceFound = alert;
    }
    return _alertForDeviceFound;
}

// alert for connecting
- (SCLAlertView *)alertForConnecting{
    // hide device found view
    [self.alertForDeviceFound hideView];
    self.alertForDeviceFound = nil;
    if (!_alertForConnecting) {
        SCLAlertView *alert = [SCLAlertView at_SCLAlertViewWithColor:atColor.themeColor];
        [alert addButton:@"隐藏" actionBlock:^{
            self.alertForConnecting = nil;
        }];
        [alert showWaiting:self title:@"正在连接" subTitle:@"正在连接蓝牙灯，请稍等。。。" closeButtonTitle:nil duration:10.2f];
        _alertForConnecting = alert;
    }
    return _alertForConnecting;
}

// alert for connect success
- (SCLAlertView *)alertForConnectSuccess{
    // hide connecting view
    [self.alertForConnecting hideView];
    self.alertForConnecting = nil;
    if (!_alertForConnectSuccess) {
        SCLAlertView *alert = [SCLAlertView at_SCLAlertViewWithColor:atColor.themeColor];
        [alert addButton:@"好的" actionBlock:^{
            self.alertForConnectSuccess = nil;
        }];
        [alert showSuccess:self title:@"连接成功" subTitle:@"蓝牙灯连接成功!" closeButtonTitle:nil duration:1.0f];
        _alertForConnectSuccess = alert;
        
    }
    return _alertForConnectSuccess;
    // 开灯
    [atCentralManager letSmartLampTurnOnIf:YES];
}

// alert for connect fail
- (void)alertForConnectFail{
    // hide connecting view
    [self.alertForConnecting hideView];
    self.alertForConnecting = nil;
    SCLAlertView *alert = [SCLAlertView at_SCLAlertViewWithColor:atColor.themeColor];
    [alert showError:self title:@"连接失败" subTitle:@"蓝牙灯连接失败!" closeButtonTitle:@"好的" duration:0.0f];
}

// alert for disconnect device
- (void)alertForDisconnectDevice{
    SCLAlertView *alert = [SCLAlertView at_SCLAlertViewWithColor:atColor.themeColor];
    [alert showError:self title:@"您已断开" subTitle:@"您已断开连接" closeButtonTitle:@"关闭" duration:1.0f];
}


@end
