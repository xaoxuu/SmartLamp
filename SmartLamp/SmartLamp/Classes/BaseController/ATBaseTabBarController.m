//
//  ATBaseTabBarController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-13.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ATBaseTabBarController.h"
#import "UITabBarController+ATBaseController.h"
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
    
    // default style
    [self at_initWithDefaultStyle];
    // app theme color
    [self at_setTintColor:nil];
    // child controllers
    [self setupControllers];
    // tabbar
    [self setupTabBar];
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
    
    [self at_setupChlidController:[[ATBaseNavigationController alloc] initWithRootViewController:self.homeVC] title:@"主页" image:@"tabbar_home" selectedImage:@"tabbar_home"];
    [self at_setupChlidController:[[ATBaseNavigationController alloc] initWithRootViewController:self.sceneVC] title:@"情景" image:@"tabbar_scene" selectedImage:@"tabbar_scene"];
    [self at_setupChlidController:[[ATBaseNavigationController alloc] initWithRootViewController:self.deviceVC] title:@"设备" image:@"tabbar_device" selectedImage:@"tabbar_device"];
    [self at_setupChlidController:[[ATBaseNavigationController alloc] initWithRootViewController:self.discoverVC] title:@"发现" image:@"tabbar_device" selectedImage:@"tabbar_device"];
    
}

// setup tabbar
- (void)setupTabBar{
    
    // center button
    self.centerButton = [[UIButton alloc] init];
    [self.centerButton setImage:[UIImage imageNamed:@"tabbar_home"] forState:UIControlStateNormal];
    [self.centerButton setImage:[UIImage imageNamed:@"tabbar_scene"] forState:UIControlStateSelected];
    [self.centerButton setImage:[UIImage imageNamed:@"tabbar_device"] forState:UIControlStateDisabled];
    
    // tabbar
    self.atTabBar = [[ATTabBar alloc] initWithAnimationMode:ATTabBarAnimationModeRotation centerButton:self.centerButton action:^{
        // turn on or turn off
        [atCentralManager letSmartLampTurnOnIf:!self.centerButton.selected];
    }];
    [self setValue:self.atTabBar forKeyPath:@"tabBar"];
    
}


- (void)subscribeRAC{
    // scan
    [atCentralManager.didScaning subscribeNext:^(id x) {
        self.centerButton.enabled = NO;
    }];
    // stop scan
    [atCentralManager.didStopScan subscribeNext:^(id x) {
        self.centerButton.enabled = YES;
    }];
    // turn on
    [atCentralManager.didTurnOn subscribeNext:^(id x) {
        self.centerButton.selected = YES;
    }];
    // turn off
    [atCentralManager.didTurnOff subscribeNext:^(id x) {
        self.centerButton.selected = NO;
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


@end
