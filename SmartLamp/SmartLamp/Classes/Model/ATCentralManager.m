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

// central manager
@property (strong, nonatomic) CBCentralManager *manager;

// characteristic
@property (strong, nonatomic) CBCharacteristic *characteristic1001;
@property (strong, nonatomic) CBCharacteristic *characteristic1002;
@property (strong, nonatomic) CBCharacteristic *characteristic1003;
@property (strong, nonatomic) CBCharacteristic *characteristic1004;
@property (strong, nonatomic) CBCharacteristic *characteristic1005;

// timer for scan
@property (strong, nonatomic) NSTimer *scanTimer;
@property (assign, nonatomic) CGFloat scanTimerProgress;
// timer for data
@property (strong, nonatomic) NSTimer *dataTimer;
// timer for brightness
@property (strong, nonatomic) NSTimer *brightTimer;
// current brightness
@property (assign, nonatomic) CGFloat currentBrightness;

@end
// timeout for scan
static NSTimeInterval scaningTimeout = 5;
#pragma mark flag
// is scannable
static BOOL isScannable;
// is scaning
static BOOL isScaning = NO;
// is scaned new device
static BOOL isScanedNewDevice = NO;
// is connected
static BOOL isConnected = NO;
// can send data
static BOOL canSendData = NO;
// the smart lamp is turn on or not
static BOOL isTurnOn = NO;

@implementation ATCentralManager

#pragma mark - public methods

#pragma mark scan

// start scan with auto timeout
- (void)startScanWithAutoTimeout{
    // start scan if manager is scannable and not scaning
    if (isScannable && !self.scanTimerProgress && !isScaning) {
        
        // ==================== [ init a timer ] ==================== //
        self.scanTimerProgress = 1;
        [self.scanTimer invalidate];
        
        // ==================== [ scan ] ==================== //
        [self startScan];
        ATLogString(@"scan start!--------------");
        self.scanTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(scaning:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.scanTimer forMode:NSRunLoopCommonModes];
        
    }
}

// start scan
- (void)startScan{
    // start scan only if manager is not scaning
    if (!isScaning) {
        // send rac signal
        [self.didScaning sendNext:nil];
        // start scan
        [self.manager scanForPeripheralsWithServices:nil options:nil];
        // mark status
        isScaning = YES;
    }
}

// stop scan
- (void)stopScan{
    // stop scan only if manager is scaning
    if (isScaning) {
        // send rac signal
        [self.didStopScan sendNext:nil];
        // stop scan
        [self.manager stopScan];
        // mark status
        isScaning = NO;
        ATLogString(@"scan stopped!------------");
        // make timer invalidate
        self.scanTimerProgress = 0;
        [self.scanTimer invalidate];
    }
}


#pragma mark connect

// connect smart lamp
- (void)connectSmartLamp:(CBPeripheral *)smartLamp{
    // connect only if manager is not connected
    if (!isConnected) {
        // save peripheral
        self.connectedPeripheral = smartLamp;
        // connect if owned
        if (self.connectedPeripheral) {
            // connect
            [self.manager connectPeripheral:self.connectedPeripheral options:nil];
        }
    }
}

// disconnect
- (void)disConnectSmartLamp{
    // disconnect only if manager is connected
    if (isConnected) {
        // disconnect
        [self.manager cancelPeripheralConnection:self.connectedPeripheral];
        // log
        ATLogString(@"disconnect!");
    }
}

// connect or disconnect
- (void)connectOrDisconnect{
    if (isConnected) {
        [self disConnectSmartLamp];
    } else{
        [self startScanWithAutoTimeout];
    }
}

#pragma mark turn on or turn off

// turn on or turn off
- (void)letSmartLampTurnOnIf:(BOOL)isYes{

    // turn on or turn off only if manager is connected
    if (isConnected) {
        // turn on
        if (isYes) {
            // send rac signal
            [self.didTurnOn sendNext:nil];
            [self letSmartLampUpdateAllStatus];
        }
        // turn off
        else {
            // send rac signal
            [self.didTurnOff sendNext:nil];
            // turn off direct if performing color animation
            if (self.currentProfiles.colorAnimation != ColorAnimationNone) {
                self.currentBrightness = self.currentProfiles.brightness;
                self.currentProfiles.brightness = 0;
                [self letSmartLampUpdateBrightness];
            }
            // turn off by fading
            else{
                self.currentBrightness = self.currentProfiles.brightness;
                if (!_brightTimer) {
                    self.brightTimer = [NSTimer timerWithTimeInterval:0.05f target:self selector:@selector(turnOff) userInfo:nil repeats:YES];
                    [[NSRunLoop mainRunLoop] addTimer:self.brightTimer forMode:NSRunLoopCommonModes];
                }
            }
        }
    }
    // start scan if manager is not connected
    else{
        [self startScanWithAutoTimeout];
    }
    
}

// sleep mode
- (void)letSmartLampPerformSleepMode{
    
    NSTimeInterval minutes = self.currentProfiles.timer;
    // perform sleep mode only if minutes is available
    if (isConnected&&minutes) {
        // make minutes available if not
        if (minutes < 5) minutes = 5;
        if (minutes > 120)minutes = 120;
        // send data
        [self sendData:^(char *p) {
            *p++ = 0x04;    // sleep mode
            *p++ = minutes; // minutes (5~120)
        }];
    }
    
}


#pragma mark control

// brightness
- (void)letSmartLampUpdateBrightness{
    [self letSmartLampUpdateColor];
}

// color
- (void)letSmartLampUpdateColor{
    
    // update color only if manager is connected
    if (isConnected) {
        // get RGBA from UIColor
        CGFloat red=0,green=0,blue=0,bright=self.currentProfiles.brightness;
        [self.currentProfiles.color getRed:&red green:&green blue:&blue alpha:nil];
        // send data
        [self sendData:^(char *p) {
            *p++ = 0x07;                // device status
            *p++ = (int)(255 * red);    // r
            *p++ = (int)(255 * green);  // g
            *p++ = (int)(255 * blue);   // b
            *p++ = 0x00;                // w
            *p++ = (int)(255 * bright); // brt
        }];
        // send rac signal
        [self.didPerformColorAnimation sendNext:@NO];
    }
}

// color animation
- (void)letSmartLampPerformColorAnimation{
    // perform color animation only if manager is connected
    if (isConnected) {
        // send data
        int animation = self.currentProfiles.colorAnimation;
        [self sendData:^(char *p) {
            *p++ = animation;           // animation mode
        }];
        // send rac signal
        [self.didPerformColorAnimation sendNext:@YES];
    }
}

// update all status
- (void)letSmartLampUpdateAllStatus{
    
    // perform color animation if possible
    if (self.currentProfiles.colorAnimation != ColorAnimationNone) {
        self.currentProfiles.brightness = 1.0f;
        [self letSmartLampPerformColorAnimation];
    }
    // or update color and brightness
    else{
        self.currentBrightness = self.currentProfiles.brightness;
        if (!isTurnOn) {
            self.currentProfiles.brightness = 0;
        }
        if (!_brightTimer) {
            self.brightTimer = [NSTimer timerWithTimeInterval:0.05 target:self selector:@selector(turnOn) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.brightTimer forMode:NSRunLoopCommonModes];
        }
        
    }
    // perform sleep mode if possible
    if (self.currentProfiles.timer) {
        [self letSmartLampPerformSleepMode];
    }
    
}

// apply aProfiles
- (void)letSmartLampApplyProfiles:(ATProfiles *)aProfiles {
    self.currentProfiles = aProfiles;
    [self letSmartLampTurnOnIf:YES];
}

#pragma mark creator

// defaultCentralManager
+ (instancetype)defaultCentralManager{
    
    return [self sharedCentralManager];
    
}

// sharedCentralManager
+ (id)sharedCentralManager
{
    
    if (!iPhone) {
        // Thread synchrone, guarantee in the case of multi-threaded, also can create an object.
        @synchronized (self) {
            // It won't create a new instance as long as the instance is not released.
            if (!iPhone) {
                iPhone = [[ATCentralManager alloc]init];
            }
        }
    }
    
    return iPhone;
    
}

#pragma mark - core bluetooth delegate

#pragma mark central manager delegate

// did update state
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    isScannable = NO;
    // state
    switch (self.manager.state)
    {
            
        case CBCentralManagerStateUnknown:     // unknown
            break;
        case CBCentralManagerStateResetting:   // resetting
            break;
        case CBCentralManagerStateUnsupported: // unsupported
            ATLogFailTips(@"CBCentralManagerStateUnsupported");
            break;
        case CBCentralManagerStateUnauthorized:// unauthorized
            ATLogFailTips(@"CBCentralManagerStateUnauthorized");
            break;
        case CBCentralManagerStatePoweredOff:  // powered off
            ATLogFailTips(@"CBCentralManagerStatePoweredOff");
            break;
        case CBCentralManagerStatePoweredOn:   // powered on
            isScannable = YES;
            ATLogSuccessTips(@"CBCentralManagerStatePoweredOn");
            break;
    }
    
}

// did discover peripheral
- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)aPeripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    
    // ==================== [ filter ] ==================== //
    // contains "KQX"
    if ([aPeripheral.name containsString:@"KQX"]) {
        
        // save peripheral only if list doesn't contains it
        if (![self.scanedDeviceList containsObject:aPeripheral]) {
            [self.scanedDeviceList addObject:aPeripheral];
        }
        // send rac signal
        [self.didDeviceFound sendNext:nil];
    }
    
}

// did connect success
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)aPeripheral
{
    
    ATLogSuccessTips(aPeripheral.name);
    // set delegate
    aPeripheral.delegate = self;
    // mark status
    isConnected = YES;
    
    // send rac signal
    [self.didConnectSuccess sendNext:nil];
    
    // discover services
    [aPeripheral discoverServices:nil];
    
    // stop scan
    [self stopScan];
    
}

// disconnect
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)aPeripheral error:(NSError *)error
{
    // mark status
    isConnected = NO;
    // send rac signal
    [self.didDisconnect sendNext:nil];
    // disconnect only if manager is connected
    if(self.connectedPeripheral)
    {
        // remove delegate
        self.connectedPeripheral.delegate = nil;
        // remove connected peripheral
        self.connectedPeripheral = nil;
    }
    
}

// connect fail
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)aPeripheral error:(NSError *)error
{
    
    ATLogFailTips(error.localizedDescription);
    // send rac signal
    [self.didConnectFail sendNext:nil];
    // disconnect only if manager is connected
    if(self.connectedPeripheral)
    {
        // remove delegate
        self.connectedPeripheral.delegate = nil;
        // remove connected peripheral
        self.connectedPeripheral = nil;
    }
    
}

#pragma mark peripheral delegate

// did discover services
- (void)peripheral:(CBPeripheral *)aPeripheral didDiscoverServices:(NSError *)error
{
    // for-in services
    for (CBService *aService in aPeripheral.services)
    {
        
        ATLogDetail(@"discover aService ,UUID",aService.UUID);
        // UUID:1000
        if ([aService.UUID isEqual:[CBUUID UUIDWithString:@"1000"]]){
            // discover characteristic
            [aPeripheral discoverCharacteristics:nil forService:aService];
        }
        
        // UUID: FFE0
        if ([aService.UUID isEqual:[CBUUID UUIDWithString:@"FFE0"]]){
            [aPeripheral discoverCharacteristics:nil forService:aService];
        }
    }
}

// did discover characteristic
- (void) peripheral:(CBPeripheral *)aPeripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
    ATLogDetail(service.UUID, service.characteristics);
    // UUID:1000
    if ([service.UUID isEqual: [CBUUID UUIDWithString:@"1000"]])
    {
        // for-in characteristic
        for (CBCharacteristic *aChar in service.characteristics)
        {
            // UUID:1001
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:@"1001"]]) {
                ATLogDetail(@"discover characteristics", aChar.UUID);
                // save Characteristic1001
                self.characteristic1001 = aChar;
            }
            // UUID:1002
            else if ([aChar.UUID isEqual:[CBUUID UUIDWithString:@"1002"]]) {
                // save Characteristic1002
                self.characteristic1002 = aChar;
                // set notify value for Characteristic1002
                [aPeripheral setNotifyValue:YES forCharacteristic:self.characteristic1002];
                // read value for Characteristic1002
                [aPeripheral readValueForCharacteristic:self.characteristic1002];
            }
        }
    }
    
    // send password
    [self sendPSW];
    // send password again
    [self performSelector:@selector(sendPSW) withObject:nil afterDelay:0.2];
    // send password
    [self performSelector:@selector(sendPSW) withObject:nil afterDelay:0.5];
    
    // turn on smart lamp after a second
    [self performSelector:@selector(letSmartLampTurnOn) withObject:nil afterDelay:1.0];
    
}

// turn on
- (void)letSmartLampTurnOn{
    [self letSmartLampTurnOnIf:YES];
}

// did update notification state for characteristic
- (void)peripheral:(CBPeripheral *)peripheral
didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error
{
    // if error
    if (error) ATLogFailTips(error.localizedDescription);
    ATLogString(@"update state for characteristic!");
    // read state if notifying
    if (characteristic.isNotifying)
    {
        ATLogDetail(@"read value for characteristic", characteristic);
        [peripheral readValueForCharacteristic:characteristic];
    }
    
}

// did update value for characteristic
- (void) peripheral:(CBPeripheral *)aPeripheral
didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
              error:(NSError *)error
{
    // if error
    if (error) ATLogFailTips(error.localizedDescription);
    // read new state
    ATLogString(@"update value for characteristic!");
    ATLogDetail(characteristic.UUID,characteristic.value);
    
}

// did write value for characteristic
- (void)peripheral:(CBPeripheral *)_peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    ATLogDetail(@"write value for characteristic",characteristic);
    // if error
    if (error) ATLogDetail(@"write fail", characteristic);
    
}

#pragma mark - private methods

- (void)setScanedDeviceList:(NSMutableArray<CBPeripheral *> *)scanedDeviceList{
    _scanedDeviceList = scanedDeviceList;
    isScanedNewDevice = YES;
}

// scaning
- (void)scaning:(id)sender{
    
    // progress
    self.scanTimerProgress += 1.0;
    ATLogString(@"scaning...");
    // if scaned new device or timeout
    if (isScanedNewDevice||self.scanTimerProgress>scaningTimeout) {
        isScanedNewDevice = NO;
        // stop scan
        [atCentralManager stopScan];
        // reset timer
        self.scanTimerProgress = 0;
        [self.scanTimer invalidate];
        self.scanTimer = nil;
        // if not found
        if (!isScanedNewDevice) {
            // send rac signal
            [self.didNotFound sendNext:nil];
        }
        
    }
    
}

// turn on
- (void)turnOn{
    self.currentProfiles.brightness += 0.05;
    if (self.currentProfiles.brightness < self.currentBrightness) {
    } else{
        self.currentProfiles.brightness = self.currentBrightness;
        [_brightTimer invalidate];
        _brightTimer = nil;
    }
    [self letSmartLampUpdateBrightness];
    isTurnOn = YES;
}

// turn off
- (void)turnOff{
    self.currentProfiles.brightness -= 0.05;
    if (self.currentProfiles.brightness > 0) {
        [self letSmartLampUpdateBrightness];
    } else{
        self.currentProfiles.brightness = 0;
        [self letSmartLampUpdateBrightness];
        self.currentProfiles.brightness = self.currentBrightness;
        [_brightTimer invalidate];
        _brightTimer = nil;
    }
    isTurnOn = NO;
}

#pragma mark send data

// send data to peripheral
- (void)sendData:(void(^)(char *p))operation{
    if (canSendData) {
        canSendData = NO;
        char charArray[17] = {0x00};
        // protocol header : 0x55 0xaa
        charArray[0] = 0x55;
        charArray[1] = 0xaa;
        
        // the last operation
        operation(&charArray[2]);
        
        // package data
        NSData *data = [NSData dataWithBytes:(const void *)charArray length:sizeof(char) * 17];
        // write value (send data) to characteristic1001
        [self.connectedPeripheral writeValue:data forCharacteristic:self.characteristic1001 type:CBCharacteristicWriteWithResponse];
        ATLogString(data);
        // send rac signal
        [self.didSendData sendNext:nil];
    }
    
}

// enable to send data
- (void)enableToSendData{
    canSendData = YES;
}

// send password
- (void)sendPSW{
    [self sendData:^(char *p) {
        *p++ = 0x30;
    }];
}

#pragma mark life circle

// allocWithZone
+ (id) allocWithZone:(NSZone *)zone
{
    
    if (!iPhone) {
        
        // Thread synchronization, guarantee in the case of multi-threaded, also can create an object.
        @synchronized (self) {
            // It won't create a new instance as long as the instance is not released.
            if (!iPhone) {
                iPhone = [super allocWithZone:zone];
            }
        }
    }
    
    return iPhone;
    
}

// init
- (instancetype)init{
    
    if (!iPhone){
        @synchronized(self){
            if (!iPhone){
                iPhone = [[ATCentralManager alloc] init];
            }
        }
    }
    
    // init property
    _manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    _scanedDeviceList = [NSMutableArray array];
    // enable send data every 0.04s
    _dataTimer = [NSTimer timerWithTimeInterval:0.04f target:self selector:@selector(enableToSendData) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_dataTimer forMode:NSRunLoopCommonModes];
    // get current profiles
    _currentProfiles = [ATFileManager readCache]?[ATFileManager readCache]:[ATProfiles defaultProfiles];
    
    // init rac signal
    _didScaning = [RACSubject subject];
    _didStopScan = [RACSubject subject];
    _didDeviceFound = [RACSubject subject];
    _didNotFound = [RACSubject subject];
    _didConnectSuccess = [RACSubject subject];
    _didConnectFail = [RACSubject subject];
    _didDisconnect = [RACSubject subject];
    _didTurnOn = [RACSubject subject];
    _didTurnOff = [RACSubject subject];
    _didPerformColorAnimation = [RACSubject subject];
    _didSendData = [RACSubject subject];
    
    
    
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
