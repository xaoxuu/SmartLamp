//
//  HomeViewController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-04-21.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "HomeViewController.h"
#import "ATCentralManager.h"
#import "UIImage+getColorAtPixel.h"
#import "ASValueTrackingSlider.h"

@interface HomeViewController () <ASValueTrackingSliderDataSource,ASValueTrackingSliderDelegate>

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

@property (weak, nonatomic) IBOutlet UIImageView *palette;

// 定时器
@property (strong, nonatomic) NSTimer *myTimer;
@property (assign, nonatomic) CGFloat myTimerProgress;


@property (assign, nonatomic) BOOL lastConnectStatus;

@property (strong, nonatomic) UIImageView *paletteInAlertView;
@property (strong, nonatomic) UIImageView *circle;


@property (weak, nonatomic) IBOutlet UISegmentedControl *bottomButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *test1;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
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

    
    
//    [self getColor:touches];
//    [self getColorWithMath:touches];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.palette];
    
//    UIColor *color = [self.palette.image colorAtPixel:point andContext:self.palette];
    UIColor *color = [self.palette.image getColorAtPixel:point inImageView:self.palette];
    //设置颜色到控件上
    self.backgroundView.backgroundColor = color;
    
    [self.circle removeFromSuperview];
    self.circle = [[UIImageView alloc] initWithFrame:(CGRect){0,0,30,30}];
    self.circle.image = [UIImage imageNamed:@"Circle"];
    [self.circle setUserInteractionEnabled:NO];
    CGPoint circlePoint = [touch locationInView:self.palette];
    CGSize circleSize = self.circle.frame.size;
    circlePoint.x -= circleSize.width * 0.5;
    circlePoint.y -= circleSize.height * 0.5;
    self.circle.frame = (CGRect){circlePoint,circleSize};

    [self.palette addSubview:self.circle];
    
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
//    [self getColor:touches];
//    [self getColorWithMath:touches];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.palette];
    
//    UIColor *color = [self.palette.image colorAtPixel:point andContext:self.palette];

    UIColor *color = [self.palette.image getColorAtPixel:point inImageView:self.palette];
    //设置颜色到控件上
    self.backgroundView.backgroundColor = color;
    
    [self.circle removeFromSuperview];
    self.circle = [[UIImageView alloc] initWithFrame:(CGRect){0,0,30,30}];
    self.circle.image = [UIImage imageNamed:@"Circle"];
    [self.circle setUserInteractionEnabled:NO];
    CGPoint circlePoint = [touch locationInView:self.palette];
    CGSize circleSize = self.circle.frame.size;
    circlePoint.x -= circleSize.width * 0.5;
    circlePoint.y -= circleSize.height * 0.5;
    self.circle.frame = (CGRect){circlePoint,circleSize};
    
    [self.palette addSubview:self.circle];

    
}

//- (void)getColorWithMath:(NSSet<UITouch *> *)touches{
//    
//    UITouch *touch = [touches anyObject];
//    CGPoint point = [touch locationInView:self.palette];
//    double x = point.x-100;
//    double y = 100-point.y;
//    int r2;
//    
//    r2 = (point.x-100)*(point.x-100) + (point.y-100)*(point.y-100);
//    if (r2 > 100*100) {
//        return;
//    }
//
//    
//    [self.circle removeFromSuperview];
//    self.circle = [[UIImageView alloc] initWithFrame:(CGRect){0,0,30,30}];
//    self.circle.image = [UIImage imageNamed:@"Circle"];
//    [self.circle setUserInteractionEnabled:NO];
//    CGPoint circlePoint = [touch locationInView:self.palette];
//    CGSize circleSize = self.circle.frame.size;
//    circlePoint.x -= circleSize.width * 0.5;
//    circlePoint.y -= circleSize.height * 0.5;
//    self.circle.frame = (CGRect){circlePoint,circleSize};
//    
//    [self.palette addSubview:self.circle];
//    
//
//    
//    
//}

#pragma mark - 🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀 控件事件

// 开关按钮
- (IBAction)powerButton:(UIButton *)sender {
    
    [self showAlertWithRGB];
//    [self showAlertWithConnecting];
    
    
    
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


- (IBAction)bluetoothButton:(UIButton *)sender {
    // 如果已经连接了 就弹出是否断开
    if (self.iPhone.isConnecting) {
        [self showAlertWithWhetherDisconnectWithAction:^{
            [self.iPhone disConnectSmartLamp];
        } deviceName:[[ATFileManager readFile:ATFileTypeDevice] lastObject]];
    } else{
        [self searchDevice];
    }
    
    
}



// RGB滑块和亮度滑块 值改变
- (IBAction)sliderRGB:(UISlider *)sender {
    
//    // 更新蓝牙灯状态(颜色/亮度/动画)
//    [self updateSmartLampStatus];
//    
//    // 更新视图
//    [self updateLayer];
//    // 如果滑动的是亮度条, 更新image
//    if (sender == self.brightnessSlider) {
//        [self updateImage];
//    }
    
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
    
    // 如果现在状态是已连接
    if (self.iPhone.isConnecting) {
        
        // 如果之前是未连接, 就弹出提示"已连接"
        if (!self.lastConnectStatus) {
            
            [self showAlertWithConnectSuccess];
            
        }
        
        self.lastConnectStatus = YES;
        [self setSliderEnable:YES];
        
    } else{
        
        self.lastConnectStatus = NO;
        [self setSliderEnable:NO];
        
    }
    
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
        self.bluetoothButton.enabled = YES;
        
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
    [self.powerButton     buttonState:ATButtonStateUp];
    [self.bluetoothButton buttonState:ATButtonStateUp];
    
    self.lampLogo.alpha = 0;
    self.palette.layer.cornerRadius = 100;
    self.palette.layer.borderWidth = 3;
    self.palette.layer.borderColor = [UIColor whiteColor].CGColor;
    self.palette.layer.shadowOffset = (CGSize){0,0};
    self.palette.layer.shadowRadius = 100.0;
    self.palette.layer.shadowOpacity = 1.0;
    
    [self setSliderEnable:NO];

    
    // ==================== [ 自动连接 ] ==================== //
    [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(searchDevice) userInfo:nil repeats:NO];
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
    
//    self.redSlider.enabled = isEnable;
//    self.greenSlider.enabled = isEnable;
//    self.blueSlider.enabled = isEnable;
//    self.brightnessSlider.enabled = isEnable;
    
}

// 更新视图
- (void)updateLayer{
    
    float alpha = _brightnessSlider.value;
    float red   = _redSlider.value;
    float green = _greenSlider.value;
    float blue  = _blueSlider.value;
    
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
    
    self.palette.layer.shadowColor = [UIColor colorWithRed:red green:green blue:blue alpha:1].CGColor;
    self.palette.layer.shadowRadius = 200 * alpha + 5;
    
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


// 保存缓存
- (void)saveCache{
    
    self.aProfiles.red = _redSlider.value;
    self.aProfiles.green = _greenSlider.value;
    self.aProfiles.blue = _blueSlider.value;
    self.aProfiles.brightness = _brightnessSlider.value;
    
    [ATFileManager saveCache:self.aProfiles];
    
}


#pragma mark 🚫 懒加载

// 已经连接过的设备列表
-(NSArray *)connectedDevice{
    
    if (!_connectedDevice.count) {
        _connectedDevice = [ATFileManager readFile:ATFileTypeDevice];
    }
    return _connectedDevice;
    
}

-(UIImageView *)paletteInAlertView{
    
    if (!_paletteInAlertView) {
        
        _paletteInAlertView = [[UIImageView alloc] initWithFrame:(CGRect){0,0,216,216}];
        _paletteInAlertView.image = [UIImage imageNamed:@"Palette"];
        
        
        _paletteInAlertView.layer.cornerRadius = 108;
        _paletteInAlertView.layer.borderWidth = 3;
        _paletteInAlertView.layer.borderColor = [UIColor whiteColor].CGColor;
//        _paletteInAlertView.layer.shadowColor = self.tintColor.CGColor;
        _paletteInAlertView.layer.shadowOffset = (CGSize){0,0};
        _paletteInAlertView.layer.shadowRadius = 2.0;
        _paletteInAlertView.layer.shadowOpacity = 0.3f;
    }
    return _paletteInAlertView;
    
}

#pragma mark 🚫 AlertView

- (SCLAlertView *)showAlertWithRGB{
    
    SCLAlertView *alert = self.newAlert;
    
    [alert addCustomView:self.paletteInAlertView];
    
    
    [alert addButton:@"渐变动画" actionBlock:^{
        [self.iPhone letSmartLampPerformColorAnimation:ColorAnimationGratation];
    }];
    
    [alert showCustom:self
                image:[UIImage imageNamed:@"Icon_Palette"]
                color:self.tintColor
                title:@"调色板"
             subTitle:nil
     closeButtonTitle:@"完成"
             duration:0.0f];
    
    
    
    return alert;
    
}

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
        self.bluetoothButton.enabled = YES;
        [self.iPhone stopScan];
        [self.myTimer invalidate];
        [self.myTimer fire];
        self.myTimerProgress = 0;
        
    }];
    
    
    // 第一次创建时自动连接设为NO
    if (!_alertForScaning) {
        self.isAutoConnect = NO;
    }
    self.bluetoothButton.enabled = NO;

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
    [self setSliderEnable:YES];
    
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








- (NSString *)slider:(ASValueTrackingSlider *)slider stringForValue:(float)value{
    
    return [NSString stringWithFormat:@"%f",100 * slider.value];
    
}

- (void)sliderWillDisplayPopUpView:(ASValueTrackingSlider *)slider{
    
    
    
}


@end
