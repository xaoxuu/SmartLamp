//
//  HomeViewController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-04-21.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "HomeViewController.h"
#import "ATCentralManager.h"


@interface HomeViewController ()

// logo
@property (weak, nonatomic) IBOutlet UIButton *lampLogo;

// 背景颜色的view
@property (strong, nonatomic) IBOutlet UIView *backgroundView;

// RGBB
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UISlider *brightnessSlider;

// 开关按钮
@property (weak, nonatomic) IBOutlet UIButton *powerButton;

// 蓝牙按钮
@property (weak, nonatomic) IBOutlet UIButton *bluetoothButton;

// 已经连接过的设备列表
@property (strong, nonatomic) NSArray *connectedDevice;

// 定时器
@property (strong, nonatomic) NSTimer *myTimer;
@property (assign, nonatomic) CGFloat myTimerProgress;


@property (assign, nonatomic) BOOL lastConnectStatus;

@end

@implementation HomeViewController

#pragma mark - 视图事件 🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 隐藏状态栏
    [self prefersStatusBarHidden];
    
    // 初始化
    [self initialization];
    
    // 检查是否连接成功
    [self checkConnect];

}

// 隐藏状态栏
- (BOOL)prefersStatusBarHidden{
    return YES;
}


// 视图将要出现
-(void)viewWillAppear:(BOOL)animated{
    
    // 重新加载视图(从本地读取配置文件)
    [self reloadView];
    
    // 更新蓝牙灯状态
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(updateSmartLampStatus) userInfo:nil repeats:NO];

}

// 视图出现之后
-(void)viewDidAppear:(BOOL)animated{
    
    [self checkConnect];
    
}

// 视图消失之后
-(void)viewDidDisappear:(BOOL)animated{
    
    [self saveCache];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 控件事件 🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀

// 开关按钮
- (IBAction)powerButton:(UIButton *)sender {
    
    // 如果灯是开着的, 就关灯
    if (self.brightnessSlider.value) {
        [self.brightnessSlider setValue:0 animated:YES];
        [self.powerButton setImage:[UIImage imageNamed:@"powerOff"] forState:UIControlStateNormal];
        [self.iPhone letSmartLampPowerOnOrOff:NO];
     
    }
    
    // 如果灯是关着的, 就开灯
    else{

        [self.brightnessSlider setValue:self.aProfiles.brightness animated:YES];
        [self.powerButton setImage:[UIImage imageNamed:@"powerOn"] forState:UIControlStateNormal];
        [self updateSmartLampStatus];
    }
    
}

// RGB滑块和亮度滑块 值改变
- (IBAction)sliderRGB:(UISlider *)sender {
    
    // 更新蓝牙灯状态(颜色/亮度/动画)
    [self updateSmartLampStatus];
    
    // 更新视图
    [self updateLayer];
    // 如果滑动的是亮度条, 更新image
    if (sender == self.brightnessSlider) {
        [self updateImage];
    }
    
}

// RGB滑块和亮度滑块 TouchUp事件
- (IBAction)sliderTouchUp:(UISlider *)sender {
    
    // 如果手动调节了RGB滑块, 就意味着使用单色
    if (self.brightnessSlider != sender) {
        self.aProfiles.colorAnimation = ColorAnimationNone;
    }
    
    // ----------------------< 待优化 >---------------------- //
    // 由于使用协议提供的简易动画, 暂不支持动画模式下的亮度调节
    // 如果自定义了动画方法, 可以在这里实现动画模式下的亮度调节
    // ----------------------< 待优化 >---------------------- //
    
}

#pragma mark - 私有方法 🚫🚫🚫🚫🚫🚫🚫🚫🚫🚫

// 视图初始化设置
- (void)initialization{
    
    // 原来的连接状态
    self.lastConnectStatus = NO;
    // ==================== [ 设置控件的状态 ] ==================== //
    [self.powerButton     buttonState:ATButtonStateUp];
    [self.bluetoothButton buttonState:ATButtonStateUp];
    
    [self setSliderEnable:NO];
    
    
    // ==================== [ 自动连接 ] ==================== //
    [self autoConnect];
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(checkConnect) userInfo:nil repeats:NO];
    
    
}

// 重新加载视图
- (void)reloadView{
    
    self.aProfiles = nil;
    [self updateFrame];
    [self updateLayer];
    [self updateImage];
    
}

// 更新框架
- (void)updateFrame{
    
    // 更新滑块的位置
    [self.redSlider setValue:self.aProfiles.red animated:YES];
    [self.greenSlider setValue:self.aProfiles.green animated:YES];
    [self.blueSlider setValue:self.aProfiles.blue animated:YES];
    [self.brightnessSlider setValue:self.aProfiles.brightness animated:YES];
    
}

// 滑块是否可用
- (void)setSliderEnable:(BOOL)isEnable{
    
    self.redSlider.enabled = isEnable;
    self.greenSlider.enabled = isEnable;
    self.blueSlider.enabled = isEnable;
    self.brightnessSlider.enabled = isEnable;
    
}

// 更新视图
- (void)updateLayer{
    
    float alpha = _brightnessSlider.value;
    float red = _redSlider.value;
    float green = _greenSlider.value;
    float blue = _blueSlider.value;
    
    UIColor *buttonStyle = [UIColor colorWithRed:0.5 * red   + 0.3
                                           green:0.5 * green + 0.3
                                            blue:0.5 * blue  + 0.3
                                           alpha:0.7 * alpha + 0.3];
    
    
    // 背景颜色
    _backgroundView.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
    // 蓝牙按钮的颜色
    _bluetoothButton.backgroundColor = buttonStyle;
    
    // 刷新Slider的颜色
    _brightnessSlider.minimumTrackTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:alpha];
    _redSlider.minimumTrackTintColor = [UIColor colorWithRed:1 green:1-red blue:1-red alpha:alpha];
    _greenSlider.minimumTrackTintColor = [UIColor colorWithRed:1-green green:1 blue:1-green alpha:alpha];
    _blueSlider.minimumTrackTintColor = [UIColor colorWithRed:1-blue green:1-blue blue:1 alpha:alpha];
    
}

// 更新图片, 一般在开或关的时候才调用
- (void)updateImage{
    
    // 更新开关按钮的图标
    if (self.brightnessSlider.value) { // 如果灯是开着的
        [self.powerButton setImage:[UIImage imageNamed:@"powerOn"] forState:UIControlStateNormal];
    } else{
        [self.powerButton setImage:[UIImage imageNamed:@"powerOff"] forState:UIControlStateNormal];
    }
    
}

// 更新蓝牙灯的颜色
- (void)updateSmartLampStatus{
    
    // 如果有动画, 就显示动画效果
    if (self.aProfiles.colorAnimation) {
        [self.iPhone letSmartLampPerformColorAnimation:self.aProfiles.colorAnimation];
    }
    // 否则就显示单色模式
    else{
        [self.iPhone letSmartLampSetColorWithR:self.redSlider.value G:self.greenSlider.value B:self.blueSlider.value andBright:self.brightnessSlider.value];
    }
    
}

// 自动连接
- (void)autoConnect{
    
    // 如果本地保存有连接过的记录, 将自动匹配连接
    if (self.connectedDevice.count) {
        
        // 扫描设备
        [self searchBluetoothDevice];
        
    }
    
    // 如果没有连接过任何设备, 就跳转到蓝牙连接界面
    else{
        
        ViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"BluetoothViewController"];
        [self.navigationController pushViewController:view animated:YES];
        
    }
    
}

// 检查是否连接成功
- (void)checkConnect{
    
    // 如果现在状态是已连接
    if (self.iPhone.isConnecting) {
        
        // 如果之前是未连接, 就弹出提示"已连接"
        if (!self.lastConnectStatus) {
            [self pushAlertViewWithTitle:@"连接成功"
                              andMessage:@"您已连接成功, 现在就可以使用蓝牙灯了!"
                                   andOk:@"好的"
                               andCancel:@""
                           andOkCallback:^{}
                       andCancelCallback:^{}];
        }
        
        self.lastConnectStatus = YES;
        [self setSliderEnable:YES];
        
    } else{
        
        self.lastConnectStatus = NO;
        [self setSliderEnable:NO];
        
    }
    
}

// 保存缓存
- (void)saveCache{
    
    self.aProfiles.red = _redSlider.value;
    self.aProfiles.green = _greenSlider.value;
    self.aProfiles.blue = _blueSlider.value;
    self.aProfiles.brightness = _brightnessSlider.value;
    
    [ATFileManager saveCache:self.aProfiles];
    
}

// 搜索设备
- (void)searchBluetoothDevice{

    // ==================== [ 搜索 ] ==================== //
    [self.iPhone startScan];
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scaning:) userInfo:nil repeats:YES];
    
}

// 循环调用的方法
- (void)scaning:(id)sender{
    
    // 步进
    self.myTimerProgress += 1.0;

    if (self.myTimerProgress == 1.0) {
        [self.iPhone stopScan];
        [self.iPhone startScan];
    }
    
    // 循环结束时调用(如果扫描到了设备或者时间超过)
    if (self.iPhone.scanedDeviceList.count||self.myTimerProgress>3) {
        
        // 如果扫描到了至少一个蓝牙灯
        if (self.iPhone.scanedDeviceList.count) {
            
            // 如果本地保存的记录中有这个蓝牙灯, 就直接连接
            NSArray *local = self.connectedDevice;
            NSArray *scaned = self.iPhone.scanedDeviceList;
            for (NSString *str in local) {
                for (CBPeripheral *tmp in scaned) {
                    if ([tmp.name isEqualToString:str]) {
                        [self.iPhone connectSmartLamp:tmp];
                    }
                }
            }
            
        }
        
        // 如果时间到了也没找到连接过的设备, 就push到蓝牙连接页面
        if (self.myTimerProgress>3) {
            
            ViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"BluetoothViewController"];
            [self.navigationController pushViewController:view animated:YES];
            
        }
        
        // 定时器
        self.myTimerProgress = 0; // 计时进度恢复为0
        [self.myTimer invalidate];// 销毁定时器
        [self.myTimer fire];      // 销毁定时器
        
        // 停止扫描
        [self.iPhone stopScan];
        
    }
    
}

// 已经连接过的设备列表
-(NSArray *)connectedDevice{
    
    if (!_connectedDevice.count) {
        _connectedDevice = [ATFileManager readFile:ATFileTypeDevice];
    }
    return _connectedDevice;
    
}

@end
