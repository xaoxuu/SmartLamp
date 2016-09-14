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

ATCentralManager *atCentral = nil;

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
@property (assign, nonatomic) CGFloat lastBrightness;

@end

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

@implementation ATCentralManager

+ (void)load{
    [self defaultManager];
}

#pragma mark - public methods

#pragma mark scan

// start scan with auto timeout
- (ATCentralManager *(^)())startScanWithAutoTimeout{
    // start scan if manager is scannable and not scaning
    if (isScannable) {
        if (!self.scanTimerProgress && !isScaning) {
            // ==================== [ init a timer ] ==================== //
            self.scanTimerProgress = 1;
            [self.scanTimer invalidate];
            
            // ==================== [ scan ] ==================== //
            self.startScan();
            ATLog(@"scan start!--------------");
            self.scanTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(scaning:) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.scanTimer forMode:NSRunLoopCommonModes];
        }
    } else {
        [self.didScannable sendNext:@NO];
    }
    return ^(){
        return self;
    };
}

// start scan
- (ATCentralManager *(^)())startScan{
    // start scan only if manager is not scaning
    if (!isScaning) {
        // send rac signal
        [self.didScaning sendNext:@YES];
        // start scan
        [self.manager scanForPeripheralsWithServices:nil options:nil];
        // mark status
        isScaning = YES;
    }
    return ^(){
        return self;
    };
}

// stop scan
- (ATCentralManager *(^)())stopScan{
    // stop scan only if manager is scaning
    if (isScaning) {
        // send rac signal
        [self.didScaning sendNext:@NO];
        // stop scan
        [self.manager stopScan];
        // mark status
        isScaning = NO;
        ATLog(@"scan stopped!------------");
        // make timer invalidate
        self.scanTimerProgress = 0;
        [self.scanTimer invalidate];
    }
    return ^(){
        return self;
    };
}


#pragma mark connect

// connect smart lamp
- (ATCentralManager *(^)(CBPeripheral *))connectSmartLamp{
    return ^(CBPeripheral *smartLamp){
        // connect only if manager is not connected
        if (!isConnected) {
            // save peripheral
            _aPeripheral = smartLamp;
            // connect if owned
            if (self.aPeripheral) {
                // connect
                [self.manager connectPeripheral:self.aPeripheral options:nil];
            }
        }
        return self;
    };
}

// disconnect
- (ATCentralManager *(^)())disConnectSmartLamp{
    // disconnect only if manager is connected
    if (isConnected) {
        // disconnect
        [self.manager cancelPeripheralConnection:self.aPeripheral];
        // log
        ATLog(@"disconnect!");
    }
    return ^(){
        return self;
    };
}

// connect or disconnect
- (ATCentralManager *(^)())connectOrDisconnect{
    if (isConnected) {
        [self disConnectSmartLamp];
    } else{
        self.startScanWithAutoTimeout();
    }
    return ^(){
        return self;
    };
}

#pragma mark turn on or turn off

- (ATCentralManager *(^)(BOOL))letSmartLampTurnOnOrOff{
    return ^(BOOL isYes){
        if (isYes) {
            self.letSmartLampTurnOn();
        }else{
            self.letSmartLampTurnOff();
        }
        return self;
    };
}
- (ATCentralManager *(^)())letSmartLampTurnOn{
    // turn on or turn off only if manager is connected
    if (isConnected) {
        // send rac signal
        [self.didTurnOn sendNext:@YES];
        // turn on
        self.letSmartLampUpdateAllStatus();
    }
    // start scan if manager is not connected
    else{
        // send rac signal
        [self.didTurnOn sendNext:@NO];
        self.startScanWithAutoTimeout();
    }
    return ^(){
        return self;
    };
}

// turn on or turn off
- (ATCentralManager *(^)())letSmartLampTurnOff{
    // turn on or turn off only if manager is connected
    if (isConnected) {
        // send rac signal
        [self.didTurnOn sendNext:@NO];
        // turn off direct if performing color animation
        if (self.aProfiles.colorMode != ATColorModeNone) {
            self.lastBrightness = self.aProfiles.brightness;
            self.aProfiles.brightness = 0;
            self.letSmartLampUpdateBrightness();
        }
        // turn off by fading
        else{
            self.lastBrightness = self.aProfiles.brightness;
            if (!_brightTimer) {
                self.brightTimer = [NSTimer timerWithTimeInterval:0.05f target:self selector:@selector(turnOff) userInfo:nil repeats:YES];
                [[NSRunLoop mainRunLoop] addTimer:self.brightTimer forMode:NSRunLoopCommonModes];
            }
        }
    }
    // start scan if manager is not connected
    else{
        self.startScanWithAutoTimeout();
    }
    return ^(){
        return self;
    };
}

// sleep mode
- (ATCentralManager *(^)())letSmartLampPerformSleepMode{
    
    NSTimeInterval minutes = self.aProfiles.timer;
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
    return ^(){
        return self;
    };
}


#pragma mark control

// color animation
- (ATCentralManager *(^)())letSmartLampPerformColorMode{
    // perform color animation only if manager is connected
    if (isConnected) {
        self.aProfiles.brightness = 1.0;
        // send data
        int animation = self.aProfiles.colorMode;
        [self sendData:^(char *p) {
            *p++ = animation;           // animation mode
        }];
        // send rac signal
        [self.didColorfulMode sendNext:@YES];
    }
    return ^(){
        return self;
    };
}

// brightness
- (ATCentralManager *(^)())letSmartLampUpdateBrightness{
    self.letSmartLampUpdateColor();
    return ^(){
        return self;
    };
}

// color
- (ATCentralManager *(^)())letSmartLampUpdateColor{
    
    // update color only if manager is connected
    if (isConnected) {
        // get RGBA from UIColor
        CGFloat red=0, green=0, blue=0, bright = self.aProfiles.brightness;
        [self.aProfiles.color getRed:&red green:&green blue:&blue alpha:nil];
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
        [self.didColorfulMode sendNext:@NO];
    }
    return ^(){
        return self;
    };
}


// update all status
- (ATCentralManager *(^)())letSmartLampUpdateAllStatus{
    
    // perform color animation if possible
    if (self.aProfiles.colorMode != ATColorModeNone) {
        self.aProfiles.brightness = 1.0f;
        self.letSmartLampPerformColorMode();
    }
    // or update color and brightness
    else{
        self.lastBrightness = self.aProfiles.brightness;
        if (!_isTurnOn) {
            self.aProfiles.brightness = 0;
        }
        if (!_brightTimer) {
            self.brightTimer = [NSTimer timerWithTimeInterval:0.05 target:self selector:@selector(turnOn) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.brightTimer forMode:NSRunLoopCommonModes];
        }
        
    }
    // perform sleep mode if possible
    if (self.aProfiles.timer) {
        self.letSmartLampPerformSleepMode();
    }
    
    return ^(){
        return self;
    };
}

// apply aProfiles
- (ATCentralManager *(^)(ATProfiles *))letSmartLampApplyProfiles{
    return ^(ATProfiles *aProfiles){
        _aProfiles = aProfiles;
//        self.letSmartLampTurnOn();
        return self;
    };
}

#pragma mark - core bluetooth delegate

#pragma mark central manager delegate

// did update state
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    isScannable = NO;
    // state
    switch (self.manager.state) {
        case CBCentralManagerStateUnknown:     // unknown
            break;
        case CBCentralManagerStateResetting:   // resetting
            break;
        case CBCentralManagerStateUnsupported: // unsupported
            ATLogFail(@"CBCentralManagerStateUnsupported");
            [self.didScannable sendNext:@NO];
            break;
        case CBCentralManagerStateUnauthorized:// unauthorized
            ATLogFail(@"CBCentralManagerStateUnauthorized");
            [self.didScannable sendNext:@NO];
            break;
        case CBCentralManagerStatePoweredOff:  // powered off
            ATLogFail(@"CBCentralManagerStatePoweredOff");
            [self.didScannable sendNext:@NO];
            break;
        case CBCentralManagerStatePoweredOn:   // powered on
            isScannable = YES;
            ATLogSuccess(@"CBCentralManagerStatePoweredOn");
            [self.didScannable sendNext:@YES];
            break;
    }
    
}

// did discover peripheral
- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)aPeripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    
    // contains "KQX"
    if ([aPeripheral.name containsString:@"KQX"]) {
        
        // save peripheral only if list doesn't contains it
        if (![self.peripheralList containsObject:aPeripheral]) {
            [self.peripheralList addObject:aPeripheral];
        }
        // send rac signal
        [self.didDeviceFound sendNext:@YES];
    }
    
}

// did connect success
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)aPeripheral
{
    
    ATLogSuccess(@"%@",aPeripheral.name);
    // set delegate
    aPeripheral.delegate = self;
    // mark status
    isConnected = YES;
    
    // send rac signal
    [self.didConnect sendNext:@YES];
    
    // discover services
    [aPeripheral discoverServices:nil];
    
    // stop scan
    self.stopScan();
    
}

// disconnect
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)aPeripheral error:(NSError *)error
{
    // mark status
    isConnected = NO;
    // send rac signal
    [self.didConnect sendNext:@NO];
    // disconnect only if manager is connected
    if(self.aPeripheral)
    {
        // remove delegate
        self.aPeripheral.delegate = nil;
        // remove connected peripheral
        _aPeripheral = nil;
    }
    
}

// connect fail
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)aPeripheral error:(NSError *)error
{
    ATLogError(error);
    // send rac signal
    [self.didConnect sendNext:@"fail"];
    // disconnect only if manager is connected
    if(self.aPeripheral)
    {
        // remove delegate
        self.aPeripheral.delegate = nil;
        // remove connected peripheral
        _aPeripheral = nil;
    }
    
}

#pragma mark peripheral delegate

// did discover services
- (void)peripheral:(CBPeripheral *)aPeripheral didDiscoverServices:(NSError *)error
{
    // for-in services
    for (CBService *aService in aPeripheral.services)
    {
        
        ATLog(@"discover aService, UUID:%@",aService.UUID);
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
    
    ATLog(@"service -> UUID:%@, characteristics:%@",service.UUID, service.characteristics);
    // UUID:1000
    if ([service.UUID isEqual: [CBUUID UUIDWithString:@"1000"]])
    {
        // for-in characteristic
        for (CBCharacteristic *aChar in service.characteristics)
        {
            // UUID:1001
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:@"1001"]]) {
                ATLog(@"discover characteristics:%@", aChar.UUID);
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

// did update notification state for characteristic
- (void)peripheral:(CBPeripheral *)peripheral
didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error
{
    // if error
    if (error) ATLogError(error);
    ATLog(@"update state for characteristic!");
    // read state if notifying
    if (characteristic.isNotifying)
    {
        ATLog(@"read value for characteristic:%@", characteristic);
        [peripheral readValueForCharacteristic:characteristic];
    }
    
}

// did update value for characteristic
- (void) peripheral:(CBPeripheral *)aPeripheral
didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
              error:(NSError *)error
{
    // if error
    if (error) ATLogError(error);
    // read new state
    ATLog(@"update value for characteristic!");
    ATLog(@"characteristic -> UUID:%@, value:%@",characteristic.UUID,characteristic.value);
    
}

// did write value for characteristic
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    ATLog(@"write value for characteristic:%@",characteristic);
    // if error
    if (error) ATLog(@"write fail:%@", characteristic);
    
}

#pragma mark - private methods

// scaning
- (void)scaning:(id)sender{
    
    // progress
    self.scanTimerProgress += 1.0;
    ATLog(@"scaning...");
    // scaned first peripheral
    BOOL tmpScaned = isScanedNewDevice || self.scanTimerProgress>self.scanTimeout;
    // scaned a peripheral and scan more
    BOOL tmpScanMore = (self.peripheralList.count > 0) && (self.scanTimerProgress > 6.0);
    // if scaned new device or timeout
    if (tmpScaned || tmpScanMore) {
        isScanedNewDevice = NO;
        // stop scan
        self.stopScan();
        // reset timer
        self.scanTimerProgress = 0;
        [self.scanTimer invalidate];
        self.scanTimer = nil;
        // if not found
        if (!isScanedNewDevice) {
            // send rac signal
            [self.didDeviceFound sendNext:@NO];
        }
    }
    
}

// turn on
- (void)turnOn{
    self.aProfiles.brightness += 0.05;
    if (self.aProfiles.brightness < self.lastBrightness) {
    } else{
        self.aProfiles.brightness = self.lastBrightness;
        [_brightTimer invalidate];
        _brightTimer = nil;
    }
    self.letSmartLampUpdateBrightness();
    _isTurnOn = YES;
}

// turn off
- (void)turnOff{
    self.aProfiles.brightness -= 0.05;
    if (self.aProfiles.brightness > 0) {
        self.letSmartLampUpdateBrightness();
    } else{
        self.aProfiles.brightness = 0;
        self.letSmartLampUpdateBrightness();
        self.aProfiles.brightness = self.lastBrightness;
        [_brightTimer invalidate];
        _brightTimer = nil;
    }
    _isTurnOn = NO;
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
        [self.aPeripheral writeValue:data forCharacteristic:self.characteristic1001 type:CBCharacteristicWriteWithResponse];
        ATLogOBJ(data);
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

#pragma mark - life circle

#pragma mark creator

// defaultManager
+ (instancetype)defaultManager{
    return [self sharedManager];
}

// sharedManager
+ (id)sharedManager{
    if (!atCentral) {
        @synchronized (self) {
            if (!atCentral) {
                atCentral = [[ATCentralManager alloc]init];
            }
        }
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//            if (!atCentral) {
//                atCentral = [[ATCentralManager alloc]init];
//            }
//        });
    }
    return atCentral;
}

// allocWithZone
+ (id) allocWithZone:(NSZone *)zone{
    if (!atCentral) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if (!atCentral) {
                atCentral = [super allocWithZone:zone];
            }
        });
    }
    return atCentral;
}

// init
- (instancetype)init{
    if (!atCentral){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if (!atCentral){
                atCentral = [[ATCentralManager alloc] init];
            }
        });
    }
    
    // init property
    _manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    _peripheralList = [NSMutableArray array];
    _scanTimeout = 12.0f;
    // enable send data every 0.04s
    _dataTimer = [NSTimer timerWithTimeInterval:0.04f target:self selector:@selector(enableToSendData) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_dataTimer forMode:NSRunLoopCommonModes];
    // get current profiles
    _aProfiles = [ATFileManager readCache]?[ATFileManager readCache]:[ATProfiles defaultProfiles];
    
    // init rac signal
    _didScannable = [RACSubject subject];
    _didScaning = [RACSubject subject];
    _didDeviceFound = [RACSubject subject];
    _didConnect = [RACSubject subject];
    _didTurnOn = [RACSubject subject];
    _didColorfulMode = [RACSubject subject];
    _didSendData = [RACSubject subject];
    
    
    
    return atCentral;
    
}

// copyWithZone
+ (id)copyWithZone:(struct _NSZone *)zone{
    return [self sharedManager];
}

// copyWithZone
- (id)copyWithZone:(struct _NSZone *)zone{
    return [ATCentralManager sharedManager];
}

// mutableCopyWithZone
+ (id)mutableCopyWithZone:(struct _NSZone *)zone{
    return [self sharedManager];
}

// mutableCopyWithZone
- (id)mutableCopyWithZone:(struct _NSZone *)zone{
    return [ATCentralManager sharedManager];
}

// copy
+ (id)copy{
    return [ATCentralManager sharedManager];
}



@end
