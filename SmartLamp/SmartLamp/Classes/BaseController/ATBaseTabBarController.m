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



@interface ATBaseTabBarController ()

@end

@implementation ATBaseTabBarController

#pragma mark - 视图事件

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 默认样式
    [self at_initWithDefaultStyle];
    // 设置主题色
    [self at_setTintColor:nil];
    // 设置子控制器
    [self _setupControllers];
    // 设置tabbar
    [self _setupTabBar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 私有方法

// 设置子控制器
- (void)_setupControllers{
    
    self.homeVC = [[HomeViewController alloc] init];
    self.sceneVC = [[SceneViewController alloc] init];
    self.deviceVC = [[DeviceViewController alloc] init];
    
    [self at_setupChlidController:[[ATBaseNavigationController alloc] initWithRootViewController:self.homeVC] title:@"主页" image:@"tabbar_home" selectedImage:@"tabbar_home"];
    [self at_setupChlidController:[[ATBaseNavigationController alloc] initWithRootViewController:self.sceneVC] title:@"情景" image:@"tabbar_scene" selectedImage:@"tabbar_scene"];
    [self at_setupChlidController:[[ATBaseNavigationController alloc] initWithRootViewController:self.deviceVC] title:@"设备" image:@"tabbar_device" selectedImage:@"tabbar_device"];
    
}

// 设置tabbar
- (void)_setupTabBar{
    
    self.atTabBar = [[ATTabBar alloc] init];
    [self setValue:self.atTabBar forKeyPath:@"tabBar"];
    
}

@end
