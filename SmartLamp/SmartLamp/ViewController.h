//
//  ViewController.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-04-21.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "ATCentralManager.h"

#import <SCLAlertView.h>




@interface ViewController : UIViewController

// 中心设备, 单例
@property (strong, nonatomic) ATCentralManager *iPhone;

// 当前的情景模式
@property (strong, nonatomic) ATProfiles *aProfiles;

// 情景模式的配置列表
@property (strong, nonatomic) NSMutableArray<ATProfiles *> *profilesList;

// 是否自动连接
@property (assign, nonatomic) BOOL isAutoConnect;

// 按钮弹起的效果
- (IBAction)touchUp:(UIButton *)sender;

// 按钮按下的效果
- (IBAction)touchDown:(UIButton *)sender;

// 新建一个AlertView
-(SCLAlertView *)newAlert;

// 主题色
- (UIColor *)tintColor;


@end

