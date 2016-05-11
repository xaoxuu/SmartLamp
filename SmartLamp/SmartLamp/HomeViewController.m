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



@property (weak, nonatomic) IBOutlet UIButton *lampLogo;

@property (strong, nonatomic) IBOutlet UIView *backgroundView;


@property (weak, nonatomic) IBOutlet UISlider *brightnessSlider;
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;

@property (weak, nonatomic) IBOutlet UIButton *powerButton;

@property (weak, nonatomic) IBOutlet UIButton *bluetoothButton;

@property (weak, nonatomic) IBOutlet UIView *tabBarBackground;

@property (strong, nonatomic) NSArray *connectedDevice;

@property (strong, nonatomic) NSTimer *myTimer;
@property (assign, nonatomic) CGFloat myTimerProgress;

@end

@implementation HomeViewController

- (IBAction)btn1:(UIButton *)sender {
    
//    [self autoConnect];
    
}

- (IBAction)btn2:(UIButton *)sender {
    
//    [self.iPhone connectSmartLampOrNot:NO];
}

- (IBAction)btn3:(UIButton *)sender {
    [self.iPhone letSmartLampPowerOnOrOff:NO];
}
- (IBAction)btn4:(UIButton *)sender {
    [self.iPhone letSmartLampPowerOnOrOff:YES];
}

- (IBAction)btn5:(UIButton *)sender {
    [self.iPhone letSmartLampPerformColorAnimation: ColorAnimationSaltusStep3];
}
- (IBAction)btn6:(UIButton *)sender {
    [self.iPhone letSmartLampPerformColorAnimation: ColorAnimationSaltusStep7];
}

- (IBAction)btn7:(UIButton *)sender {
    [self.iPhone letSmartLampPerformColorAnimation: ColorAnimationGratation];
}
- (IBAction)btn8:(UIButton *)sender {
    [self.iPhone letSmartLampPerformColorAnimation: ColorAnimationNone];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self prefersStatusBarHidden];
    
    [self initialization];
    [self updateFrame];
    // 扫描设备
    [self searchBluetoothDevice];

}
- (BOOL)prefersStatusBarHidden{
    
    return YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
//    [self.iPhone connectSmartLampOrNot:YES];
    [self updateFrame];
    
    

}

-(void)viewDidAppear:(BOOL)animated{
    
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [self saveCache];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)powerButton:(UIButton *)sender {
    
    // 如果灯是开着的, 就关灯
    if (self.brightnessSlider.value) {
        self.aProfiles.brightness = 0;
        [self.brightnessSlider setValue:0 animated:YES];
        [self.powerButton setImage:[UIImage imageNamed:@"powerOff"] forState:UIControlStateNormal];
        [self.iPhone letSmartLampPowerOnOrOff:NO];
        
    } else{
        self.aProfiles.brightness = 1;
        [self.brightnessSlider setValue:1 animated:YES];
        [self.powerButton setImage:[UIImage imageNamed:@"powerOn"] forState:UIControlStateNormal];
        [self.iPhone letSmartLampPowerOnOrOff:YES];
    }
    
    
}

- (IBAction)bluetoothButton:(UIButton *)sender {
    
    
    
}


- (IBAction)brightnessSlider:(UISlider *)sender {
    
    self.aProfiles.colorAnimation = ColorAnimationNone;
    
    // 如果灯是开着的
    if (self.brightnessSlider.value) {
        self.powerButton.imageView.image = [UIImage imageNamed:@"powerOn"];
    } else{
        self.powerButton.imageView.image = [UIImage imageNamed:@"powerOff"];
    }
    
    [self refreshRGBValue];
    
}



- (IBAction)redSlider:(UISlider *)sender {
    
    self.aProfiles.colorAnimation = ColorAnimationNone;
    [self refreshRGBValue];
    
}




- (IBAction)greenSlider:(UISlider *)sender {
    
    self.aProfiles.colorAnimation = ColorAnimationNone;
    [self refreshRGBValue];
    
}



- (IBAction)blueSlider:(UISlider *)sender {
    
    self.aProfiles.colorAnimation = ColorAnimationNone;
    [self refreshRGBValue];
    
}


#pragma mark - 私有方法 🚫🚫🚫🚫🚫🚫🚫🚫🚫🚫

- (void)initialization{
    
    [self.powerButton     buttonState:ATButtonStateUp];
    [self.bluetoothButton buttonState:ATButtonStateUp];
    
}

- (void)updateFrame{
    
    self.aProfiles = nil;
    // 如果灯是开着的
    if (self.brightnessSlider.value) {
        [self.powerButton setImage:[UIImage imageNamed:@"powerOn"] forState:UIControlStateNormal];
    } else{
        [self.powerButton setImage:[UIImage imageNamed:@"powerOff"] forState:UIControlStateNormal];
    }
    
    [self.redSlider setValue:self.aProfiles.red animated:YES];
    [self.greenSlider setValue:self.aProfiles.green animated:YES];
    [self.blueSlider setValue:self.aProfiles.blue animated:YES];
    [self.brightnessSlider setValue:self.aProfiles.brightness animated:YES];
    
    [self refreshRGBValue];
    
}

// 自动连接
- (void)autoConnect{
    
//    [NSThread sleepForTimeInterval:2];
    // 如果没有连接过任何设备, 就跳转到蓝牙连接界面
    if (!self.connectedDevice.count) {
        
        ViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"BluetoothViewController"];
        [self.navigationController pushViewController:view animated:YES];
        
    }
    // 如果保存的有连接过的设备, 优先从已连接设备中连接
    else{
        
        
        // 如果没有扫描到设备, 不做任何处理
//        if (!self.smartLampList.count) return;
        
        // 如果扫描到了蓝牙灯
        NSArray *plist = [ATFileManager readFile:ATFileTypeDevice];
        NSArray *deviceList = self.smartLampList;
        
        for (CBPeripheral *device in deviceList) {
            
            if ([plist containsObject:device.name]) {
                
                [self.iPhone connectSmartLamp:device];
                
            }
            
        }
        
    }
    
}

- (void)refreshRGBValue{
    

        
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
    
    // 灯的颜色
//    _lampLogo.tintColor = darkStyle;
    
    // 刷新Slider的颜色
    _brightnessSlider.minimumTrackTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:alpha];
    _redSlider.minimumTrackTintColor = [UIColor colorWithRed:1 green:1-red blue:1-red alpha:alpha];
    _greenSlider.minimumTrackTintColor = [UIColor colorWithRed:1-green green:1 blue:1-green alpha:alpha];
    _blueSlider.minimumTrackTintColor = [UIColor colorWithRed:1-blue green:1-blue blue:1 alpha:alpha];
    
    
    // 给蓝牙设备发送指令
    // 如果有动画, 就显示动画效果
    if (self.aProfiles.colorAnimation) {
        [self.iPhone letSmartLampPerformColorAnimation:self.aProfiles.colorAnimation];
    } else{// 否则就显示单色模式
        [self.iPhone letSmartLampSetColorWithR:red G:green B:blue andBright:alpha];
    }
    
    
    
    
    
}



- (void)saveCache{
    
    self.aProfiles.red = _redSlider.value;
    self.aProfiles.green = _greenSlider.value;
    self.aProfiles.blue = _blueSlider.value;
    self.aProfiles.brightness = _brightnessSlider.value;
    
    [ATFileManager saveCache:self.aProfiles];
    
}





// 搜索设备
- (void)searchBluetoothDevice{
    
    
    // ==================== [ 搜索前的准备 ] ==================== //
    [self.iPhone readyForScan];
    self.myTimerProgress = 1;
    
    // 每次点击搜索按钮都清空上一次的数据, 并重新搜索新的蓝牙列表数据
//    self.smartLampList = nil;
    
//    [self performSelector:@selector(refreshTableViewAction:) withObject:self.refreshControl];
    // ==================== [ 搜索 ] ==================== //
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scaning:) userInfo:nil repeats:YES];
    
}


- (void)scaning:(id)sender{
    
    self.myTimerProgress += 1.0;
    
    // 调用模型方法, 搜索蓝牙列表
    self.smartLampList = [self.iPhone searchSmartLamp];
    
    if (self.smartLampList.count||self.myTimerProgress>3) {
        
        self.myTimerProgress = 0;
        [self.myTimer invalidate];
        [self.myTimer fire];
        
        if (self.smartLampList.count) [self.iPhone connectSmartLamp:self.smartLampList[0]];
        if (self.myTimerProgress>3) {
            ViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"BluetoothViewController"];
            [self.navigationController pushViewController:view animated:YES];
        }
        [self.iPhone stopScan];
        
    }
    
}

-(NSArray *)connectedDevice{
    
    if (!_connectedDevice.count) {
        _connectedDevice = [ATFileManager readFile:ATFileTypeDevice];
    }
    return _connectedDevice;
    
}

@end
