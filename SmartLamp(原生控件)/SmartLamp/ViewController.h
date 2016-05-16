//
//  ViewController.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-04-21.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "ATCentralManager.h"
#import "ATProfiles.h"
#import "ATFileManager.h"
#import "UIButton+ATButton.h"

@interface ViewController : UIViewController

// 中心设备, 单例
@property (strong, nonatomic) ATCentralManager *iPhone;

// 当前的情景模式
@property (strong, nonatomic) ATProfiles *aProfiles;

// 情景模式的配置列表
@property (strong, nonatomic) NSMutableArray<ATProfiles *> *profilesList;



// 按钮弹起的效果
- (IBAction)touchUp:(UIButton *)sender;

// 按钮按下的效果
- (IBAction)touchDown:(UIButton *)sender;

// AlertView
- (void)pushAlertViewWithTitle:(NSString *)title
                    andMessage:(NSString *)message
                         andOk:(NSString *)ok
                     andCancel:(NSString *)cancel
                 andOkCallback:(void (^)())okCallback
             andCancelCallback:(void (^)())cancelCallback;



@end

