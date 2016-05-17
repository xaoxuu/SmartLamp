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

// 通知
#define BLUETOOTH @"蓝牙"
#define CONNECT @"连接"
#define DISCONNECT @"断开连接"
#define DEVICE @"设备"

#define DISCOVER @"发现设备"
#define SUCCESS @"连接成功"
#define FAIL @"连接失败"



@interface ATCentralManager : NSObject <NSCopying,CBCentralManagerDelegate,CBPeripheralDelegate>

#pragma mark - 属性

// 中心设备单例
@property (strong, nonatomic) CBCentralManager *manager;

// 扫描到的蓝牙设备列表
@property (strong, nonatomic) NSMutableArray<CBPeripheral *> *scanedDeviceList;

#pragma mark 状态标记

// 蓝牙是否可用
@property (assign, nonatomic) BOOL isBluetoothAvailable;

// 是否正在扫描
@property (assign, nonatomic) BOOL isScaning;

// 中心设备与周边设备的连接状态
@property (assign, nonatomic) BOOL isConnecting;


#pragma mark - 🍀 公有方法 🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀

#pragma mark 🔍 扫描

/**
 *	@author Aesir Titan, 2016-05-16 16:05:39
 *
 *	@brief 开始扫描
 */
- (void)startScan;
/**
 *	@author Aesir Titan, 2016-05-16 16:05:45
 *
 *	@brief 停止扫描
 */
- (void)stopScan;

#pragma mark 🔗 连接

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

#pragma mark 🔌 开关

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
- (void)letSmartLampSleepAfter:(NSUInteger)minutes;

#pragma mark 🔆 控制

/**
 *	@author Aesir Titan, 2016-05-16 16:05:18
 *
 *	@brief 设置蓝牙灯的颜色
 *
 *	@param color	颜色
 */
- (void)letSmartLampSetColor:(UIColor *)color;

/**
 *	@author Aesir Titan, 2016-05-16 10:05:18
 *
 *	@brief 设置蓝牙灯亮度
 *
 *	@param brightness	亮度值(0~100)
 */
//- (void)letSmartLampSetBrightness:(CGFloat)brightness;

/**
 *	@author Aesir Titan, 2016-04-29 15:04:46
 *
 *	@brief 设置蓝牙灯颜色动画
 *
 *	@param animation	动画枚举
 */
- (void)letSmartLampPerformColorAnimation:(ColorAnimation)animation;

#pragma mark 📦 构造方法

// defaultCentralManager (可以用此方法快速创建一个单例对象)
+ (instancetype)defaultCentralManager;

// sharedCentralManager
+ (instancetype)sharedCentralManager;

@end
