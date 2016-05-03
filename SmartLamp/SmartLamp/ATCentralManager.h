//
//  ATCentralManager.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-04-28.
//  Copyright © 2016 Titan Studio. All rights reserved.
//
//  =========================================================================
//            Welcome to use SingletonObject created by Aesir Titan
//     ===================================================================
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface ATCentralManager : NSObject <NSCopying,CBCentralManagerDelegate,CBPeripheralDelegate>

#pragma mark - 属性

// 中心设备
@property (strong, nonatomic) CBCentralManager *manager;

// 蓝牙设备
@property (strong, nonatomic) CBPeripheral *peripheral;


// 动画枚举
typedef NS_ENUM(NSUInteger,Animation){
    
    AnimationNone,
    AnimationSaltusStep3,
    AnimationSaltusStep7,
    AnimationGratation,
    
};

#pragma mark - 供控制器调用的方法

/**
 *	@author Aesir Titan, 2016-04-29 15:04:58
 *
 *	@brief 蓝牙灯连接或断开
 *
 *	@param connect	YES:连接, NO:断开
 */
- (void)smartLampConnectOrNot:(BOOL)connect;

/**
 *	@author Aesir Titan, 2016-04-29 15:04:12
 *
 *	@brief 蓝牙灯电源开关
 *
 *	@param work	YES:开, NO:关
 */
- (void)smartLampPowerOnOrOff:(BOOL)powerOn;

/**
 *	@author Aesir Titan, 2016-04-29 15:04:21
 *
 *	@brief 蓝牙灯定时关机
 *
 *	@param minutes	分钟
 */
- (void)smartLampPowerOffAfter:(NSUInteger)minutes;

/**
 *	@author Aesir Titan, 2016-04-29 15:04:56
 *
 *	@brief 设置蓝牙灯颜色和亮度
 *
 *	@param red		红 float(0~1)
 *	@param green	绿 float(0~1)
 *	@param blue		蓝 float(0~1)
 *	@param bright	亮度 float(0~1)
 */
- (void)smartLampSetColorWithR:(float)red G:(float)green B:(float)blue andBright:(float)bright;

/**
 *	@author Aesir Titan, 2016-04-29 15:04:46
 *
 *	@brief 设置蓝牙灯颜色动画
 *
 *	@param animation	动画枚举
 */
- (void)smartLampSetColorAnimation:(Animation)animation;

#pragma mark 单例

// defaultCentralManager (可以用此方法快速创建一个单例对象)
+ (instancetype)defaultCentralManager;

// sharedCentralManager
+ (instancetype)sharedCentralManager;

@end
