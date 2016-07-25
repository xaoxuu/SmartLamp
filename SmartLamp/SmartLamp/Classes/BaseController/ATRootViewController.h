//
//  ATRootViewController.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-06-27.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SCLAlertView.h>
#import "ATBaseTabBarController.h"

@interface ATRootViewController : UIViewController

// 允许弹窗
@property (assign, nonatomic) BOOL allowsShowAlert;

// 主控制器
@property (strong, nonatomic) ATBaseTabBarController *mainVC;

@end
