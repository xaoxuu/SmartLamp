//
//  BLEUtil.h
//  BLE上课
//
//  Created by 刘卓明 on 16/1/19.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#define kBLEUtil [BLEUtil shareInstance]


@interface BLEUtil : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>
/**
 *  手机
 */
@property (strong, nonatomic) CBCentralManager *manager;
/**
 *  周边设备
 */
@property (strong, nonatomic) CBPeripheral *peripheral;


+(instancetype) shareInstance;
- (void) startScan;
- (void) stopScan;
- (void)sendPSW;
-(void)sendTestData;
- (void)ble07_red:(int)red blue:(int)blue green:(int)green;


@end
