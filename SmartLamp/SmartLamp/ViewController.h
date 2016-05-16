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
#import "SCLAlertView.h"
#import "UIImage+getColorAtPixel.h"


@interface ViewController : UIViewController

typedef NS_ENUM(NSInteger, AlertStyle){
    // error 找不到蓝牙设备!
    AlertDeviceNotFound,
    // waiting 正在连接...
    AlertConnecting,
    // success 连接成功!
    AlertConnectSuccess,
    
    // question 连接设备?
//    AlertQuestionConnect,
//    // question 您已连接, 是否断开?
//    AlertQuestionDisconnect,
//    // question 应用情景模式?
//    AlertQuestionApply,
    
};

typedef NS_ENUM(NSInteger, AlertQuestion){

    // question 连接设备?
    AlertQuestionConnect,
    // question 您已连接, 是否断开?
    AlertQuestionDisconnect,
    // question 应用情景模式?
    AlertQuestionApply,
    
};


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

@property (strong, nonatomic) UIColor *color;
// 新建一个AlertView
-(SCLAlertView *)newAlert;

// 主题色
- (UIColor *)tintColor;



@end

