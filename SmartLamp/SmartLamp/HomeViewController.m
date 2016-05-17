//
//  HomeViewController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-04-21.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "HomeViewController.h"
#import "ATCentralManager.h"
#import "ASValueTrackingSlider.h"
#import "UIImage+ImageEffects.h"

@interface HomeViewController () <ASValueTrackingSliderDataSource,ASValueTrackingSliderDelegate>

// logo
@property (weak, nonatomic) IBOutlet UIButton *lampLogo;

// 背景颜色的view
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
// 调色板
@property (weak, nonatomic) IBOutlet UIImageView *palette;
// 圆环
@property (strong, nonatomic) UIImageView *circle;
// 亮度滑块
@property (weak, nonatomic) IBOutlet ASValueTrackingSlider *brightnessSlider;
// 动画按钮
@property (weak, nonatomic) IBOutlet UIButton *animationButton;
// 开关灯按钮
@property (weak, nonatomic) IBOutlet UIButton *switchButton;
// 连接蓝牙按钮
@property (weak, nonatomic) IBOutlet UIButton *connectionButton;



// 定时器
@property (strong, nonatomic) NSTimer *myTimer;
@property (assign, nonatomic) CGFloat myTimerProgress;

// 上一次的连接状态
@property (assign, nonatomic) BOOL lastConnectStatus;

@end

@implementation HomeViewController

#pragma mark - 🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀 视图事件

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 隐藏状态栏
    [self prefersStatusBarHidden];
    
    // 初始化
    [self initialization];

}

// 隐藏状态栏
- (BOOL)prefersStatusBarHidden{
    return YES;
}


// 视图将要出现
-(void)viewWillAppear:(BOOL)animated{
    
    // 重新加载视图(从本地读取配置文件)
    [self reloadView];

    // 检查是否连接成功
    [self checkConnect];
    
    // 更新蓝牙灯状态
    [self updateSmartLampStatus];
    
}

// 视图出现之后
-(void)viewDidAppear:(BOOL)animated{
    
//    [self performSelector:@selector(showAlertWithConnecting) withObject:nil afterDelay:3];
    
}

// 视图消失之后
-(void)viewDidDisappear:(BOOL)animated{
    
    [self.circle removeFromSuperview];
    [self saveCache];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 调试
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.palette];
    
    CGFloat x = point.x - 0.5*self.palette.frame.size.width - 1;
    CGFloat y = point.y - 0.5*self.palette.frame.size.height - 1;
    CGFloat r = 0.5 * (self.palette.frame.size.width - 20);

    // 当调色板可见并且触摸在内部时调用
    if (x*x + y*y < r*r && self.palette.alpha) {
        // 更新颜色
        self.aProfiles.color = [self.palette.image getColorAtPixel:point inImageView:self.palette];
        // 更新蓝牙灯状态
        [self updateSmartLampStatus];
        // 更新圆环位置
        [self updateCircleWithPoint:point];
        // 更新视图
        [self updateLayer];
    }

}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.palette];
    
    CGFloat x = point.x - 0.5*self.palette.frame.size.width - 1;
    CGFloat y = point.y - 0.5*self.palette.frame.size.height - 1;
    CGFloat r = 0.5 * (self.palette.frame.size.width - 20);
    
    // 当调色板可见并且触摸在内部时调用
    if (x*x + y*y < r*r && self.palette.alpha) {
        NSLog(@"point:%g,%g",point.x,point.y);
        
        // 更新颜色
        self.aProfiles.color = [self.palette.image getColorAtPixel:point inImageView:self.palette];
        // 更新蓝牙灯状态
        [self updateSmartLampStatus];
        // 更新圆环位置
        [self updateCircleWithPoint:point];
        // 更新视图
        [self updateLayer];
        
    }

}


#pragma mark - 🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀 控件事件

- (IBAction)animationButton:(UIButton *)sender {
    
    NSLog(@"点击了动画按钮");
    
    if ([sender.currentTitle isEqualToString:@"动画"]) {
        [self showAlertWithColorAnimation];
    } else {
        self.aProfiles.colorAnimation = ColorAnimationNone;
        [self.iPhone letSmartLampPerformColorAnimation:self.aProfiles.colorAnimation];
        [self button:self.animationButton state:ATButtonStateNormal];
    }
    
}


- (IBAction)switchButton:(UIButton *)sender {
    
    // 关灯
    if ([self.switchButton.titleLabel.text isEqualToString:@"关灯"]) {
        NSLog(@"点击了关灯");
        // 保存数据
        [self saveCache];
        // 开关按钮状态
        [self button:self.switchButton state:ATButtonStateNormal];
        // 蓝牙灯状态
        [self.iPhone letSmartLampPowerOnOrOff:NO];
        
    }
    
    // 开灯
    else{
        NSLog(@"点击了开灯");
        NSLog(@"%@ ",self.switchButton.titleLabel.text);
        
        // 开关按钮状态
        [self button:self.switchButton state:ATButtonStateSelected];
        
        // 打开蓝牙灯
        [self.iPhone letSmartLampPowerOnOrOff:YES];
        // 蓝牙灯状态
        if (self.aProfiles.colorAnimation) {
            [self.iPhone letSmartLampPerformColorAnimation:self.aProfiles.colorAnimation];
        } else{
            [self.iPhone letSmartLampSetColor:self.aProfiles.color];
        }
        
    }
    
}


- (IBAction)connectionButton:(UIButton *)sender {
    
    NSLog(@"点击了连接");
    
    // 如果已经连接了 就弹出是否断开
    if (self.iPhone.isConnecting) {
        [self showAlertWithWhetherDisconnectWithAction:^{
            // 连接按钮状态
            [self button:self.connectionButton state:ATButtonStateNormal];
            // 断开蓝牙灯
            [self.iPhone disConnectSmartLamp];
            
        } deviceName:[self.iPhone.scanedDeviceList lastObject].name];
    } else{
        // 连接按钮状态
        [self button:self.connectionButton state:ATButtonStateDisable];
        // 搜索蓝牙设备
        [self searchDevice];
    }
    
    
}

// 亮度条按下的时候就取消动画
- (IBAction)cancelAnimation:(UISlider *)sender {
    self.aProfiles.colorAnimation = ColorAnimationNone;
}

// 更新亮度
- (IBAction)brightnessSlider:(UISlider *)sender {
    
    // 赋值
    self.aProfiles.brightness = self.brightnessSlider.value;
    // 发送指令
    [self updateSmartLampStatus];
    // 按钮和调色板
    [self button:self.animationButton state:ATButtonStateNormal];
    
}



#pragma mark - 🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵 连接设备 

// 检查是否连接成功
- (void)checkConnect{
    
    // 如果现在状态是已连接
    if (self.iPhone.isConnecting) {
        
        // 如果之前是未连接, 就弹出提示"已连接"
        if (!self.lastConnectStatus) {
            [self showAlertWithConnectSuccess];
        }
        
        // 连接按钮状态
        [self button:self.connectionButton state:ATButtonStateSelected];
        
        // 如果灯是开着的
        if (self.aProfiles.brightness) {
            [self button:self.switchButton state:ATButtonStateSelected];
            self.brightnessSlider.value = self.aProfiles.brightness;
            if (self.aProfiles.colorAnimation) {
                [self button:self.animationButton state:ATButtonStateSelected];
            }
        }
        
    }
    
    // 未连接状态
    else{
        
        // 连接按钮状态
        if (self.iPhone.isBluetoothAvailable&&!self.isAutoConnect) {
            [self button:self.connectionButton state:ATButtonStateNormal];
        } else{
            [self button:self.connectionButton state:ATButtonStateDisable];
        }
        
    }
    
    // 记录当前的状态
    self.lastConnectStatus = self.iPhone.isConnecting;
    
}


// 搜索设备
- (void)searchDevice{
    
    // 正在搜索的时候又触发了搜索方法, 就忽略重复指令
    // 只有在myTimerProgress为0的时候才执行
    if (!self.myTimerProgress) {
        
        // ==================== [ 初始化定时器 ] ==================== //
        // 必须置为非0值,防止重复执行
        self.myTimerProgress = 1;
        [self.myTimer invalidate];
        [self.myTimer fire];
        
        // ==================== [ 扫描 ] ==================== //
        [self.iPhone startScan];
        self.alertForScaning = [self showAlertWithScaning];
        
        // 每隔一段时间查看一次 self.iPhone.scanedDeviceList
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scaning:) userInfo:nil repeats:YES];
        
    }
    
}

// 循环调用的方法
- (void)scaning:(id)sender{
    
    // 步进
    self.myTimerProgress += 1.0;
    
    if (self.myTimerProgress == 1.0 && self.iPhone.isScaning) {
        [self.iPhone stopScan];
        [self.iPhone startScan];
    }
    
    // 循环结束时调用(如果扫描到了设备或者时间超过)
    if (self.iPhone.scanedDeviceList.count||self.myTimerProgress>10) {
        
        // 如果扫描到了设备会自动调用 showAlertWithDiscoverDevice
        
        // 停止扫描
        [self.iPhone stopScan];
        [self.alertForScaning hideView];
        
        // 重置定时器
        self.myTimerProgress = 0; // 计时进度恢复为0
        [self.myTimer invalidate];// 销毁定时器
        [self.myTimer fire];      // 销毁定时器
        
        // 如果循环结束时还没有扫描到设备
        if (!self.iPhone.scanedDeviceList.count) {
            [self showAlertWithDeviceNotFoundWithAction:^{
                [self searchDevice];
            }];
        }
        
    }
    
}


#pragma mark - 🚫🚫🚫🚫🚫🚫🚫🚫🚫🚫 私有方法

#pragma mark 🚫 初始化

// 视图初始化设置
- (void)initialization{
    
    // 原来的连接状态
    self.lastConnectStatus = NO;
    
    // 调色板的样式
    _palette.layer.cornerRadius = 100;
    _palette.layer.borderWidth = 3;
    _palette.layer.borderColor = [UIColor whiteColor].CGColor;
    _palette.layer.shadowOffset = (CGSize){0,0};
    _palette.layer.shadowRadius = 2.0;
    _palette.layer.shadowOpacity = 0.3f;
    
    // 滑动条
    self.brightnessSlider.popUpViewColor = self.tintColor;
    [self.brightnessSlider setAutoAdjustTrackColor:YES];
    NSNumberFormatter *fm = [[NSNumberFormatter alloc]init];
    fm.numberStyle = NSNumberFormatterPercentStyle;
    self.brightnessSlider.numberFormatter = fm;
    
    // 注册通知
    [self receiverNotification];
    
    // ==================== [ 自动连接 ] ==================== //
    [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(searchDevice) userInfo:nil repeats:NO];
    
    
}

// 重新加载视图
- (void)reloadView{
    
    self.aProfiles = nil;
    [self updateFrame];
    [self updateLayer];
    
}

// 更新框架
- (void)updateFrame{
    
    // 如果有定时关机, 就定时关机
    if (self.aProfiles.timer) {
        [self.iPhone letSmartLampSleepAfter:self.aProfiles.timer];
    }
    
}


// 更新视图
- (void)updateLayer{
    
    // 背景颜色
    self.backgroundView.backgroundColor = self.aProfiles.color;
    // 滑块的轨道颜色
    self.brightnessSlider.minimumTrackTintColor = self.aProfiles.color;
    
}


// 更新蓝牙灯的颜色
- (void)updateSmartLampStatus{
    
    // 如果有动画, 就显示动画效果
    if (self.aProfiles.colorAnimation) {
        [self.iPhone letSmartLampPerformColorAnimation:self.aProfiles.colorAnimation];
    }
    // 否则就显示单色模式
    else{
        // 提取出UIColor中的RGB值
        CGFloat red=0,green=0,blue=0,bright=0;
        [self.aProfiles.color getRed:&red green:&green blue:&blue alpha:&bright];
        // 赋值
        self.aProfiles.color = [UIColor colorWithRed:red green:green blue:blue alpha:self.aProfiles.brightness];
        // 发送数据
        [self.iPhone letSmartLampSetColor:self.aProfiles.color];
    }
    
}


// 保存缓存
- (void)saveCache{
    
    [ATFileManager saveCache:self.aProfiles];
    
}


- (void)updateCircleWithPoint:(CGPoint)point{
    
    [self.circle removeFromSuperview];
    CGSize size = self.circle.frame.size;
    point.x -= size.width * 0.5;
    point.y -= size.height * 0.5;
    self.circle.frame = (CGRect){point,size};
    
    [self.palette addSubview:self.circle];
    
}


- (void)button:(UIButton *)button state:(ATButtonState)state{
    
    
    if (button == self.animationButton) {
        switch (state) {
            case ATButtonStateNormal:
                // 按钮标题
                button.selected = NO;
                [button setTitle:@"动画" forState:UIControlStateNormal];
                // 调色板
                self.palette.alpha = YES;
                [self.palette setUserInteractionEnabled:YES];
                break;
            case ATButtonStateTap: //
                break;
            case ATButtonStateSelected: //
                // 按钮标题
                [button setTitle:@"调色" forState:UIControlStateNormal];
                // 调色板
                self.palette.alpha = NO;
                [self.palette setUserInteractionEnabled:NO];
                break;
            case ATButtonStateDisable: //
                // 按钮标题
                [button setTitle:@"动画" forState:UIControlStateNormal];
                // 调色板
                self.palette.alpha = NO;
                [self.palette setUserInteractionEnabled:NO];
                break;
                
        }
        
    }
    
    else if (button == self.switchButton) {
        
        switch (state) {
            case ATButtonStateNormal:
                // 按钮标题
                button.selected = NO;
                [button setTitle:@"开灯" forState:UIControlStateNormal];
                // 滑块
                self.brightnessSlider.enabled = NO;
                [self.brightnessSlider setValue:0 animated:YES];
                // 动画按钮
                [self button:self.animationButton state:ATButtonStateDisable];
                break;
            case ATButtonStateTap: //
                break;
            case ATButtonStateSelected: //
                // 按钮标题
                [button setTitle:@"关灯" forState:UIControlStateNormal];
                // 滑块
                self.brightnessSlider.enabled = YES;
                [self.brightnessSlider setValue:self.aProfiles.brightness animated:YES];
                // 动画按钮
                [self button:self.animationButton state:ATButtonStateNormal];
                break;
            case ATButtonStateDisable: //
                // 按钮标题
                [button setTitle:@"开灯" forState:UIControlStateNormal];
                // 滑块
                self.brightnessSlider.enabled = NO;
                [self.brightnessSlider setValue:0 animated:YES];
                // 动画按钮
                [self button:self.animationButton state:ATButtonStateDisable];
                break;
                
        }
        
        
    }
    
    else if (button == self.connectionButton) {
        
        switch (state) {
            case ATButtonStateNormal:
                // 按钮标题
                button.selected = NO;
                [button setTitle:@"连接" forState:UIControlStateNormal];
                // 开关按钮
                [self button:self.switchButton state:ATButtonStateDisable];
                break;
            case ATButtonStateTap: //
                break;
            case ATButtonStateSelected: //
                // 按钮标题
                [button setTitle:@"断开" forState:UIControlStateNormal];
                // 开关按钮
                [self button:self.switchButton state:ATButtonStateNormal];
                break;
            case ATButtonStateDisable: //
                // 按钮标题
                [button setTitle:@"等待" forState:UIControlStateNormal];
                // 开关按钮
                [self button:self.switchButton state:ATButtonStateDisable];
                break;
                
        }
        
    }
    
    // 按钮状态样式
    [button buttonState:state];
    

}



#pragma mark 🚫 懒加载

// 已经连接过的设备列表
-(NSArray *)connectedDevice{
    
    if (!_connectedDevice.count) {
        _connectedDevice = [ATFileManager readFile:ATFileTypeDevice];
    }
    return _connectedDevice;
    
}


-(UIImageView *)circle{
    
    if (!_circle) {
        self.circle = [[UIImageView alloc] initWithFrame:(CGRect){0,0,20,20}];
        self.circle.image = [UIImage imageNamed:@"Icon_Circle"];
        [self.circle setUserInteractionEnabled:NO];
    }
    
    return _circle;
    
}
#pragma mark 🚫 AlertView


// 正在扫描
- (SCLAlertView *)showAlertWithScaning{
    
    // 如果已经设为自动连接了  就不再弹窗
    if (self.isAutoConnect) return _alertForScaning;
    
    SCLAlertView *alert = self.newAlert;
    [alert addButton:@"自动连接" actionBlock:^{
        self.isAutoConnect = YES;
        [self button:self.connectionButton state:ATButtonStateDisable];
        NSLog(@"点击了自动连接");
    }];
    [alert addButton:@"停止扫描" actionBlock:^{
        NSLog(@"点击了停止扫描");
        self.isAutoConnect = NO;
        [self button:self.connectionButton state:ATButtonStateNormal];
        
        // 停止扫描
        [self.iPhone stopScan];
        
        // 重置定时器
        self.myTimerProgress = 0; // 计时进度恢复为0
        [self.myTimer invalidate];// 销毁定时器
        [self.myTimer fire];      // 销毁定时器
        
    }];
    
    // 第一次创建时自动连接设为NO
    if (!_alertForScaning) {
        self.isAutoConnect = NO;
    }
    [self.connectionButton buttonState:ATButtonStateDisable];

    [alert showWaiting:self title:@"正在扫描"
              subTitle:@"正在扫描周围可用的蓝牙灯..."
      closeButtonTitle:nil duration:0.0f];
    
    _alertForScaning = alert;
    
    return _alertForScaning;
    
}

// 未找到设备
- (void)showAlertWithDeviceNotFoundWithAction:(void (^)())action{
    
    SCLAlertView *alert = self.newAlert;
    
    [alert addButton:@"继续扫描" actionBlock:^{
        NSLog(@"点击了继续扫描");
        action();
    }];
    [alert addButton:@"好的" actionBlock:^{
        NSLog(@"点击了好的");
        self.isAutoConnect = NO;
        [self.iPhone stopScan];
        self.myTimerProgress = 0;
        [self.myTimer invalidate];
        [self.myTimer fire];
        [self button:self.connectionButton state:ATButtonStateNormal];
    }];
    [alert showError:self title:@"找不到蓝牙灯" subTitle:@"请检查手机蓝牙开关或者蓝牙灯电源是否已经打开。" closeButtonTitle:nil duration:0.0f];
    
}

// 发现设备
- (void)showAlertWithDiscoverDevice:(NSString *)device{
    
    SCLAlertView *alert = self.newAlert;
    
    [self.alertForScaning hideView];
    
    [alert addButton:@"连接设备" actionBlock:^{
        [self.iPhone connectSmartLamp:[self.iPhone.scanedDeviceList lastObject]];
        [self showAlertWithConnecting];
        
    }];
    
    [alert addButton:@"设备列表" actionBlock:^{
        ViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"BluetoothViewController"];
        [self.navigationController pushViewController:view animated:YES];
    }];
    
    [alert showNotice:self
                title:@"发现设备"
             subTitle:device
     closeButtonTitle:@"取消" duration:0.0f];
    
    
}

// 正在连接
- (SCLAlertView *)showAlertWithConnecting{
    
    if (!_alertForConnecting) {
        SCLAlertView *alert = self.newAlert;
        [alert showWaiting:self title:@"正在连接" subTitle:@"正在连接蓝牙灯，请稍等。。。" closeButtonTitle:@"隐藏" duration:10.2f];
        
        // 如果10秒之内没有弹出连接成功的提示, 就弹出连接失败的提示(连接成功时会关掉这个对话框)
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(showAlertWithConnectFail) userInfo:nil repeats:NO];
        
        _alertForConnecting = alert;
    }
    return _alertForConnecting;
    
}

// 连接成功
- (void)showAlertWithConnectSuccess{
    
    [self.alertForConnecting hideView];
    self.alertForConnecting = nil;
    [self.myTimer invalidate];
    self.lastConnectStatus = YES;
    [self button:self.connectionButton state:ATButtonStateSelected];
    
    SCLAlertView *alert = self.newAlert;
    [alert showSuccess:self title:@"连接成功" subTitle:@"蓝牙灯连接成功!" closeButtonTitle:@"好的" duration:1.0f];
    _alertForConnectSuccess = alert;
    
}

// 连接失败
- (void)showAlertWithConnectFail{
    
    [self.alertForConnecting hideView];
    self.alertForConnecting = nil;
    
    [self button:self.connectionButton state:ATButtonStateNormal];
    
    SCLAlertView *alert = self.newAlert;
    [alert showError:self title:@"连接失败" subTitle:@"蓝牙灯连接失败!" closeButtonTitle:@"好的" duration:0.0f];
    
}

// 断开连接
- (void)showAlertWithWhetherDisconnectWithAction:(void (^)())action deviceName:(NSString *)deviceName{
    
    SCLAlertView *alert = self.newAlert;
    
    [alert addButton:@"断开" actionBlock:^{
        NSLog(@"点击了断开");
        action();
        [self button:self.connectionButton state:ATButtonStateNormal];
        
    }];
    NSString *subTitle = [NSString stringWithFormat:@"是否断开与\"%@\"的连接?",deviceName];
    [alert showQuestion:self title:@"是否断开" subTitle:subTitle closeButtonTitle:@"取消" duration:0.0f];
    
}

// 颜色动画
- (void)showAlertWithColorAnimation{
    
    SCLAlertView *alert = self.newAlert;
    
    [alert addButton:@"三色跳变" actionBlock:^{
        NSLog(@"点击了三色跳变");
        self.aProfiles.colorAnimation = ColorAnimationSaltusStep3;
        [self.iPhone letSmartLampPerformColorAnimation:self.aProfiles.colorAnimation];
        [self button:self.animationButton state:ATButtonStateSelected];
    }];
    [alert addButton:@"七色跳变" actionBlock:^{
        NSLog(@"点击了七色跳变");
        self.aProfiles.colorAnimation = ColorAnimationSaltusStep7;
        [self.iPhone letSmartLampPerformColorAnimation:self.aProfiles.colorAnimation];
        [self button:self.animationButton state:ATButtonStateSelected];
     }];
    
    [alert addButton:@"渐变" actionBlock:^{
        NSLog(@"点击了渐变");
        self.aProfiles.colorAnimation = ColorAnimationGratation;
        [self.iPhone letSmartLampPerformColorAnimation:self.aProfiles.colorAnimation];
        [self button:self.animationButton state:ATButtonStateSelected];
    }];
    
    [alert showNotice:self
                  title:@"动画模式"
               subTitle:@"请选择动画模式"
       closeButtonTitle:@"取消"
               duration:0.0f];
    
    
}

#pragma mark 🚫 通知

// 注册在通知中心
- (void)receiverNotification{
    
    // 蓝牙状态
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationBluetoothStatus:)
                                                 name:BLUETOOTH
                                               object:nil];
    
    // 连接
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationConnect:)
                                                 name:CONNECT
                                               object:nil];
    
    // 设备
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationDevice:)
                                                 name:DEVICE
                                               object:nil];
    
    // 断开连接
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationDisconnect:)
                                                 name:DISCONNECT
                                               object:nil];
    
}

// 蓝牙状态的通知
- (void)notificationBluetoothStatus:(NSNotification *)notification{
    
    // 🖥
    NSLog(@"频道是: %@",notification.name);
    NSLog(@"收到的消息是: %@",notification.object);
    
    if ([notification.object isEqualToString:@"蓝牙可用"]) {
        [self button:self.connectionButton state:ATButtonStateNormal];
    }else{
        [self button:self.connectionButton state:ATButtonStateDisable];
    }
    
}

// 发现设备的通知
- (void)notificationDevice:(NSNotification *)notification{
    
    // 🖥
    NSLog(@"频道是: %@",notification.name);
    NSLog(@"收到的消息是: %@",notification.object);
    
    [self button:self.connectionButton state:ATButtonStateNormal];
    
    // 1. 如果设置为自动连接, 就自动连接 2. 如果本地保存的记录中有这个蓝牙灯, 直接连接
    BOOL isAutoConnect = self.isAutoConnect && [self.connectedDevice containsObject:[self.iPhone.scanedDeviceList lastObject]];
    
    // 1. 如果设置为自动连接, 就自动连接
    if (isAutoConnect) {
        // 关闭扫描的对话框
//        [self.alertForScaning hideView];
        // 连接
        self.alertForConnecting = [self showAlertWithConnecting];
        [self.iPhone connectSmartLamp:[self.iPhone.scanedDeviceList lastObject]];
    }
   
    // 3. 如果本地没有保存这个蓝牙灯的连接记录, 也没有设置自动连接, 就push到蓝牙设备列表页面
    else {
        // 弹出是否连接的对话框
        [self performSelector:@selector(showAlertWithDiscoverDevice:) withObject:notification.object afterDelay:0.5];
        // 关闭扫描的对话框
//        [self.alertForScaning performSelector:@selector(hideView) withObject:nil afterDelay:0.5];
        
    }
    
}

// 连接时的通知
- (void)notificationConnect:(NSNotification *)notification{
    
    // 🖥
    NSLog(@"频道是: %@",notification.name);
    NSLog(@"收到的消息是: %@",notification.object);
    if ([notification.object isEqualToString:SUCCESS]) {
        // 连接成功
       [self performSelector:@selector(showAlertWithConnectSuccess) withObject:nil afterDelay:1];
        
    } else{
        // 连接失败
        [self.newAlert showError:self title:@"连接失败" subTitle:@"与蓝牙灯连接失败。" closeButtonTitle:@"好的" duration:0.0f];
    }
    
}


// 断开时的通知
- (void)notificationDisconnect:(NSNotification *)notification{
    
    // 🖥
    NSLog(@"频道是: %@",notification.name);
    NSLog(@"收到的消息是: %@",notification.object);
    if ([notification.object isEqualToString:SUCCESS]) {
        // 设备已断开
        [self.newAlert showError:self title:@"已断开连接" subTitle:@"与蓝牙灯的连接已断开。" closeButtonTitle:@"好的" duration:0.5f];
        // 状态标记
        self.isAutoConnect = NO;
        self.iPhone.isConnecting = NO;
        self.lastConnectStatus = NO;
        // 按钮状态
        [self button:self.connectionButton state:ATButtonStateNormal];
        
    }
    
}


#pragma mark - 🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵 数据源和代理

- (NSString *)slider:(ASValueTrackingSlider *)slider stringForValue:(float)value{
    
    return [NSString stringWithFormat:@"%.0f",slider.value];
    
}

- (void)sliderWillDisplayPopUpView:(ASValueTrackingSlider *)slider{
    
    
    
}




@end
