//
//  ATRootViewController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-06-27.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "ATRootViewController.h"
#import "UIViewController+ATScreenGesture.h"

//#import "ATLeftViewController.h"

@interface ATRootViewController ()

// 左侧视图
//@property (strong, nonatomic) ATLeftViewController *leftVC;

// 正在扫描的对话框
@property (strong, nonatomic) SCLAlertView *alertForScaning;
@property (strong, nonatomic) SCLAlertView *alertForDeviceFound;
// 正在连接的对话框
@property (strong, nonatomic) SCLAlertView *alertForConnecting;
// 连接成功的对话框
@property (strong, nonatomic) SCLAlertView *alertForConnectSuccess;


@end

@implementation ATRootViewController
#pragma mark - 🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀 视图事件

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 主控制器
    _mainVC = [[ATBaseTabBarController alloc] init];
    [self at_initWithMainVC:_mainVC leftVC:nil];
    [self at_setAppThemeColor:atColor.themeColor];
    
    // 允许弹窗
    self.allowsShowAlert = YES;
    // 设置通知
    [self _setupNotification];
    
}

//设置 状态栏的文字颜色为 高亮  白色
- (UIStatusBarStyle )preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 私有方法

// 设置通知
- (void)_setupNotification{
    
    [atNotificationCenter addObserver:self selector:@selector(receiveFoundDeviceNotification:) name:NOTI_BLE_SCAN object:nil];
    [atNotificationCenter addObserver:self selector:@selector(receiveConnectNotification:) name:NOTI_BLE_CONNECT object:nil];

}

// 扫描通知
- (void)receiveFoundDeviceNotification:(NSNotification *)noti{
    if ([noti.name isEqualToString:NOTI_BLE_SCAN]) {
        // 开始扫描
        if ([noti.object isEqualToString:NOTI_BLE_SCAN_START]) {
            if (self.allowsShowAlert) {
                [self alertForScaning];
            }
        }
        // 停止扫描
        else if ([noti.object isEqualToString:NOTI_BLE_SCAN_STOP]){
            
        }
        // 发现设备
        else if ([noti.object isEqualToString:NOTI_BLE_SCAN_FOUND]) {
            if (self.allowsShowAlert) {
                [self alertForDeviceFound];
            }
        }
        // 未发现设备
        else if ([noti.object isEqualToString:NOTI_BLE_SCAN_NOTFOUND]){
            if (self.allowsShowAlert) {
                [self alertForDeviceNotFound];
            }
        }
    }
}
// 连接通知
- (void)receiveConnectNotification:(NSNotification *)noti{
    if ([noti.name isEqualToString:NOTI_BLE_CONNECT]) {
        // 连接成功
        if ([noti.object isEqualToString:NOTI_BLE_CONNECT_SUCCESS]) {
            [self alertForConnectSuccess];
        }
        // 连接失败
        else if ([noti.object isEqualToString:NOTI_BLE_CONNECT_FAIL]){
            [self alertForConnectFail];
        }
        // 断开连接
        else if([noti.object isEqualToString:NOTI_BLE_CONNECT_DISCONNECT]){
            [self alertForDisconnectDevice];
        }
    }
}


#pragma mark alert
// 正在扫描
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

// 未找到设备
- (void)alertForDeviceNotFound{
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

// 发现设备
- (SCLAlertView *)alertForDeviceFound{
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


// 正在连接
- (SCLAlertView *)alertForConnecting{
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



// 连接成功
- (SCLAlertView *)alertForConnectSuccess{
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

// 连接失败
- (void)alertForConnectFail{
    
    [self.alertForConnecting hideView];
    self.alertForConnecting = nil;
    
    
    SCLAlertView *alert = [SCLAlertView at_SCLAlertViewWithColor:atColor.themeColor];
    [alert showError:self title:@"连接失败" subTitle:@"蓝牙灯连接失败!" closeButtonTitle:@"好的" duration:0.0f];
    
}

// 断开连接
- (void)alertForDisconnectDevice{
    
    SCLAlertView *alert = [SCLAlertView at_SCLAlertViewWithColor:atColor.themeColor];
    
    [alert showError:self title:@"您已断开" subTitle:@"您已断开连接" closeButtonTitle:@"关闭" duration:1.0f];
    
}


@end
