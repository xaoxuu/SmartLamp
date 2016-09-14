//
//  HomeViewController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-13.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "HomeViewController.h"
#import "ATHeaderView.h"
#import "ATToolBar.h"


@interface HomeViewController ()

// header view
@property (weak, nonatomic) IBOutlet ATHeaderView *headerView;
// toolbar view
@property (weak, nonatomic) IBOutlet UIView *atToolbarView;
// toolbar
@property (strong, nonatomic) ATToolBar *atToolbar;
// content view
@property (weak, nonatomic) IBOutlet UIView *contentView;
// brightness slider
@property (weak, nonatomic) IBOutlet UISlider *brightSlider;

@end

@implementation HomeViewController

#pragma mark - view events

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // setup Toolbar
    [self setupToolBar];
    // subscribeRAC
    [self subscribeRAC];
    // handle events
    [self handleSliderEvents];
    
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


// handle slider events
- (void)handleSliderEvents{
    
    // touch down
    [[self.brightSlider rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(UISlider *sender) {
        atCentralManager.currentProfiles.colorAnimation = ColorAnimationNone;
        [atCentralManager.didPerformColorAnimation sendNext:@NO];
    }];
    // value changed
    [[self.brightSlider rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISlider *sender) {
        atCentralManager.currentProfiles.brightness = sender.value;
        [atCentralManager letSmartLampUpdateBrightness];
    }];
    
}


#pragma mark - private methods

// subscribeRAC
- (void)subscribeRAC{
    
    // connect success
    [atCentralManager.didConnectSuccess subscribeNext:^(id x) {
        [self updateUIIfSmartLampIsTurnOn:YES];
    }];
    // disconnect
    [atCentralManager.didDisconnect subscribeNext:^(id x) {
        [self updateUIIfSmartLampIsTurnOn:NO];
    }];
    // turn on
    [atCentralManager.didTurnOn subscribeNext:^(id x) {
        [self updateUIIfSmartLampIsTurnOn:YES];
    }];
    // turn off
    [atCentralManager.didTurnOff subscribeNext:^(id x) {
        [self updateUIIfSmartLampIsTurnOn:NO];
    }];
    // subscribe select button signal
    [self.didSelected subscribeNext:^(id x) {
        self.atToolbar.selectIndex(0);
    }];
    
}


// update UI
- (void)updateUIIfSmartLampIsTurnOn:(BOOL)isYes{
    // set user interaction enabled
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

// setup toolbar
- (void)setupToolBar{
    
    NSArray *views = @[[[[NSBundle mainBundle] loadNibNamed:@"StatusView" owner:nil options:nil] lastObject],
    [[[NSBundle mainBundle] loadNibNamed:@"ColorModeView" owner:nil options:nil] lastObject],
    [[[NSBundle mainBundle] loadNibNamed:@"TimerView" owner:nil options:nil] lastObject]];
    
    self.atToolbar = [ATToolBar toolbarWithTitleView:self.atToolbarView titles:@[@"状态",@"颜色",@"定时"] titleColor:atColor.backgroundColor contentView:self.contentView contents:views action:^(NSUInteger index) {
        
    }];
    
}



@end
