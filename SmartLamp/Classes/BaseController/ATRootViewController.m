//
//  ATRootViewController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-06-27.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

// support file
#import "ATRootViewController.h"
#import "ATManager+BaseVC.h"
#import "ATManager+AlertView.h"
#import <ATKit/ATDrawerController.h>
// child
#import "ATBaseTabBarController.h"
#import "LeftViewController.h"
#import "ATBaseNavigationController.h"
// post notification
static inline void atNoti_deviceStatus(NSObject *obj){
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deviceStatus" object:obj];
}

@interface ATRootViewController ()

// left view
@property (strong, nonatomic) LeftViewController *leftVC;
// main controller
@property (strong, nonatomic) ATBaseNavigationController *mainVC;
@property (strong, nonatomic) ATBaseTabBarController *tabbarVC;
// alert for scaning
@property (strong, nonatomic) SCLAlertView *alertForScaning;
// alert for device found
@property (strong, nonatomic) SCLAlertView *alertForDeviceFound;
// alert for connecting
@property (strong, nonatomic) SCLAlertView *alertForConnecting;


@end

static BOOL isShowingAlert = NO;

@implementation ATRootViewController

#pragma mark - view events

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // main controller
    _tabbarVC = [[ATBaseTabBarController alloc] init];
    _mainVC = [[ATBaseNavigationController alloc] initWithRootViewController:_tabbarVC];
    _leftVC = [[LeftViewController alloc] init];
    [self at_setupMainVC:self.mainVC drawerVC:self.leftVC enable:NO];
    
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

- (void)viewWillAppear:(BOOL)animated{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.mainVC.view.left = kScreenW;
        [UIView animateWithDuration:1.2f delay:0.2f usingSpringWithDamping:0.9f initialSpringVelocity:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.mainVC.view.left = 0;
            self.leftVC.view.left = -80;
        } completion:^(BOOL finished) {
            
        }];
    });
}

#pragma mark - private methods

// subscribeRAC
- (void)subscribeRAC{
    // scannable (skip the first signal)
    [[atCentral.didScannable skip:1] subscribeNext:^(id x) {
        if (![x boolValue]) {
            [self alertForDisScannable];
        }
    }];
    // scaning
    [atCentral.didScaning subscribeNext:^(id x) {
        if ([x boolValue]) {
            [self alertForScaning];
        } else{
            [self.alertForScaning hideView];
            self.alertForScaning = nil;
        }
    }];
    // device found
    [atCentral.didDeviceFound subscribeNext:^(id x) {
        if ([x boolValue]) {
            [self alertForDeviceFound];
        } else{
            [self alertForDeviceNotFound];
        }
    }];
    // connect success
    [atCentral.didConnect subscribeNext:^(id x) {
        if ([x boolValue]) {
            [self alertForConnectSuccess];
        } else{
            if ([[x description] isEqualToString:@"fail"]) {
                [self alertForConnectFail];
                return;
            }
            [self alertForDisconnectDevice];
        }
    }];
}


#pragma mark alert view

// alert for scaning
- (SCLAlertView *)alertForScaning{
    if (!_alertForScaning) {
        SCLAlertView *alert = [SCLAlertView at_SCLAlertViewWithColor:atColor.theme];
        [alert addButton:@"隐藏窗口" actionBlock:^{
            atNoti_deviceStatus(@"正在扫描周围可用的蓝牙灯");
            self.alertForScaning = nil;
        }];
        [alert addButton:@"停止扫描" actionBlock:^{
            atCentral.stopScan();
            atNoti_deviceStatus(@"您终止了扫描");
            self.alertForScaning = nil;
        }];
        if (self.allowsShowAlert) {
            [alert showWaiting:self title:@"正在扫描" subTitle:@"正在扫描周围可用的蓝牙灯..." closeButtonTitle:nil duration:0.0];
        }
        _alertForScaning = alert;
    }
    return _alertForScaning;
}

// alert for device not found
- (void)alertForDeviceNotFound{
    // hide device found view
    [self.alertForDeviceFound hideView];
    self.alertForDeviceFound = nil;
    SCLAlertView *alert = [SCLAlertView at_SCLAlertViewWithColor:atColor.theme];
    [alert addButton:@"继续扫描" actionBlock:^{
        atCentral.startScanWithAutoTimeout().letSmartLampPerformSleepMode();
    }];
    [alert addButton:@"好的" actionBlock:^{
        atNoti_deviceStatus(@"未发现可用的蓝牙灯");
        atCentral.stopScan();
    }];
    if (self.allowsShowAlert) {
        [alert showError:self title:@"找不到蓝牙灯" subTitle:@"请检查手机蓝牙开关或者蓝牙灯电源是否已经打开。" closeButtonTitle:nil duration:0.0f];
    }
    
}

// alert for device found
- (SCLAlertView *)alertForDeviceFound{
    // hide scaning view
    [self.alertForScaning hideView];
    self.alertForScaning = nil;
    if (!_alertForDeviceFound) {
        SCLAlertView *alert = [SCLAlertView at_SCLAlertViewWithColor:atColor.theme];
        for (CBPeripheral *model in atCentral.peripheralList) {
            [alert addButton:model.name actionBlock:^{
                atCentral.connectSmartLamp(model);
                [self alertForConnecting];
                self.alertForDeviceFound = nil;
            }];
        }
        [alert addButton:@"取消" actionBlock:^{
            self.alertForDeviceFound = nil;
            atCentral.stopScan();
        }];
        if (self.allowsShowAlert) {
            [alert showNotice:self
                        title:@"发现设备"
                     subTitle:@"请选择要连接的设备:"
             closeButtonTitle:nil duration:0.0f];
        }
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
        SCLAlertView *alert = [SCLAlertView at_SCLAlertViewWithColor:atColor.theme];
        [alert addButton:@"隐藏" actionBlock:^{
            self.alertForConnecting = nil;
        }];
        [alert showWaiting:self title:@"正在连接" subTitle:@"正在连接蓝牙灯，请稍等。。。" closeButtonTitle:nil duration:10.2f];
        _alertForConnecting = alert;
    }
    return _alertForConnecting;
}

// alert for connect success
- (void)alertForConnectSuccess{
    // hide connecting view
    [self.alertForConnecting hideView];
    self.alertForConnecting = nil;
    [ATProgressHUD at_target:self.view showInfo:@"连接成功" duration:1];
    
}

// alert for connect fail
- (void)alertForConnectFail{
    // hide connecting view
    [self.alertForConnecting hideView];
    self.alertForConnecting = nil;
    SCLAlertView *alert = [SCLAlertView at_SCLAlertViewWithColor:atColor.theme];
    [alert showError:self title:@"连接失败" subTitle:@"蓝牙灯连接失败!" closeButtonTitle:@"好的" duration:0.0f];
}

// alert for disconnect device
- (void)alertForDisconnectDevice{
    SCLAlertView *alert = [SCLAlertView at_SCLAlertViewWithColor:atColor.theme];
    [alert showError:self title:@"您已断开" subTitle:@"您已断开连接" closeButtonTitle:@"关闭" duration:1.0f];
}

// alert for disscannable
- (void)alertForDisScannable{
    if (!isShowingAlert) {
        SCLAlertView *alert = [SCLAlertView at_SCLAlertViewWithColor:atColor.theme];
        [alert addButton:@"关闭" actionBlock:^{
            isShowingAlert = NO;
        }];
        [alert showError:self title:@"无法扫描" subTitle:@"请打开设备蓝牙以开始扫描" closeButtonTitle:nil duration:0.0f];
        isShowingAlert = YES;
    }
}



@end
