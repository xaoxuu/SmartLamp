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
@property (weak, nonatomic) IBOutlet UISlider *brightnessSlider;
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

    [self checkConnect];
    
}

// 视图出现之后
-(void)viewDidAppear:(BOOL)animated{
    
//    [self performSelector:@selector(showAlertWithConnecting) withObject:nil afterDelay:3];
    
}

// 视图消失之后
-(void)viewDidDisappear:(BOOL)animated{
    
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
        NSLog(@"point:%g,%g",point.x,point.y);
        
        // 更新颜色
        self.color = [self.palette.image getColorAtPixel:point inImageView:self.palette];
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
        self.color = [self.palette.image getColorAtPixel:point inImageView:self.palette];
        // 更新蓝牙灯状态
        [self updateSmartLampStatus];
        // 更新圆环位置
        [self updateCircleWithPoint:point];
        // 更新视图
        [self updateLayer];
        
    }

    
}


#pragma mark - 🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀 控件事件

// 功能按钮(颜色/亮度/连接)
- (IBAction)actionButton:(UIButton *)sender {
    
    // 调色板按钮
    if (sender == self.animationButton) {
        NSLog(@"点击了动画按钮");
        
        if ([sender.currentTitle isEqualToString:@"动画"]) {
            [self showAlertWithColorAnimation];
        } else {
            [self setPaletteEnable:YES];
        }
        
//        [self showAlertWithConnecting];
    }
    
    if (sender == self.switchButton) {
        
//        [self showAlertWithConnecting];
        
        // 关灯
        if ([self.switchButton.titleLabel.text isEqualToString:@"关灯"]) {
            NSLog(@"点击了关灯");
            [self.brightnessSlider setValue:0 animated:YES];
            [self.switchButton setTitle:@"开灯" forState:UIControlStateNormal];
            [self.iPhone letSmartLampPowerOnOrOff:NO];
            [self.switchButton setSelected:NO];
//            [self.switchButton buttonState:ATButtonStateSelected];
            
            [self.animationButton buttonState:ATButtonStateDisable];
            
        }
        
        // 开灯
        else{
            NSLog(@"点击了开灯");
            NSLog(@"%@ ",self.switchButton.titleLabel.text);
            CGFloat bright=0;
            [self.aProfiles.color getRed:nil green:nil blue:nil alpha:&bright];
            [self.brightnessSlider setValue:100 * bright  animated:YES];
            [self.switchButton setTitle:@"关灯" forState:UIControlStateNormal];
            [self updateSmartLampStatus];
            
            [self.switchButton setSelected:YES];
//            [self.switchButton buttonState:ATButtonStateNormal];
            
            [self.animationButton buttonState:ATButtonStateNormal];
        }
        
    }
    
    if (sender == self.connectionButton) {
        NSLog(@"点击了连接");
        
        // 如果已经连接了 就弹出是否断开
        if (self.iPhone.isConnecting) {
            [self showAlertWithWhetherDisconnectWithAction:^{
                [self.iPhone disConnectSmartLamp];
                [self.connectionButton setSelected:NO];
                [self.animationButton buttonState:ATButtonStateDisable];
                [self.switchButton buttonState:ATButtonStateDisable];
            } deviceName:[[ATFileManager readFile:ATFileTypeDevice] lastObject]];
        } else{
            [self searchDevice];
        }
        
    }
    
}


// RGB滑块和亮度滑块 值改变
- (IBAction)sliderRGB:(UISlider *)sender {
    
    // 更新蓝牙灯状态(颜色/亮度/动画)
    [self updateSmartLampStatus];
    
    // 更新视图
    [self updateLayer];
    
    
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


#pragma mark - 🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵 连接设备 

// 检查是否连接成功
- (void)checkConnect{
    
    self.brightnessSlider.enabled = self.iPhone.isConnecting;
    
    // 如果现在状态是已连接
    if (self.iPhone.isConnecting) {
        
        // 如果之前是未连接, 就弹出提示"已连接"
        if (!self.lastConnectStatus) {
            [self showAlertWithConnectSuccess];
        }
        
        [self.connectionButton setTitle:@"断开" forState:UIControlStateNormal];
        [self.connectionButton setSelected:YES];
        [self.connectionButton buttonState:ATButtonStateSelected];
        [self.animationButton buttonState:ATButtonStateNormal];
        [self.switchButton buttonState:ATButtonStateNormal];
        
        
    }
    // 未连接状态
    else{
        
        [self.connectionButton setTitle:@"连接" forState:UIControlStateNormal];
        [self.animationButton buttonState:ATButtonStateDisable];
        [self.switchButton buttonState:ATButtonStateDisable];
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
    
    if (self.myTimerProgress == 1.0) {
        [self.iPhone stopScan];
        [self.iPhone startScan];
    }
    
    // 循环结束时调用(如果扫描到了设备或者时间超过)
    if (self.iPhone.scanedDeviceList.count||self.myTimerProgress>10) {
        
        // 停止扫描
        [self.iPhone stopScan];
        [self.alertForScaning hideView];
        self.connectionButton.enabled = YES;
        
        // 重置定时器
        self.myTimerProgress = 0; // 计时进度恢复为0
        [self.myTimer invalidate];// 销毁定时器
        [self.myTimer fire];      // 销毁定时器
        
        // 如果扫描到了至少一个蓝牙灯
        if (self.iPhone.scanedDeviceList.count) {
            
            // 1. 如果设置为自动连接, 就自动连接
            if (self.isAutoConnect) {
                self.alertForConnecting = [self showAlertWithConnecting];
                [self.iPhone connectSmartLamp:[self.iPhone.scanedDeviceList lastObject]];
            }
            
            else if ([self.connectedDevice containsObject:[self.iPhone.scanedDeviceList lastObject]]){
                // 2. 如果本地保存的记录中有这个蓝牙灯, 直接连接
                self.alertForConnecting = [self showAlertWithConnecting];
                [self.iPhone connectSmartLamp:[self.iPhone.scanedDeviceList lastObject]];
                
            }
            
            else {
                
                // 3. 如果本地没有保存这个蓝牙灯的连接记录, 也没有设置自动连接, 就push到蓝牙设备列表页面
                ViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"BluetoothViewController"];
                [self.navigationController pushViewController:view animated:YES];
                
                
            }
            
            
        }
        
        [self showAlertWithDeviceNotFoundWithAction:^{
            [self searchDevice];
        }];
        
    }
    
}


#pragma mark - 🚫🚫🚫🚫🚫🚫🚫🚫🚫🚫 私有方法

#pragma mark 🚫 初始化

// 视图初始化设置
- (void)initialization{
    
    // 原来的连接状态
    self.lastConnectStatus = NO;
    // ==================== [ 设置控件的状态 ] ==================== //
    [self.animationButton  buttonState:ATButtonStateDisable];
    [self.switchButton     buttonState:ATButtonStateDisable];
    [self.connectionButton buttonState:ATButtonStateNormal];
    
//    self.brightnessSlider.enabled = NO;
    
    
    _palette.layer.cornerRadius = 100;
    _palette.layer.borderWidth = 3;
    _palette.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _palette.layer.shadowOffset = (CGSize){0,0};
    _palette.layer.shadowRadius = 2.0;
    _palette.layer.shadowOpacity = 0.3f;
    
    
    
    
    // ==================== [ 自动连接 ] ==================== //
    [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(searchDevice) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(checkConnect) userInfo:nil repeats:NO];
    
    
}

// 重新加载视图
- (void)reloadView{
    
    self.aProfiles = nil;
    [self updateFrame];
    [self updateLayer];
    
}

// 更新框架
- (void)updateFrame{
    
    // 调色板是否可见
    if (self.aProfiles.colorAnimation) {
        [self setPaletteEnable:NO];
    }
    
    // 更新滑块的位置
    CGFloat bright=0;
    [self.aProfiles.color getRed:nil green:nil blue:nil alpha:&bright];
    [self.brightnessSlider setValue:bright animated:YES];
    
    // 当已经连接并且没有动画的时候调色板可用
    [self setPaletteEnable:self.iPhone.isConnecting&&!self.aProfiles.colorAnimation];
    
    // ==================== [ 按钮是否可用 ] ==================== //
    // 如果连接
    if (self.iPhone.isConnecting) {
        // 如果灯已经打开
        if (self.brightnessSlider) {
            // 动画按钮可用
            [self.animationButton buttonState:ATButtonStateNormal];
            // 开关按钮选中
            [self.switchButton buttonState:ATButtonStateSelected];
        } else{
            // 否则动画按钮不可用
            [self.animationButton buttonState:ATButtonStateDisable];
            // 开关按钮可用
            [self.switchButton buttonState:ATButtonStateNormal];
        }
        // 连接按钮选中
        [self.connectionButton buttonState:ATButtonStateSelected];
    }
    // 如果没有连接
    else{
        // 动画按钮不可用
        [self.animationButton buttonState:ATButtonStateDisable];
        // 开关按钮不可用
        [self.switchButton buttonState:ATButtonStateDisable];
        // 连接按钮可用
        [self.connectionButton buttonState:ATButtonStateNormal];
    }
    
    
}


// 更新视图
- (void)updateLayer{
    
    // 背景颜色
    self.backgroundView.backgroundColor = self.color;
    // 滑块的轨道颜色
    self.brightnessSlider.minimumTrackTintColor = self.color;
    
}


// 更新蓝牙灯的颜色
- (void)updateSmartLampStatus{
    
    // 如果有动画, 就显示动画效果
    if (self.aProfiles.colorAnimation) {
        [self.iPhone letSmartLampPerformColorAnimation:self.aProfiles.colorAnimation];
    }
    // 否则就显示单色模式
    else{
//        [self.iPhone letSmartLampSetColorWithR:self.redSlider.value G:self.greenSlider.value B:self.blueSlider.value andBright:self.brightnessSlider.value];
    }
    
    
    
    
}


// 保存缓存
- (void)saveCache{
    
    self.aProfiles.color = self.color;
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
        self.circle = [[UIImageView alloc] initWithFrame:(CGRect){0,0,30,30}];
        self.circle.image = [UIImage imageNamed:@"Icon_Circle"];
        [self.circle setUserInteractionEnabled:NO];
    }
    
    return _circle;
    
}
#pragma mark 🚫 AlertView

- (SCLAlertView *)showAlertWithScaning{
    
    // 如果已经设为自动连接了  就不再弹窗
    if (self.isAutoConnect) return _alertForScaning;
    
    SCLAlertView *alert = self.newAlert;
    [alert addButton:@"自动连接" actionBlock:^{
        self.isAutoConnect = YES;
        NSLog(@"点击了自动连接");
    }];
    [alert addButton:@"停止扫描" actionBlock:^{
        NSLog(@"点击了停止扫描");
        self.connectionButton.enabled = YES;
        [self.iPhone stopScan];
        [self.myTimer invalidate];
        [self.myTimer fire];
        self.myTimerProgress = 0;
        
    }];
    
    // 第一次创建时自动连接设为NO
    if (!_alertForScaning) {
        self.isAutoConnect = NO;
    }
    self.connectionButton.enabled = NO;

    [alert showWaiting:self title:@"正在扫描"
              subTitle:@"正在扫描周围可用的蓝牙灯..."
//     subTitle:[NSString stringWithFormat:@"正在扫描周围可用的蓝牙灯\n请稍等。。。"]
      closeButtonTitle:nil duration:0.0f];
    
    _alertForScaning = alert;
    
    return _alertForScaning;
    
}

- (void)showAlertWithDeviceNotFoundWithAction:(void (^)())action{
    
    SCLAlertView *alert = self.newAlert;
    
    [alert addButton:@"继续扫描" actionBlock:^{
        NSLog(@"点击了继续扫描");
        
        action();
    }];
    [alert addButton:@"好的" actionBlock:^{
        NSLog(@"点击了好的");
        self.isAutoConnect = NO;
    }];
    [alert showError:self title:@"找不到蓝牙灯" subTitle:@"请检查手机蓝牙开关或者蓝牙灯电源是否已经打开。" closeButtonTitle:nil duration:0.0f];
    
}


- (SCLAlertView *)showAlertWithConnecting{
    
    if (!_alertForConnecting) {
        SCLAlertView *alert = self.newAlert;
        [alert showWaiting:self title:@"正在连接" subTitle:@"正在连接蓝牙灯，请稍等。。。" closeButtonTitle:nil duration:1.8f];
        [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(showAlertWithConnectSuccess) userInfo:nil repeats:NO];
        _alertForConnecting = alert;
    }
    return _alertForConnecting;
    
}

- (void)showAlertWithConnectSuccess{
    
    [self.alertForConnecting hideView];
    self.alertForConnecting = nil;
    self.brightnessSlider.enabled = YES;
    
    SCLAlertView *alert = self.newAlert;
    [alert showSuccess:self title:@"连接成功" subTitle:@"蓝牙灯连接成功!" closeButtonTitle:nil duration:1.0f];
    
}

- (void)showAlertWithWhetherDisconnectWithAction:(void (^)())action deviceName:(NSString *)deviceName{
    
    SCLAlertView *alert = self.newAlert;
    
    [alert addButton:@"断开" actionBlock:^{
        NSLog(@"点击了断开");
        action();
        
    }];
    NSString *subTitle = [NSString stringWithFormat:@"是否断开与\"%@\"的连接?",deviceName];
    [alert showQuestion:self title:@"是否断开" subTitle:subTitle closeButtonTitle:@"取消" duration:0.0f];
    
}

- (void)showAlertWithColorAnimation{
    
    SCLAlertView *alert = self.newAlert;
    
    [alert addButton:@"三色跳变" actionBlock:^{
        NSLog(@"点击了三色跳变");
        [self.iPhone letSmartLampPerformColorAnimation:ColorAnimationSaltusStep3];
        [self setPaletteEnable:NO];
    }];
    [alert addButton:@"七色跳变" actionBlock:^{
        NSLog(@"点击了七色跳变");
        [self.iPhone letSmartLampPerformColorAnimation:ColorAnimationSaltusStep7];
        [self setPaletteEnable:NO];
     }];
    
    [alert addButton:@"渐变" actionBlock:^{
        NSLog(@"点击了渐变");
        [self.iPhone letSmartLampPerformColorAnimation:ColorAnimationGratation];
        [self setPaletteEnable:NO];
    }];
    
    
    [alert showCustom:self
                image:[UIImage imageNamed:@"create_new"]
                color:self.tintColor
                title:@"动画模式"
             subTitle:@"请选择动画模式"
     closeButtonTitle:@"取消"
             duration:0.0f];

    
}

- (void)setPaletteEnable:(BOOL)isEnable{
    
    self.palette.alpha = isEnable;
    [self.palette setUserInteractionEnabled:isEnable];
    if (isEnable) {
        [self.animationButton setTitle:@"动画" forState:UIControlStateNormal];
    } else{
        [self.animationButton setTitle:@"调色" forState:UIControlStateNormal];
    }
    
    
}


#pragma mark - 🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵 数据源和代理



- (NSString *)slider:(ASValueTrackingSlider *)slider stringForValue:(float)value{
    
    return [NSString stringWithFormat:@"%.0f",slider.value];
    
}

- (void)sliderWillDisplayPopUpView:(ASValueTrackingSlider *)slider{
    
    
}




@end
