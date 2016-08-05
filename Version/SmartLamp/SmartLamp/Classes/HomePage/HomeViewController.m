//
//  HomeViewController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-13.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "HomeViewController.h"

#import "ATToolBar.h"

@interface HomeViewController () <UIScrollViewDelegate>
// 头视图
@property (weak, nonatomic) IBOutlet UIView *headerView;
// app标题
@property (weak, nonatomic) IBOutlet UILabel *appTitle;
// 概览区域
@property (weak, nonatomic) IBOutlet UIView *overView;
// 设备状态图
@property (weak, nonatomic) IBOutlet UIImageView *deviceStatusImage;
// 设备名
@property (weak, nonatomic) IBOutlet UILabel *deviceName;
// 设备状态
@property (weak, nonatomic) IBOutlet UILabel *deviceStatus;
// 内容区域
@property (weak, nonatomic) IBOutlet UIView *contentView;
// 亮度滑块
@property (weak, nonatomic) IBOutlet UISlider *brightSlider;
// toolbar
@property (weak, nonatomic) IBOutlet UIView *atToolbarView;
// toolbar
@property (strong, nonatomic) ATToolBar *atToolbar;
// scrollview
@property (strong, nonatomic) UIScrollView *contentScrollView;
// 开关
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

// 状态视图
@property (strong, nonatomic) StatusView *statusView;
// 颜色视图
@property (strong, nonatomic) ColorModeView *colorModeView;
// 定时视图
@property (strong, nonatomic) TimerView *timerView;

@end

@implementation HomeViewController

#pragma mark - 视图事件

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 初始化UI
    [self _initUI];
    // 设置Toolbar
    [self _setupToolBar];
    // 设置内容视图
    [self _setupContentView];
    // 设置通知
    [self _setupNotification];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [ATFileManager saveCache:atCentralManager.currentProfiles];
}

#pragma mark - 控件事件
// 概览视图点击
- (IBAction)overviewTapped:(UIButton *)sender {
    // 开始扫描或断开连接
    [atCentralManager connectOrDisconnect];
}
// 亮度滑块按下
- (IBAction)brightSliderTouchDown:(UISlider *)sender {
    atCentralManager.currentProfiles.colorAnimation = ColorAnimationNone;
}
// 亮度滑块位置改变
- (IBAction)brightSliderChanged:(UISlider *)sender {
    atCentralManager.currentProfiles.brightness = sender.value;
    [atCentralManager letSmartLampUpdateBrightness];
}
// 开关按钮
- (IBAction)switchButtonTouchUp:(UISwitch *)sender {
    // 开关灯
    [self.switchButton setOn:!sender.on animated:YES];
    [atCentralManager letSmartLampTurnOnIf:!sender.on];
    
}

#pragma mark - 私有方法

// 初始化UI
- (void)_initUI{
    // 头视图
    self.appTitle.tintColor = atColor.themeColor_dark;
    self.headerView.backgroundColor = atColor.themeColor;
    self.headerView.tintColor = atColor.themeColor_dark;
    self.headerView.layer.shadowOffset = CGSizeMake(0, 0);
    self.headerView.layer.shadowRadius = 3.0;
    self.headerView.layer.shadowOpacity = 0.7;
    // 开关按钮
    self.switchButton.tintColor = atColor.themeColor_light;
    self.switchButton.onTintColor = atColor.themeColor_light;
    self.switchButton.thumbTintColor = atColor.backgroundColor;
    self.switchButton.transform = CGAffineTransformMakeScale(0.7, 0.7);
    // 亮度滑块
    self.brightSlider.minimumTrackTintColor = atColor.themeColor;
    [self.brightSlider setThumbImage:[UIImage imageNamed:@"home_thumb"] forState:UIControlStateNormal];
}

// 设置通知
- (void)_setupNotification{
    
    [atNotificationCenter addObserver:self selector:@selector(receiveConnectNotification:) name:NOTI_BLE_CONNECT object:nil];
    [atNotificationCenter addObserver:self selector:@selector(receiveStatusNotification:) name:NOTI_BLE_STATUS object:nil];
    
}


// 连接状态通知
- (void)receiveConnectNotification:(NSNotification *)noti{
    if ([noti.name isEqualToString:NOTI_BLE_CONNECT]) {
        NSString *device = atCentralManager.connectedPeripheral.name;
        // 连接成功
        if ([noti.object isEqualToString:NOTI_BLE_CONNECT_SUCCESS]) {
            self.deviceStatusImage.image = [UIImage imageNamed:@"home_power"];
            self.deviceName.text = device;
            self.deviceStatus.text = [NSString stringWithFormat:@"已连接至:%@",device];
            [self updateUIIfSmartLampIsTurnOn:YES];
            
        }
        // 连接失败
        else if ([noti.object isEqualToString:NOTI_BLE_CONNECT_FAIL]){
            
        }
        // 断开连接
        else if([noti.object isEqualToString:NOTI_BLE_CONNECT_DISCONNECT]){
            self.deviceStatusImage.image = [UIImage imageNamed:@"home_disconnect"];
            self.deviceName.text = @"未连接设备";
            self.deviceStatus.text = [NSString stringWithFormat:@"已断开连接"];
            [self updateUIIfSmartLampIsTurnOn:NO];
            
        }
    }
}
// 灯状态通知
- (void)receiveStatusNotification:(NSNotification *)noti{
    if ([noti.name isEqualToString:NOTI_BLE_STATUS]) {
        // 开灯
        if ([noti.object isEqualToString:NOTI_BLE_STATUS_TURNON]) {
            [self updateUIIfSmartLampIsTurnOn:YES];
            [self.switchButton setOn:YES animated:YES];
        }
        // 关灯
        else if ([noti.object isEqualToString:NOTI_BLE_STATUS_TURNOFF]){
            [self updateUIIfSmartLampIsTurnOn:NO];
            [self.switchButton setOn:NO animated:YES];
        }
        // 状态改变
        else if([noti.object isEqualToString:NOTI_BLE_STATUS_CHANGE]){
            
            
        }
    }
}


// 更新UI
- (void)updateUIIfSmartLampIsTurnOn:(BOOL)isYes{
    // 设置用户交互
    self.contentView.userInteractionEnabled = self.brightSlider.userInteractionEnabled = isYes;
    if (isYes) {
        [UIView animateWithDuration:1.0f animations:^{
            [self.brightSlider setValue:atCentralManager.currentProfiles.brightness animated:YES];
            self.contentView.alpha = self.brightSlider.alpha = 1.0;
            
        }];
    } else{
        [UIView animateWithDuration:1.0f animations:^{
            [self.brightSlider setValue:0.0f animated:YES];
            self.contentView.alpha = self.brightSlider.alpha = 0.3;
        }];
    }
}

// 设置toolbar
- (void)_setupToolBar{
    
    __weak HomeViewController *weakSelf = self;
    self.atToolbar = [[ATToolBar alloc] initWithFrame:self.atToolbarView.bounds titles:@[@"状态",@"颜色",@"定时"] action:^(NSUInteger index) {
        CGRect rect = weakSelf.contentView.bounds;
        rect.origin.x += index * rect.size.width;
        [weakSelf.contentScrollView scrollRectToVisible:rect animated:YES];
    }];
    [self.atToolbarView addSubview:self.atToolbar];
    
}

// 设置内容视图
- (void)_setupContentView{
    // 设置ScrollView
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.scrollEnabled = YES;
    self.contentScrollView.delegate = self;
    [self.contentView addSubview:self.contentScrollView];
    const CGFloat contentWidth = 3 * self.contentView.frame.size.width;
    self.contentScrollView.contentSize = CGSizeMake(contentWidth, self.contentScrollView.contentSize.height);
    self.contentScrollView.pagingEnabled = YES;
    // scroll view 的内容
    NSArray *nibArray = @[@"StatusView",@"ColorModeView",@"TimerView"];
    for (int i=0; i<3; i++) {
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:nibArray[i] owner:nil options:nil] lastObject];
        CGRect frame = view.frame;
        frame.origin.x = i * frame.size.width;
        view.frame = frame;
        [self.contentScrollView addSubview:view];
    }
    self.statusView = self.contentScrollView.subviews[0];
    self.colorModeView = self.contentScrollView.subviews[1];
    self.timerView = self.contentScrollView.subviews[2];
    
}

#pragma mark - 🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵 数据源和代理

// 拖拽结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.atToolbar selectIndex:(NSUInteger)scrollView.contentOffset.x/SCREEN_W];
}


@end
