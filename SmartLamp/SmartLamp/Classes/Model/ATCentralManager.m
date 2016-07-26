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

#define atNotificationCenter [NSNotificationCenter defaultCenter]

ATCentralManager *iPhone;

@interface ATCentralManager ()

// 中心设备
@property (strong, nonatomic) CBCentralManager *manager;

// 特征
@property (strong, nonatomic) CBCharacteristic *Characteristic1001;
@property (strong, nonatomic) CBCharacteristic *Characteristic1002;
@property (strong, nonatomic) CBCharacteristic *Characteristic1003;
@property (strong, nonatomic) CBCharacteristic *Characteristic1004;
@property (strong, nonatomic) CBCharacteristic *Characteristic1005;

// 扫描定时器
@property (strong, nonatomic) NSTimer *scanTimer;
@property (assign, nonatomic) CGFloat scanTimerProgress;
// 传输数据的定时器
@property (strong, nonatomic) NSTimer *dataTimer;
// 调整亮度的定时器
@property (strong, nonatomic) NSTimer *brightTimer;
// 当前亮度
@property (assign, nonatomic) CGFloat currentBrightness;

@end
// 扫描超时
static NSTimeInterval scaningTimeout = 5;
#pragma mark 状态标记
// 是否可扫描(蓝牙状态是否打开)
static BOOL isScannable;
// 是否正在扫描
static BOOL isScaning = NO;
// 是否扫描到了新设备
static BOOL isScanedNewDevice = NO;
// 是否是已连接的
static BOOL isConnected = NO;
// 是否可发送数据
static BOOL canSendData = NO;
// 灯是否打开
static BOOL isTurnOn = NO;
@implementation ATCentralManager

#pragma mark - 公有方法

#pragma mark 扫描

// 自动超时扫描
- (void)startScanWithAutoTimeout{
    // 正在搜索的时候又触发了搜索方法, 就忽略重复指令
    // 只有在scanTimerProgress为0的时候才执行
    // 只有在可以扫描并且没有扫描的状态下才执行开始扫描指令(防止重复执行)
    if (isScannable && !self.scanTimerProgress && !isScaning) {
        
        // ==================== [ 初始化定时器 ] ==================== //
        // 必须置为非0值,防止重复执行
        self.scanTimerProgress = 1;
        [self.scanTimer invalidate];
        [self.scanTimer fire];
        
        // ==================== [ 扫描 ] ==================== //
        [self startScan];
        LOG(@"<扫描>-------开始扫描-------");
        // 每隔一段时间查看一次 self.iPhone.scanedDeviceList
        self.scanTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scaning:) userInfo:nil repeats:YES];
        
    }
}

// 开始扫描
- (void)startScan{
    // 只有在没有扫描的状态下才执行开始扫描指令(防止重复执行)
    // ==================== [ 扫描 ] ==================== //
    if (!isScaning) {
        [atNotificationCenter postNotificationName:NOTI_BLE_SCAN object:NOTI_BLE_SCAN_START];
        // 开始扫描
        [self.manager scanForPeripheralsWithServices:nil options:nil];
        // 状态标记
        isScaning = YES;
    }
}

// 停止扫描
- (void)stopScan{
    // 只有在扫描的状态下才执行停止扫描的指令
    if (isScaning) {
        [atNotificationCenter postNotificationName:NOTI_BLE_SCAN object:NOTI_BLE_SCAN_STOP];
        // 停止扫描
        [self.manager stopScan];
        // 状态标记
        isScaning = NO;
        NSLog(@"<扫描>-------停止扫描-------");
        self.scanTimerProgress = 0;
        [self.scanTimer invalidate];// 销毁定时器
    }
}


#pragma mark 连接

// 建立连接
- (void)connectSmartLamp:(CBPeripheral *)smartLamp{
    // 只有在未连接给定蓝牙灯的状态下才执行建立连接的指令
    if (!isConnected) {
        // 把传入指定的设备赋值给单例中的属性
        self.connectedPeripheral = smartLamp;
        // 如果拥有对象, 就连接
        if (self.connectedPeripheral) {
            // 调用连接周边设备的方法
            [self.manager connectPeripheral:self.connectedPeripheral options:nil];
            // 状态标记写在代理中
        }
    }
}

// 断开连接
- (void)disConnectSmartLamp{
    // 只有在连接的状态下才执行断开连接的指令
    if (isConnected) {
        // 调用断开连接的方法
        [self.manager cancelPeripheralConnection:self.connectedPeripheral];
        // 状态标记写在代理中
        // 控制台输出
        NSLog(@"蓝牙设备已断开");
    }
}

// 连接或断开连接
- (void)connectOrDisconnect{
    if (isConnected) {
        [self disConnectSmartLamp];
    } else{
        [self startScanWithAutoTimeout];
    }
}

#pragma mark 开关

// 电源开关
- (void)letSmartLampTurnOnIf:(BOOL)isYes{

    // 只有在连接的状态下才执行开关电源的指令
    if (isConnected) {
        
        // 开灯
        if (isYes) {
            [atNotificationCenter postNotificationName:NOTI_BLE_STATUS object:NOTI_BLE_STATUS_TURNON];
            [self letSmartLampUpdateAllStatus];
            
        }
        // 关灯
        else {
            [atNotificationCenter postNotificationName:NOTI_BLE_STATUS object:NOTI_BLE_STATUS_TURNOFF];
            // 如果有动画, 就直接关灯
            if (self.currentProfiles.colorAnimation != ColorAnimationNone) {
                self.currentBrightness = self.currentProfiles.brightness;
                self.currentProfiles.brightness = 0;
                [self letSmartLampUpdateBrightness];
            }
            // 单色模式逐渐变暗
            else{
                self.currentBrightness = self.currentProfiles.brightness;
                if (!_brightTimer) {
                    _brightTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(turnOff) userInfo:nil repeats:YES];
                }
            }
            
        }
        
    }
    // 如果没有连接, 就开始扫描
    else{
        [self startScanWithAutoTimeout];
    }
    
}

// 设置定时关机
- (void)letSmartLampPerformSleepMode{
    
    NSTimeInterval minutes = self.currentProfiles.timer;
    // 只有在连接的状态下才执行定时关机的指令
    if (isConnected&&minutes) {
        
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


#pragma mark 控制

// 设置亮度
- (void)letSmartLampUpdateBrightness{
    [self letSmartLampUpdateColor];
}

// 设置颜色
- (void)letSmartLampUpdateColor{
    
    // 只有在连接的状态下才执行设置颜色的指令
    if (isConnected) {
        // 提取出UIColor中的RGB值
        CGFloat red=0,green=0,blue=0,bright=self.currentProfiles.brightness;
        [self.currentProfiles.color getRed:&red green:&green blue:&blue alpha:nil];
        // 调用发送数据的Block
        [self sendData:^(char *p) {
            *p++ = 0x07;                // 设备状态输出
            *p++ = (int)(255 * red);    // r
            *p++ = (int)(255 * green);  // g
            *p++ = (int)(255 * blue);   // b
            *p++ = 0x00;                // w
            *p++ = (int)(255 * bright); // brt
        }];
    }
}

// 设置动画
- (void)letSmartLampPerformColorAnimation{
    // 只有在连接的状态下才执行设置动画的指令
    if (isConnected) {
        // 调用发送数据的Block
        int animation = self.currentProfiles.colorAnimation;
        [self sendData:^(char *p) {
            *p++ = animation;           // 动画
        }];
    }
}

// 更新蓝牙灯的所有状态
- (void)letSmartLampUpdateAllStatus{
    
    // 如果有动画, 就显示动画效果
    if (self.currentProfiles.colorAnimation != ColorAnimationNone) {
        self.currentProfiles.brightness = 1.0f;
        [self letSmartLampPerformColorAnimation];
    }
    // 否则就显示单色模式(包含亮度)
    else{
        self.currentBrightness = self.currentProfiles.brightness;
        if (!isTurnOn) {
            self.currentProfiles.brightness = 0;
        }
        if (!_brightTimer) {
            _brightTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(turnOn) userInfo:nil repeats:YES];
        }
        
    }
    
    // 如果有定时关机,
    if (self.currentProfiles.timer) {
        [self letSmartLampPerformSleepMode];
    }
    
}

// 应用情景模式
- (void)letSmartLampApplyProfiles:(ATProfiles *)aProfiles {
    self.currentProfiles = aProfiles;
    [self letSmartLampTurnOnIf:YES];
}

#pragma mark 构造方法

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

#pragma mark -  代理方法

#pragma mark 中心设备的代理方法

// 当中心设备的状态更新了的时候
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    isScannable = NO;
    // 分析蓝牙状态
    switch (self.manager.state)
    {
            
        case CBCentralManagerStateUnknown: // 未知状态
            break;
        case CBCentralManagerStateResetting: // 正在重置
            break;
        case CBCentralManagerStateUnsupported: // 蓝牙不支持
            NSLog(@"<代理>蓝牙不支持");
            [atNotificationCenter postNotificationName:NOTI_BLE_AVAILABLE object:@"设备蓝牙不支持"];
            break;
        case CBCentralManagerStateUnauthorized: // 应用没有权限
            NSLog(@"<代理>应用没有权限");
            [atNotificationCenter postNotificationName:NOTI_BLE_AVAILABLE object:@"应用没有权限"];
            break;
        case CBCentralManagerStatePoweredOff: // 蓝牙已经关闭
            NSLog(@"<代理>蓝牙已经关闭");
            [atNotificationCenter postNotificationName:NOTI_BLE_AVAILABLE object:@"蓝牙已经关闭"];
            break;
        case CBCentralManagerStatePoweredOn: // 蓝牙已经打开
            NSLog(@"<代理>蓝牙已经打开");
            NSLog(@"<代理>蓝牙可用");
            [atNotificationCenter postNotificationName:NOTI_BLE_AVAILABLE object:@"蓝牙可用"];
            isScannable = YES;
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
            
        }
        // 发送通知
        NSString *device = [NSString stringWithFormat:@"已发现蓝牙设备<%@>,是否连接?",aPeripheral.name];
        NSLog(@"%@",device);
        // 发送通知
        [atNotificationCenter postNotificationName:NOTI_BLE_SCAN object:NOTI_BLE_SCAN_FOUND];
    }
    
}

// 连接成功的时候
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)aPeripheral
{
    
    NSLog(@"<手机>已连接: %@", aPeripheral.name);
    // 连接成功后设置代理
    aPeripheral.delegate = self;
    NSLog(@"<手机>代理设置成功");
    // 状态标记写在代理中
    isConnected = YES;
    
    // 发送通知
    [atNotificationCenter postNotificationName:NOTI_BLE_CONNECT object:NOTI_BLE_CONNECT_SUCCESS];
    // 同时开始 查看这个周边对象服务 会在以下的方法回调
    //- (void) peripheral:(CBPeripheral *)aPeripheral didDiscoverServices:(NSError *)error;
    [aPeripheral discoverServices:nil];
    
    // 停止扫描
    [self stopScan];
    
    
    
}

// 周边对象与中心断开连接的时候
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)aPeripheral error:(NSError *)error
{
    // 状态标记写在代理中
    isConnected = NO;
    // 如果中心设备拥有一个周边对象
    if(self.connectedPeripheral)
    {
        // 取消代理
        self.connectedPeripheral.delegate = nil;
        // 清空中心设备拥有的周边对象
        self.connectedPeripheral = nil;
        // 发送通知
        [atNotificationCenter postNotificationName:NOTI_BLE_CONNECT object:NOTI_BLE_CONNECT_DISCONNECT];
    }
    
}

// 中心与周边对象连接失败的时候
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)aPeripheral error:(NSError *)error
{
    NSLog(@"<手机>与%@连接失败. 错误信息是: %@", aPeripheral, [error localizedDescription]);
    // 发送通知
    [atNotificationCenter postNotificationName:NOTI_BLE_CONNECT object:NOTI_BLE_CONNECT_FAIL];
    // 如果中心设备拥有一个周边对象
    if(self.connectedPeripheral)
    {
        // 取消代理
        self.connectedPeripheral.delegate = nil;
        // 清空中心设备拥有的周边对象
        self.connectedPeripheral = nil;
    }
}

#pragma mark 蓝牙设备代理方法

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
    
    [self performSelector:@selector(letSmartLampTurnOn) withObject:nil afterDelay:1.0];
    
}

- (void)letSmartLampTurnOn{
    [self letSmartLampTurnOnIf:YES];
}


// didUpdateNotificationStateForCharacteristic
- (void)peripheral:(CBPeripheral *)peripheral
didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error
{
    if (error) NSLog(@"<蓝牙灯>交互错误: %@", error.localizedDescription);
    
    if (characteristic.isNotifying)
    {
        NSLog(@"<蓝牙灯>手机给外设发送的特征 %@", characteristic);
        [peripheral readValueForCharacteristic:characteristic];
    }
    
}

// didUpdateValueForCharacteristic
- (void) peripheral:(CBPeripheral *)aPeripheral
didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
              error:(NSError *)error
{
    
    if (error) NSLog(@"<蓝牙灯>更新特征的错误信息 %@", error.localizedDescription);
    
    NSLog(@"<蓝牙灯>外设更新的值 :%@",characteristic.value);
    NSLog(@"<蓝牙灯>已更新的通道特征--UUID :%@",characteristic.UUID);
    NSData *data = characteristic.value;
    NSLog(@"<蓝牙灯>数据长度data.length = %lu %@",(unsigned long)data.length, data);
    
    
}

// didWriteValueForCharacteristic
- (void)peripheral:(CBPeripheral *)_peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"<蓝牙灯>发送成功");
    NSLog(@"<蓝牙灯>有以下特征 :%@",characteristic);
    if (error)
    {
        NSLog(@"<蓝牙灯>写入特征的值失败 %@, reason: %@", characteristic, error);
    }
    else
    {
        NSLog(@"<蓝牙灯>旧的特征值 %@, 新的特征值: %@", characteristic, [characteristic value]);
    }
}

#pragma mark - 私有方法

- (void)setScanedDeviceList:(NSMutableArray<CBPeripheral *> *)scanedDeviceList{
    _scanedDeviceList = scanedDeviceList;
    isScanedNewDevice = YES;
}

// 循环调用的方法
- (void)scaning:(id)sender{
    
    // 步进
    self.scanTimerProgress += 1.0;
    // 循环结束时调用(如果扫描到了设备或者时间超过)
    if (isScanedNewDevice||self.scanTimerProgress>scaningTimeout) {
        isScanedNewDevice = NO;
        // 停止扫描
        [atCentralManager stopScan];
        // 重置定时器
        self.scanTimerProgress = 0; // 计时进度恢复为0
        [self.scanTimer invalidate];// 销毁定时器
        [self.scanTimer fire];      // 销毁定时器
        // 如果循环结束时还没有扫描到设备
        if (!isScanedNewDevice) {
            // 发送通知
            [atNotificationCenter postNotificationName:NOTI_BLE_SCAN object:NOTI_BLE_SCAN_NOTFOUND];
        }
        
    }
    
}
// 渐亮开灯
- (void)turnOn{
    self.currentProfiles.brightness += 0.05;
    if (self.currentProfiles.brightness < self.currentBrightness) {
    } else{
        self.currentProfiles.brightness = self.currentBrightness;
        [_brightTimer invalidate];
        [_brightTimer fire];
        _brightTimer = nil;
    }
    [self letSmartLampUpdateBrightness];
    isTurnOn = YES;
}

// 渐暗关灯
- (void)turnOff{
    self.currentProfiles.brightness -= 0.05;
    if (self.currentProfiles.brightness > 0) {
        [self letSmartLampUpdateBrightness];
    } else{
        self.currentProfiles.brightness = 0;
        [self letSmartLampUpdateBrightness];
        self.currentProfiles.brightness = self.currentBrightness;
        [_brightTimer invalidate];
        [_brightTimer fire];
        _brightTimer = nil;
    }
    isTurnOn = NO;
}

#pragma mark 给蓝牙设备发送数据

// 给蓝牙灯设备发送命令
- (void)sendData:(void(^)(char *p))block{
    if (canSendData) {
        canSendData = NO;
        char charArray[17] = {0x00};//定义一个字节数组
        // 协议头：0x55 0xaa 2字节
        charArray[0] = 0x55;  //16进制
        charArray[1] = 0xaa;  //10进制
        
        // 调用block执行剩下的字节赋值操作
        block(&charArray[2]);
        
        //打包成data
        NSData* data = [NSData dataWithBytes:(const void *)charArray length:sizeof(char) * 17];
        LOG(data);
        [self.connectedPeripheral writeValue:data forCharacteristic:self.Characteristic1001 type:CBCharacteristicWriteWithResponse];
        
        // 发送通知
        [atNotificationCenter postNotificationName:NOTI_BLE_STATUS object:NOTI_BLE_STATUS_CHANGE];
        
    }
    
}

- (void)enableToSendData{
    canSendData = YES;
}

// 发送密码
- (void)sendPSW
{
    
    [self sendData:^(char *p) {
        *p++ = 0x30;
    }];
    
}

#pragma mark 单例实现

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
    _scanedDeviceList = [NSMutableArray array];
    // 每0.04秒允许发送一次数据
    _dataTimer = [NSTimer scheduledTimerWithTimeInterval:0.04 target:self selector:@selector(enableToSendData) userInfo:nil repeats:YES];
    
    _currentProfiles = [ATFileManager readCache]?[ATFileManager readCache]:[ATProfiles defaultProfiles];
    
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
