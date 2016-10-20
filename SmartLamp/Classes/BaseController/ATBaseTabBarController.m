//
//  ATBaseTabBarController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-13.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

// support file
#import "ATBaseTabBarController.h"
#import "UITabBarController+BaseVC.h"

// child
#import "ATBaseNavigationController.h"
#import "HomeViewController.h"
#import "SceneViewController.h"
#import "DeviceViewController.h"
#import "DiscoverViewController.h"

@interface ATBaseTabBarController () 

// controllers
@property (strong, nonatomic) HomeViewController *homeVC;
@property (strong, nonatomic) SceneViewController *sceneVC;
@property (strong, nonatomic) DeviceViewController *deviceVC;
@property (strong, nonatomic) DiscoverViewController *discoverVC;

// center button
@property (strong, nonatomic) UIButton *centerButton;


@end

@implementation ATBaseTabBarController

#pragma mark - view events

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // default style and tint color
    [self at_setupBarStyle:ATBarStyleLightBlur tintColor:atColor.theme];
    // child controllers
    [self setupControllers];
    // setup tabbar
    [self at_setupTabBar:self.atTabBar];
    // subscribeRAC
    [self subscribeRAC];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - private methods

// setup controllers
- (void)setupControllers{
    
    self.homeVC = [[HomeViewController alloc] init];
    self.sceneVC = [[SceneViewController alloc] init];
    self.deviceVC = [[DeviceViewController alloc] init];
    self.discoverVC = [[DiscoverViewController alloc] init];
    
    [self at_setupChlidController:self.homeVC title:@"主页" image:@"tabbar_control" selectedImage:@"tabbar_control_HL"];
    [self at_setupChlidController:self.sceneVC title:@"情景" image:@"tabbar_scene" selectedImage:@"tabbar_scene_HL"];
    [self at_setupChlidController:self.deviceVC title:@"设备" image:@"tabbar_device" selectedImage:@"tabbar_device_HL"];
    [self at_setupChlidController:self.discoverVC title:@"发现" image:@"tabbar_discover" selectedImage:@"tabbar_discover_HL"];
    
}



// subscribe rac
- (void)subscribeRAC{
    // scannable
    [atCentral.didScannable subscribeNext:^(id x) {
        self.centerButton.enabled = [x boolValue];
    }];
    // scaning
    [atCentral.didScaning subscribeNext:^(id x) {
        if ([x boolValue]) {
            // scan
            self.centerButton.enabled = NO;
            [self.atTabBar startAnimation];
        } else{
            // stop scan
            self.centerButton.enabled = YES;
            [self.atTabBar stopAnimation];
        }
        
    }];
    // connect
    [atCentral.didConnect subscribeNext:^(id x) {
        if ([x boolValue]) {
            [self.centerButton setImage:[UIImage imageNamed:@"tabbar_lamp"] forState:UIControlStateNormal];
            [self.centerButton setImage:[UIImage imageNamed:@"tabbar_lamp_HL"] forState:UIControlStateSelected];
        } else{
            [self.centerButton setImage:[UIImage imageNamed:@"tabbar_bluetoothHL"] forState:UIControlStateNormal];
            [self.centerButton setImage:[UIImage imageNamed:@"tabbar_bluetoothHL"] forState:UIControlStateSelected];
        }
       
    }];
    // turn on
    [atCentral.didTurnOn subscribeNext:^(id x) {
        self.centerButton.selected = [x boolValue];
    }];
    // bar button double tapped
    [self.atTabBar.didDoubleTapped subscribeNext:^(id x) {
        if ([x unsignedIntegerValue] == 1) {
            [self.homeVC.didSelected sendNext:nil];
        } else if ([x unsignedIntegerValue] == 2) {
            [self.sceneVC.didSelected sendNext:nil];
        } else if ([x unsignedIntegerValue] == 3) {
            [self.deviceVC.didSelected sendNext:nil];
        } else if ([x unsignedIntegerValue] == 4) {
            [self.discoverVC.didSelected sendNext:nil];
        }
    }];
}

- (ATTabBar *)atTabBar{
    if (!_atTabBar) {
        // create it
        _atTabBar = [ATTabBar barWithAnimationMode:ATTabBarAnimationModeRotation centerButton:self.centerButton action:^{
            // turn on or turn off
            atCentral.letSmartLampTurnOnOrOff(!self.centerButton.selected);
        }];
    }
    return _atTabBar;
}

- (UIButton *)centerButton{
    if (!_centerButton) {
        // create it
        _centerButton = [[UIButton alloc] init];
        // do something...
        [_centerButton setImage:[UIImage imageNamed:@"tabbar_bluetooth"] forState:UIControlStateDisabled];
        [_centerButton setImage:[UIImage imageNamed:@"tabbar_bluetoothHL"] forState:UIControlStateNormal];
        [_centerButton setImage:[UIImage imageNamed:@"tabbar_bluetoothHL"] forState:UIControlStateSelected];
        _centerButton.selected = YES;
    }
    return _centerButton;
}

@end
