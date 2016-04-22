//
//  BLEUtil.m
//  BLE上课
//
//  Created by 刘卓明 on 16/1/19.
//  Copyright © 2016年 lzm. All rights reserved.
//

#import "BLEUtil.h"

@interface BLEUtil()
@property (strong, nonatomic) CBCharacteristic *Characteristic1001;
@property (strong, nonatomic) CBCharacteristic *Characteristic1002;
@end


static BLEUtil * shareUtil = nil;

@implementation BLEUtil
/**
 *  单例
 */
+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        shareUtil = [[self alloc] init] ;
    }) ;
    
    return shareUtil ;
}
/**
 *  创始化时 把manager 创建了
 */
- (instancetype)init
{
    self = [super init];
    /**
     创建一个 中心
     */
    _manager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    _manager.delegate = self;
    return self;
}
/**
 *  判断 蓝牙是否开启
 */
- (BOOL)isLECapableHardware
{
    NSString * state = nil;
    
    int iState = (int)[_manager state];
    
    NSLog(@"Central manager state: %i", iState);
    
    switch ([_manager state])
    {
        case CBCentralManagerStateUnsupported:
            state = @"The platform/hardware doesn't support Bluetooth Low Energy.";
            break;
        case CBCentralManagerStateUnauthorized:
            state = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBCentralManagerStatePoweredOff:
            state = @"蓝牙关闭了 Bluetooth is currently powered off.";
            
            break;
        case CBCentralManagerStatePoweredOn:
            state = @"蓝牙是打开的";

            return TRUE;
        case CBCentralManagerStateUnknown:
        default:
            return FALSE;
    }
    
    NSLog(@"手机蓝牙状态Central manager state: %@", state);
    
    return FALSE;
}
/*
 开始扫描
 可针对性搜索
 */
- (void)startScan
{
    //
    if ([self isLECapableHardware]) {
        [_manager scanForPeripheralsWithServices:nil options:nil];
        
        /**
         *  针对性扫秒的例子
         */
        //        [_manager scanForPeripheralsWithServices:[NSArray arrayWithObject:[CBUUID UUIDWithString:@"180D"]] options:nil];
    }
}

/*
 停止扫描
 Request CBCentralManager to stop scanning for peripherals
 */
- (void)stopScan
{
    [_manager stopScan];
}


- (void)sendTestData
{
    
}



#pragma mark 代理
#pragma mark CBCentralManager delegate methods
/*
 每当中央管理器调用的状态更新。
 Invoked whenever the central manager's state is updated.
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    [self isLECapableHardware];
    NSLog(@"手机蓝牙状态变更");
}

/*
 扫描到的设备
 调用该方法时扫描,发现周边蓝牙对象CBPeripheral、中心CBCentralManager。对合适的周边对象进行保留来使用它;对于不感兴趣的,将由中心CBCentralManager清理。
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)aPeripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    
    
    
    if ([aPeripheral.name isEqualToString:@"KQX-BL1000"]) {
        _peripheral = aPeripheral;
        [_manager connectPeripheral:aPeripheral options:nil];
    }
    
    
}



/*
 自动重连的重要方法
 当中央管理器调用检索列表中已知的外围设备。自动连接到第一个已知的外围
 */
- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    /* If there are any known devices, automatically connect to it.*/
    
    if([peripherals count] >= 1)
    {
        _peripheral = [peripherals objectAtIndex:0];
        NSLog(@"connecting type 2....%@",_peripheral.name);
        [_manager connectPeripheral:_peripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
    }
}

/*
 每当调用与外围连接成功创建。
 Invoked whenever a connection is succesfully created with the peripheral.
 Discover available services on the peripheral
 */
#pragma mark 每当调用是成功创建连接外围。外围发现可用的服务
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)aPeripheral
{
    NSLog(@"蓝牙连接成功");
    //连接成功后设置代理
    [aPeripheral setDelegate:self];
    //同时开始 查看这个周边对象服务 会在以下的方法回调
    //- (void) peripheral:(CBPeripheral *)aPeripheral didDiscoverServices:(NSError *)error;
    [aPeripheral discoverServices:nil];
    
   
    [self stopScan];
    
}
/*
 周边对象与中心断开连接的回调
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)aPeripheral error:(NSError *)error
{
    
    if( _peripheral )
    {
        [_peripheral setDelegate:nil];
        _peripheral = nil;
    }
}

/*
 中心与周边对象连接失败的回调
 Invoked whenever the central manager fails to create a connection with the peripheral.
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)aPeripheral error:(NSError *)error
{
    NSLog(@"Fail to connect to peripheral: %@ with error = %@", aPeripheral, [error localizedDescription]);
    if( _peripheral )
    {
        [_peripheral setDelegate:nil];
        
        _peripheral = nil;
    }
}

#pragma mark - CBPeripheral delegate methods
/*
 周边对象调用了-[discoverServices:]方法后，会在代理（现在是自身）的以下方法中返回
 Invoked upon completion of a -[discoverServices:] request.
 Discover available characteristics on interested services
 */
- (void) peripheral:(CBPeripheral *)aPeripheral didDiscoverServices:(NSError *)error
{
    
    for (CBService *aService in aPeripheral.services)
    {
        NSLog(@"Service found with UUID : %@", aService.UUID);
        
        if ([aService.UUID isEqual:[CBUUID UUIDWithString:@"1000"]]){
            // 找到了周边对象的服务后 调用 -[discoverCharacteristics]可以查看 服务中的特征
            // 在 -[didDiscoverCharacteristicsForService] 中回调
            [aPeripheral discoverCharacteristics:nil forService:aService];
        }
        //        if ([aService.UUID isEqual:[CBUUID UUIDWithString:@"FFE0"]]){
        //            [aPeripheral discoverCharacteristics:nil forService:aService];
        //        }
    }
}

/*
 周边对象找到服务后 调用-[discoverCharacteristics:forService:] 查看其中的特征值
 在这个方法中你能拿到连接上的周边对象的服务uuid和 特征UUID ,对于需要发送数据和接受数据特征，要保存起来，同时打开监听
 Invoked upon completion of a -[discoverCharacteristics:forService:] request.
 Perform appropriate operations on interested characteristics
 */
- (void) peripheral:(CBPeripheral *)aPeripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
    NSLog(@"Service : %@", service.UUID);
    NSLog(@"includedServices :%@",service.includedServices);
    NSLog(@"characteristics :%@",service.characteristics);
    
    if (service.isPrimary) {
        NSLog(@"service.isPrimary : %@", service.UUID);
    }
    
    
    
    if ([service.UUID isEqual: [CBUUID UUIDWithString:@"1000"]])
    {
        for (CBCharacteristic *aChar in service.characteristics)
        {
            //            _calibrationCharacteristic = aChar;
            //            [_peripheral setNotifyValue:YES forCharacteristic:aChar];
            //            [_peripheral readValueForCharacteristic:aChar];
            //            [self sendPSW];
            
            
            
            //
            NSLog(@"aChar.UUID==:%@",aChar.UUID);
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:@"1001"]]) {
                
                NSLog(@"找到了通道Power Characteristic : %@", aChar.UUID);
                _Characteristic1001 = aChar;
                
                
                
            }
            
            else if ([aChar.UUID isEqual:[CBUUID UUIDWithString:@"1002"]]) {
                
                _Characteristic1002 = aChar;
                
                [aPeripheral setNotifyValue:YES forCharacteristic:_Characteristic1002];
                [aPeripheral readValueForCharacteristic:_Characteristic1002];
                
            }
            
            
            
            
            
            
            
        }
    }
   
    [self sendPSW];
    
    
}

#pragma mark 接收到 网桥的返回通知
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
    }
    
   
    if (characteristic.isNotifying)
    {
        NSLog(@"Notification began on %@", characteristic);
        [peripheral readValueForCharacteristic:characteristic];
    }
}
/*
 Invoked upon completion of a -[readValueForCharacteristic:] request or on the reception of a notification/indication. 接收到 网桥的返回的数据
 */
- (void) peripheral:(CBPeripheral *)aPeripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        NSLog(@"Error didUpdateValueForCharacteristic %@", error.localizedDescription);
    }
    
    NSLog(@"接受到了数据 :%@",characteristic.value);
    NSLog(@" ******* didUpdateValue--UUID :%@",characteristic.UUID);
    NSData *data = characteristic.value;
    NSLog(@" data.length = %ld %@",data.length, data);
    
    
}



- (void)peripheral:(CBPeripheral *)_peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    
    //    NSLog(@"发送成功");
    //
    //    NSLog(@"characteristics :%@",characteristic);
    
    
    //    return;
    //    self.isFinish = YES;
    if (error)
    {
        NSLog(@"Failed to write value for characteristic %@, reason: %@", characteristic, error);
    }
    else
    {
        NSLog(@"Did write value for characterstic %@, new value: %@", characteristic, [characteristic value]);
    }
}


/**
 *  发送密码
 */
- (void)sendPSW
{
    int i = 0;
    char char_array[17] = {0x00};//定义一个字节数组
    char_array[i++] = 0x55;  //16进制
    char_array[i++] = 0xaa;  //10进制
    char_array[i++] = 0x30;  //
    

    
    
    
    //打包成data
    NSData* data = [NSData dataWithBytes:(const void *)char_array length:sizeof(char) * 17];
    NSLog(@"发送的数据  %@",data);
    
    [_peripheral writeValue:data forCharacteristic:_Characteristic1001 type:CBCharacteristicWriteWithResponse];
    
    
    
    //    [self ble07_red:0 blue:0 green:0];
}


/**
 *  设备状态输出,命令字0x07
 0x55,0xAA,0x07, [R][G][B][W][BRT][IO1] RGBW为四路PWM数据,0-255,分别控制四路灯具,BRT为RGBW的灰度参数,0-255, 正确返回 55 AA 07
 *  颜色
 */
- (void)ble07_red:(int)red blue:(int)blue green:(int)green
{
    int i = 0;
    char char_array[17] = {0x00};//定义一个字节数组
    char_array[i++] = 0x55;  //16进制
    char_array[i++] = 0xaa;  //10进制
    char_array[i++] = 0x07;  //
    
    char_array[i++] = red;  //r
    char_array[i++] = green;  //g
    char_array[i++] = blue;  //b
    char_array[i++] = 0x00;  //w
    char_array[i++] = 0xff;  //brt
    
    
    
    //打包成data
    NSData* data = [NSData dataWithBytes:(const void *)char_array length:sizeof(char) * 17];
    NSLog(@"ble07发送的数据  %@",data);
    
    [_peripheral writeValue:data forCharacteristic:_Characteristic1001 type:CBCharacteristicWriteWithResponse];
    
    
}



@end
