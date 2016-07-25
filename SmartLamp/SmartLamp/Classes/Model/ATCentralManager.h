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


#define NOTI_BLE_AVAILABLE  @"蓝牙是否可用"

#define NOTI_BLE_SCAN @"扫描类通知"
#define NOTI_BLE_SCAN_START @"开始扫描"
#define NOTI_BLE_SCAN_STOP @"停止扫描"
#define NOTI_BLE_SCAN_FOUND @"发现设备"
#define NOTI_BLE_SCAN_NOTFOUND @"未发现设备"

#define NOTI_BLE_CONNECT @"连接类通知"
#define NOTI_BLE_CONNECT_SUCCESS @"连接成功"
#define NOTI_BLE_CONNECT_FAIL @"连接失败"
#define NOTI_BLE_CONNECT_DISCONNECT @"断开连接"

#define NOTI_BLE_STATUS @"灯状态通知"
#define NOTI_BLE_STATUS_CHANGE @"状态改变"
#define NOTI_BLE_STATUS_TURNON @"灯打开了"
#define NOTI_BLE_STATUS_TURNOFF @"灯关闭了"


@interface ATCentralManager : NSObject <NSCopying,CBCentralManagerDelegate,CBPeripheralDelegate>

#pragma mark - 模型
/**
 *	@author Aesir Titan, 2016-07-24 17:07:06
 *
 *	@brief 蓝牙周边设备
 */
@property (strong, nonatomic) CBPeripheral *connectedPeripheral;

/**
 *	@author Aesir Titan, 2016-07-24 17:07:48
 *
 *	@brief 扫描到的蓝牙灯列表
 */
@property (strong, nonatomic) NSMutableArray<CBPeripheral *> *scanedDeviceList;

/**
 *	@author Aesir Titan, 2016-07-24 17:07:58
 *
 *	@brief 当前使用的情景模式
 */
@property (strong, nonatomic) ATProfiles *currentProfiles;

#pragma mark - 公有方法

#pragma mark 扫描
/**
 *	@author Aesir Titan, 2016-07-24 17:07:51
 *
 *	@brief 自动超时的扫描(超时时间默认5秒)
 */
- (void)startScanWithAutoTimeout;

/**
 *	@author Aesir Titan, 2016-05-16 16:05:45
 *
 *	@brief 立即停止扫描
 */
- (void)stopScan;

#pragma mark 连接

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

/**
 *	@author Aesir Titan, 2016-07-24 17:07:19
 *
 *	@brief 连接或断开连接
 */
- (void)connectOrDisconnect;

#pragma mark 开关

/**
 *	@author Aesir Titan, 2016-04-29 15:04:12
 *
 *	@brief 蓝牙灯电源开关
 *
 *	@param work	YES:开, NO:关
 */
- (void)letSmartLampTurnOnIf:(BOOL)isYes;

/**
 *	@author Aesir Titan, 2016-04-29 15:04:21
 *
 *	@brief 蓝牙灯定时关机
 */
- (void)letSmartLampPerformSleepMode;

#pragma mark 控制

/**
 *	@author Aesir Titan, 2016-07-20 17:07:16
 *
 *	@brief 动画模式
 */
- (void)letSmartLampPerformColorAnimation;
/**
 *	@author Aesir Titan, 2016-07-20 17:07:07
 *
 *	@brief 更新蓝牙灯的颜色
 */
- (void)letSmartLampUpdateColor;

/**
 *	@author Aesir Titan, 2016-07-20 17:07:23
 *
 *	@brief 更新亮度
 */
- (void)letSmartLampUpdateBrightness;
/**
 *	@author Aesir Titan, 2016-07-20 17:07:31
 *
 *	@brief 更新所有状态
 */
- (void)letSmartLampUpdateAllStatus;
/**
 *	@author Aesir Titan, 2016-07-24 19:07:06
 *
 *	@brief 应用情景模式
 *
 *	@param aProfiles	给定情景模式
 */
- (void)letSmartLampApplyProfiles:(ATProfiles *)aProfiles;

#pragma mark 构造方法

// defaultCentralManager (可以用此方法快速创建一个单例对象)
+ (instancetype)defaultCentralManager;

// sharedCentralManager
+ (instancetype)sharedCentralManager;



@end





