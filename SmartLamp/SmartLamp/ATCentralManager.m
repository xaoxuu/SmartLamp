//
//  ATCentralManager.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-04-28.
//  Copyright © 2016 Titan Studio. All rights reserved.
//
//  =========================================================================
//            Welcome to use SingletonObject created by Aesir Titan
//     ===================================================================
//

#import "ATCentralManager.h"


ATCentralManager *iPhone;

@interface ATCentralManager ()

// 蓝牙设备
@property (strong, nonatomic) CBPeripheral *peripheral;

// 特征
@property (strong, nonatomic) CBCharacteristic *Characteristic1001;
@property (strong, nonatomic) CBCharacteristic *Characteristic1002;

// 颜色
@property (strong, nonatomic) UIColor *color;

// 亮度 (0~100)
@property (assign, nonatomic) CGFloat brightness;

#pragma mark 状态标记


@end

@implementation ATCentralManager

#pragma mark - 🍀 公有方法 🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀


#pragma mark 🔍 扫描

// 开始扫描
- (void)startScan{
    
    // 只有在没有扫描的状态下才执行开始扫描指令(防止重复执行)
    if (!self.isScaning) {
        // 扫描前清空列表
        [self.scanedDeviceList removeAllObjects];
        // 开始扫描
        [self.manager scanForPeripheralsWithServices:nil options:nil];
        // 状态标记
        self.isScaning = YES;
        NSLog(@"<扫描>-------开始扫描-------");
    }
    
}

// 停止扫描
- (void)stopScan
{
    
    // 只有在扫描的状态下才执行停止扫描的指令
    if (self.isScaning) {
        // 停止扫描
        [self.manager stopScan];
        // 状态标记
        self.isScaning = NO;
        NSLog(@"<扫描>-------停止扫描-------");
    }
    
}


#pragma mark 🔗 连接

// 建立连接
- (void)connectSmartLamp:(CBPeripheral *)smartLamp{
    
    // 只有在未连接的状态下才执行建立连接的指令
    if (!self.isConnecting) {
        
        // 把传入指定的设备赋值给单例中的属性
        self.peripheral = smartLamp;
        
        // 如果拥有对象, 就连接
        if (self.peripheral) {
            // 调用连接周边设备的方法
            [self.manager connectPeripheral:self.peripheral options:nil];
            // 状态标记
            self.isConnecting = YES;
        }
        
    }
    
}

// 断开连接
- (void)disConnectSmartLamp{
    
    // 只有在连接的状态下才执行断开连接的指令
    if (self.isConnecting) {
        
        // 调用断开连接的方法
        [self.manager cancelPeripheralConnection:self.peripheral];
        // 更新状态值
        self.isConnecting = NO;
        // 控制台输出
        NSLog(@"蓝牙设备已断开");
        
    }
    
}

#pragma mark 🔌 开关

// 电源开关
- (void)letSmartLampPowerOnOrOff:(BOOL)powerOn{
    
    // 只有在连接的状态下才执行开关电源的指令
    if (self.isConnecting) {
        
        // 开灯
        if (powerOn) {
            [iPhone letSmartLampSetBrightness:self.brightness];
        }
        // 关灯
        else {
            [iPhone letSmartLampSetColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
//            [self sendData:^(char *p) {
//                
//                *p++ = 0x07;                // 设备状态输出
//                
//                *p++ = 0x00;    //r
//                *p++ = 0x00;  //g
//                *p++ = 0x00;   //b
//                *p++ = 0x00;                //w
//                *p++ = 0x00; //brt
//                
//            }];
        }

    }
    
}

// 设置定时关机
- (void)letSmartLampPowerOffAfter:(NSUInteger)minutes{
    
    // 只有在连接的状态下才执行定时关机的指令
    if (self.isConnecting) {
        
        // 保证传入的时间在支持的范围内
        if (minutes < 5) minutes = 5;
        if (minutes > 120)minutes = 120;
        
        // 调用发送数据的Block
        [self sendData:^(char *p) {
            *p++ = 0x04;    // 延时关机指令
            *p++ = minutes; // 分钟数，5~120分钟
        }];

    }
    
}


#pragma mark 🔆 控制

// 设置颜色
- (void)letSmartLampSetColor:(UIColor *)color{
    
    // 只有在连接的状态下才执行设置颜色的指令
    if (self.isConnecting) {
        
        // 把传入的颜色暂存到属性中, 以便于恢复状态
        self.color = color;
        // 提取出UIColor中的RGB值
        CGFloat red=0,green=0,blue=0,bright=0;
        [color getRed:&red green:&green blue:&blue alpha:&bright];
        
        
//        CGFloat red=0,green=0,blue=0,bright=0;
//#warning sdf
//        if ([color respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
//            [color getRed:&red green:&green blue:&blue alpha:&bright];
//        }
//        else {
//            const CGFloat *components = CGColorGetComponents(color.CGColor);
//            red = components[0];
//            green = components[1];
//            blue = components[2];
//            bright = components[3];
//        }
    
        // 调用发送数据的Block
        [self sendData:^(char *p) {
            
            *p++ = 0x07;                // 设备状态输出
            
            *p++ = (int)(255 * red);    //r
            *p++ = (int)(255 * green);  //g
            *p++ = (int)(255 * blue);   //b
            *p++ = 0x00;                //w
            *p++ = (int)(255 * bright); //brt
            
        }];
        
    }
    
}

// 设置亮度
- (void)letSmartLampSetBrightness:(CGFloat)brightness{
    
    // 只有在连接的状态下才执行设置亮度的指令
    if (self.isConnecting) {
        
        CGFloat red=0,green=0,blue=0,bright=0;
        [self.color getRed:&red green:&green blue:&blue alpha:&bright];
        [self letSmartLampSetColor:[UIColor colorWithRed:red green:green blue:blue alpha:0.01*brightness]];
    }
    
}

// 设置动画
- (void)letSmartLampPerformColorAnimation:(ColorAnimation)animation{
    
    // 只有在连接的状态下才执行设置动画的指令
    if (self.isConnecting) {
        
        // 调用发送数据的Block
        [self sendData:^(char *p) {
            
            switch (animation) {
                case ColorAnimationNone:        // 动画暂停
                    *p++ = 0x29;
                    break;
                case ColorAnimationSaltusStep3: // 3色跳变
                    *p++ = 0x26;
                    break;
                case ColorAnimationSaltusStep7: // 7色跳变
                    *p++ = 0x27;
                    break;
                case ColorAnimationGratation:   // 渐变
                    *p++ = 0x28;
                    break;
                    
            }
            
        }];
        
    }
    
}


#pragma mark 📦 构造方法

// 构造方法 defaultCentralManager  (可以用此方法快速创建一个单例对象)
+ (instancetype)defaultCentralManager{
    
    return [self sharedCentralManager];
    
}

// sharedCentralManager
+ (id)sharedCentralManager
{
    
    if (!iPhone) {  //防止频繁加锁
        
        // Thread synchronization, guarantee in the case of multi-threaded, also can create an object.
        // 线程同步, 保证在多线程的情况下, 也只能创建出一个对象
        @synchronized (self) {
            // It won't create a new instance as long as the instance is not released.
            // 只要实例没有被释放, 就不会创建新的实例
            if (!iPhone) {
                iPhone = [[ATCentralManager alloc]init];
            }
        }
        
    }
    
    return iPhone;
    
}

#pragma mark - 🔵 代理方法 🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵

#pragma mark 📱 中心设备的代理方法

// 当中心设备的状态更新了的时候
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    
    // 分析蓝牙状态
    switch (self.manager.state)
    {
            
        case CBCentralManagerStateUnknown: // 未知状态
            break;
        case CBCentralManagerStateResetting: // 正在重置
            break;
        case CBCentralManagerStateUnsupported: // 蓝牙不支持
            NSLog(@"<代理>蓝牙不支持");
            [[NSNotificationCenter defaultCenter] postNotificationName:BLUETOOTH object:@"设备蓝牙不支持"];
            break;
        case CBCentralManagerStateUnauthorized: // 应用没有权限
            NSLog(@"<代理>应用没有权限");
            [[NSNotificationCenter defaultCenter] postNotificationName:BLUETOOTH object:@"应用没有权限"];
            break;
        case CBCentralManagerStatePoweredOff: // 蓝牙已经关闭
            NSLog(@"<代理>蓝牙已经关闭");
            [[NSNotificationCenter defaultCenter] postNotificationName:BLUETOOTH object:@"蓝牙已经关闭"];
            break;
        case CBCentralManagerStatePoweredOn: // 蓝牙已经打开
            NSLog(@"<代理>蓝牙已经打开");
            NSLog(@"<代理>蓝牙可用");
            [[NSNotificationCenter defaultCenter] postNotificationName:BLUETOOTH object:@"蓝牙可用"];
            break;
            
    }
    
}

// 处理扫描到的设备
- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)aPeripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    
    // 只有当扫描到的设备名包含"KQX", 认为是可用的蓝牙灯
    if ([aPeripheral.name containsString:@"KQX"]) {
        
        // ==================== [ 获取蓝牙设备列表 ] ==================== //
        if (![self.scanedDeviceList containsObject:aPeripheral]) {
            // 将这个蓝牙灯对象保存到列表
            [self.scanedDeviceList addObject:aPeripheral];
            // 发送通知
            NSString *device = [NSString stringWithFormat:@"已发现蓝牙设备<%@>,是否连接?",aPeripheral.name];
            NSLog(@"%@",device);
            [[NSNotificationCenter defaultCenter] postNotificationName:DEVICE object:device];
            
        }
        
    }
    
}

// 连接成功的时候
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)aPeripheral
{
    NSLog(@"<手机>已连接: %@", aPeripheral.name);
    // 连接成功后设置代理
    aPeripheral.delegate = self;
    NSLog(@"<手机>代理设置成功");
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:CONNECT object:SUCCESS];
    // 同时开始 查看这个周边对象服务 会在以下的方法回调
    //- (void) peripheral:(CBPeripheral *)aPeripheral didDiscoverServices:(NSError *)error;
    [aPeripheral discoverServices:nil];
    
    
    // 停止扫描
    [self stopScan];
    
}

// 周边对象与中心断开连接的时候
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)aPeripheral error:(NSError *)error
{
    
    // 如果中心设备拥有一个周边对象
    if(self.peripheral)
    {
        // 取消代理
        self.peripheral.delegate = nil;
        // 清空中心设备拥有的周边对象
        self.peripheral = nil;
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:DISCONNECT object:SUCCESS];
    }
    
}

// 中心与周边对象连接失败的时候
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)aPeripheral error:(NSError *)error
{
    NSLog(@"<手机>与%@连接失败. 错误信息是: %@", aPeripheral, [error localizedDescription]);
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:CONNECT object:FAIL];
    //
    if(self.peripheral)
    {
        // 取消代理
        self.peripheral.delegate = nil;
        // 清空中心设备拥有的周边对象
        self.peripheral = nil;
    }
}

#pragma mark 💡 蓝牙设备代理方法

// 发现服务
- (void)peripheral:(CBPeripheral *)aPeripheral didDiscoverServices:(NSError *)error
{
    // 遍历外设的服务
    for (CBService *aService in aPeripheral.services)
    {
        NSLog(@"<蓝牙灯>手机已连接外设的UUID : %@", aService.UUID);
        // 连接指定UUID的设备
        if ([aService.UUID isEqual:[CBUUID UUIDWithString:@"1000"]]){
            // 找到了周边对象的服务后 调用 -[discoverCharacteristics]可以查看 服务中的特征
            // 在 -[didDiscoverCharacteristicsForService] 中回调
            [aPeripheral discoverCharacteristics:nil forService:aService];
        }
        
        //连接指定UUID的设备
        if ([aService.UUID isEqual:[CBUUID UUIDWithString:@"FFE0"]]){
            [aPeripheral discoverCharacteristics:nil forService:aService];
        }
    }
}


// 周边对象找到服务后 调用-[discoverCharacteristics:forService:] 查看其中的特征值
// 在这个方法中你能拿到连接上的周边对象的服务uuid和 特征UUID ,
// 对于需要发送数据和接受数据特征，要保存起来，同时打开监听
- (void) peripheral:(CBPeripheral *)aPeripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
    NSLog(@"<蓝牙灯>外设名 : %@", service.UUID);
    NSLog(@"<蓝牙灯>外设的特征信息 :%@",service.characteristics);
    
    if (service.isPrimary) {
        NSLog(@"<蓝牙灯>基础的外设 : %@", service.UUID);
    }
    
    if ([service.UUID isEqual: [CBUUID UUIDWithString:@"1000"]])
    {
        for (CBCharacteristic *aChar in service.characteristics)
        {
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:@"1001"]]) {
                
                NSLog(@"<蓝牙灯>找到了通道特征: %@", aChar.UUID);
                self.Characteristic1001 = aChar;
            }
            
            else if ([aChar.UUID isEqual:[CBUUID UUIDWithString:@"1002"]]) {
                
                self.Characteristic1002 = aChar;
                
                [aPeripheral setNotifyValue:YES forCharacteristic:self.Characteristic1002];
                [aPeripheral readValueForCharacteristic:self.Characteristic1002];
            }
        }
    }
    
    [self sendPSW];
    // 延迟执行方法,确保数据传输
    [self performSelector:@selector(sendPSW) withObject:nil afterDelay:0.2];
    
    [self performSelector:@selector(sendPSW) withObject:nil afterDelay:0.5];
    
    
}

// didUpdateNotificationStateForCharacteristic
//- (void)peripheral:(CBPeripheral *)peripheral
//didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic
//             error:(NSError *)error
//{
//    if (error) NSLog(@"<蓝牙灯>交互错误: %@", error.localizedDescription);
//    
//    if (characteristic.isNotifying)
//    {
//        NSLog(@"<蓝牙灯>手机给外设发送的特征 %@", characteristic);
//        [peripheral readValueForCharacteristic:characteristic];
//    }
//    
//}

// didUpdateValueForCharacteristic
//- (void) peripheral:(CBPeripheral *)aPeripheral
//didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
//              error:(NSError *)error
//{
//    
//    if (error) NSLog(@"<蓝牙灯>更新特征的错误信息 %@", error.localizedDescription);
//    
//    NSLog(@"<蓝牙灯>外设更新的值 :%@",characteristic.value);
//    NSLog(@"<蓝牙灯>已更新的通道特征--UUID :%@",characteristic.UUID);
//    NSData *data = characteristic.value;
//    NSLog(@"<蓝牙灯>数据长度data.length = %lu %@",(unsigned long)data.length, data);
//    
//    
//}

// didWriteValueForCharacteristic
//- (void)peripheral:(CBPeripheral *)_peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
//{
//    NSLog(@"<蓝牙灯>发送成功");
//    NSLog(@"<蓝牙灯>有以下特征 :%@",characteristic);
//    if (error)
//    {
//        NSLog(@"<蓝牙灯>写入特征的值失败 %@, reason: %@", characteristic, error);
//    }
//    else
//    {
//        NSLog(@"<蓝牙灯>旧的特征值 %@, 新的特征值: %@", characteristic, [characteristic value]);
//    }
//}

#pragma mark - 🚫 私有方法 🚫🚫🚫🚫🚫🚫🚫🚫🚫🚫

// 判断手机蓝牙状态
-(BOOL)isBluetoothAvailable{
    
    // 只有当蓝牙可用时返回YES
    if (self.manager.state == CBCentralManagerStatePoweredOn) {
        return YES;
    } else {
        return NO;
    }
    
}

#pragma mark 🔒 给蓝牙设备发送数据

// 给蓝牙灯设备发送命令
- (void)sendData:(void(^)(char *p))block{
    
    char charArray[17] = {0x00};//定义一个字节数组
    // 协议头：0x55 0xaa 2字节
    charArray[0] = 0x55;  //16进制
    charArray[1] = 0xaa;  //10进制
    
    // 调用block执行剩下的字节赋值操作
    block(&charArray[2]);
    
    //打包成data
    NSData* data = [NSData dataWithBytes:(const void *)charArray length:sizeof(char) * 17];
    NSLog(@"<sendData>发送的数据%@",data);
    
    [self.peripheral writeValue:data forCharacteristic:self.Characteristic1001 type:CBCharacteristicWriteWithResponse];
    
}

// 发送密码
- (void)sendPSW
{
    
    [self sendData:^(char *p) {
        *p++ = 0x30;
    }];
    
}


#pragma mark ♻️ 单例实现

// allocWithZone
+ (id) allocWithZone:(NSZone *)zone
{
    
    if (!iPhone) {  //防止频繁加锁
        
        // Thread synchronization, guarantee in the case of multi-threaded, also can create an object.
        // 线程同步, 保证在多线程的情况下, 也只能创建出一个对象
        @synchronized (self) {
            // It won't create a new instance as long as the instance is not released.
            // 只要实例没有被释放, 就不会创建新的实例
            if (!iPhone) {
                iPhone = [super allocWithZone:zone];
            }
        }
        
    }
    
    return iPhone;
    
}

// init
- (id) init
{
    
    if (!iPhone) {  //防止频繁加锁
        
        @synchronized(self) {  //多线程情况下，加锁，避免多次实例化
            
            if (!iPhone) {  //防止已经实例化的情况下，再次实例化
                
                iPhone = [[ATCentralManager alloc] init];
                
            }
            
        }
        
    }
    
    // 在这里初始化对象属性
    
    
    _manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    _manager.delegate = self;
    _isConnecting = NO;
    _isBluetoothAvailable = NO;
    _isScaning = NO;
    
    _scanedDeviceList = [NSMutableArray array];
    
    
    return iPhone;
    
}

// copyWithZone
+ (id)copyWithZone:(struct _NSZone *)zone
{
    return [self sharedCentralManager];
}

// copyWithZone
- (id)copyWithZone:(struct _NSZone *)zone
{
    return [ATCentralManager sharedCentralManager];
}

// mutableCopyWithZone
+ (id)mutableCopyWithZone:(struct _NSZone *)zone
{
    return [self sharedCentralManager];
}

// mutableCopyWithZone
- (id)mutableCopyWithZone:(struct _NSZone *)zone
{
    return [ATCentralManager sharedCentralManager];
}

// copy
+ (id)copy
{
    return [ATCentralManager sharedCentralManager];
}




@end
