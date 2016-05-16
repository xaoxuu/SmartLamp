//
//  ATPeripheral.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-04-28.
//  Copyright © 2016 Titan Studio. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface ATPeripheral : NSObject <NSCoding>

// 蓝牙外设, 此项目针对蓝牙灯
@property (strong, nonatomic) CBPeripheral *peripheral;

// 外设的UUID
@property (copy, nonatomic) NSString *uuid;

// UUID对应的名字
@property (copy, nonatomic) NSString *name;



@end
