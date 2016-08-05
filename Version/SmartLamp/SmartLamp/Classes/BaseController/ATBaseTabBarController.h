//
//  ATBaseTabBarController.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-13.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATTabBar.h"
#import "HomeViewController.h"
#import "SceneViewController.h"
#import "DeviceViewController.h"


@interface ATBaseTabBarController : UITabBarController

@property (strong, nonatomic) HomeViewController *homeVC;
@property (strong, nonatomic) SceneViewController *sceneVC;
@property (strong, nonatomic) DeviceViewController *deviceVC;

@property (strong, nonatomic) ATTabBar *atTabBar;

@end
