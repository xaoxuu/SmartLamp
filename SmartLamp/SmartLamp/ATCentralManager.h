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
#import "ATProfiles.h"

@interface ATCentralManager : NSObject <NSCopying,CBCentralManagerDelegate,CBPeripheralDelegate>

#pragma mark - 属性

// 中心设备
@property (strong, nonatomic) CBCentralManager *manager;

// 蓝牙设备
@property (strong, nonatomic) CBPeripheral *peripheral;


// 中心设备与周边设备的连接状态
@property (assign, nonatomic) BOOL connecting;


// 动画枚举
//typedef NS_ENUM(NSUInteger,ColorAnimation){
//    
//    ColorAnimationNone,
//    ColorAnimationSaltusStep3,
//    ColorAnimationSaltusStep7,
//    ColorAnimationGratation,
//    
//};

#pragma mark - 供控制器调用的方法


/**
 *	@author Aesir Titan, 2016-05-09 16:05:01
 *
 *	@brief 中心设备开始搜索蓝牙灯
 *
 *	@return 找到的蓝牙灯设备列表
 */
- (NSArray *)searchSmartLamp;


/**
 *	@author Aesir Titan, 2016-05-09 18:05:59
 *
 *	@brief 连接给定的蓝牙灯
 *
 *	@param smartLamp	给定的蓝牙灯
 */
- (void)connectSmartLamp:(CBPeripheral *)smartLamp;



/**
 *	@author Aesir Titan, 2016-05-09 18:05:17
 *
 *	@brief 断开与当前蓝牙灯的连接
 */
- (void)disConnectSmartLamp;

- (void)readyForScan;
- (void)stopScan;

/**
 *	@author Aesir Titan, 2016-04-29 15:04:12
 *
 *	@brief 蓝牙灯电源开关
 *
 *	@param work	YES:开, NO:关
 */
- (void)letSmartLampPowerOnOrOff:(BOOL)powerOn;

/**
 *	@author Aesir Titan, 2016-04-29 15:04:21
 *
 *	@brief 蓝牙灯定时关机
 *
 *	@param minutes	分钟
 */
- (void)letSmartLampPowerOffAfter:(NSUInteger)minutes;

/**
 *	@author Aesir Titan, 2016-04-29 15:04:56
 *
 *	@brief 设置蓝牙灯颜色和亮度
 *
 *	@param red		红色 float(0~1)
 *	@param green	绿色 float(0~1)
 *	@param blue		蓝色 float(0~1)
 *	@param bright	亮度 float(0~1)
 */
- (void)letSmartLampSetColorWithR:(float)red G:(float)green B:(float)blue andBright:(float)bright;


/**
 *	@author Aesir Titan, 2016-04-29 15:04:46
 *
 *	@brief 设置蓝牙灯颜色动画
 *
 *	@param animation	动画枚举
 */
- (void)letSmartLampPerformColorAnimation:(ColorAnimation)animation;

#pragma mark 单例

// defaultCentralManager (可以用此方法快速创建一个单例对象)
+ (instancetype)defaultCentralManager;

// sharedCentralManager
+ (instancetype)sharedCentralManager;

@end
