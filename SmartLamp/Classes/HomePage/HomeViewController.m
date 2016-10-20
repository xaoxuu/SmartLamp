//
//  HomeViewController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-13.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "HomeViewController.h"
// child
#import "ATHeaderView.h"
#import "StatusView.h"
#import "ColorModeView.h"
#import "TimerView.h"

#import "ATTabBarView+MD.h"

@interface HomeViewController ()

// header view
@property (weak, nonatomic) IBOutlet ATHeaderView *headerView;
// toolbar view
@property (weak, nonatomic) IBOutlet UIView *atToolbarView;
// toolbar
@property (strong, nonatomic) ATTabBarView *atToolBar;
// content view
@property (weak, nonatomic) IBOutlet UIView *contentView;
// status view
@property (strong, nonatomic) StatusView *statusView;


// brightness slider
@property (weak, nonatomic) IBOutlet UISlider *brightSlider;



@end

@implementation HomeViewController

#pragma mark - view events

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [self.brightSlider at_materialSliderWithTintColor:UIColor.theme image:@"home_thumb"];
    // setup Toolbar
    [self setupToolBar];
    // subscribeRAC
    [self subscribeRAC];
    // slider
    [self setupSlider];
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.statusView updateUI];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [ATFileManager saveCache:atCentral.aProfiles];
}

// setup slider
- (void)setupSlider{
    // init and add to superview
    self.brightSlider.superview.layer.shadowColor = [UIColor whiteColor].CGColor;
    
    self.brightSlider.superview.layer.shadowOffset = CGSizeMake(0, -10);
    self.brightSlider.superview.layer.shadowRadius = 5;
    self.brightSlider.superview.layer.shadowOpacity = 1;
    // touch down
    [self.brightSlider at_addTouchDownHandler:^(UISlider * _Nonnull sender) {
        atCentral.aProfiles.colorMode = ATColorModeNone;
        [atCentral.didColorfulMode sendNext:@NO];
    }];
    
    // value changed
    [self.brightSlider at_addValueChangedHandler:^(UISlider * _Nonnull sender) {
        atCentral.aProfiles.brightness = sender.value;
        atCentral.letSmartLampUpdateBrightness();
    }];
    
}

#pragma mark - private methods

// subscribeRAC
- (void)subscribeRAC{
    
    // connect success
    [atCentral.didConnect subscribeNext:^(id x) {
        if ([x boolValue]) {
            [self updateUIIfSmartLampTurnOn];
        } else{
            [self updateUIIfSmartLampTurnOff];
        }
        
    }];
    // turn on
    [atCentral.didTurnOn subscribeNext:^(id x) {
        if ([x boolValue]) {
            [self updateUIIfSmartLampTurnOn];
        } else{
            [self updateUIIfSmartLampTurnOff];
        }
    }];
    [atCentral.didColorfulMode subscribeNext:^(id x) {
        if ([x boolValue]) {
            [self updateUIIfSmartLampTurnOn];
        }
    }];
    // subscribe select button signal
    [self.didSelected subscribeNext:^(id x) {
        self.atToolBar.selectIndex(0);
    }];
    
}


// update UI
- (void)updateUIIfSmartLampTurnOn{
    // set user interaction enabled
    self.contentView.userInteractionEnabled = self.brightSlider.userInteractionEnabled = YES;
    [UIView animateWithDuration:1.0f animations:^{
        [self.brightSlider setValue:atCentral.aProfiles.brightness animated:YES];
        self.contentView.alpha = self.brightSlider.alpha = 1.0;
    }];
}

// update UI
- (void)updateUIIfSmartLampTurnOff{
    // set user interaction enabled
    self.contentView.userInteractionEnabled = self.brightSlider.userInteractionEnabled = NO;
    [UIView animateWithDuration:1.0f animations:^{
        [self.brightSlider setValue:0.0f animated:YES];
        self.contentView.alpha = self.brightSlider.alpha = 0.3;
    }];
}

// setup toolbar
- (void)setupToolBar{
    
    self.statusView = [[[NSBundle mainBundle] loadNibNamed:@"StatusView" owner:nil options:nil] lastObject];
    NSArray *views = @[self.statusView,
    [[[NSBundle mainBundle] loadNibNamed:@"ColorModeView" owner:nil options:nil] lastObject],
    [[[NSBundle mainBundle] loadNibNamed:@"TimerView" owner:nil options:nil] lastObject]];
    
    self.contentView.width = kScreenW;
    self.contentView.height = kScreenH - self.contentView.top - 90;
    self.atToolBar = [ATTabBarView tabBarWithTitleView:self.atToolbarView titles:@[@"状态",@"颜色",@"定时"] titleColor:atColor.white rippleColor:atColor.theme.darkRatio(0.2) contentView:self.contentView content:^UIView *(NSUInteger index) {
        return views[index];
    } action:^(NSUInteger index) {
        
    }];
    
    
}


@end
