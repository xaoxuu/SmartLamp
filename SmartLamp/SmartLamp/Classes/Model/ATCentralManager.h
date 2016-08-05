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


@interface ATCentralManager : NSObject <NSCopying,CBCentralManagerDelegate,CBPeripheralDelegate>

#pragma mark - model
// current connected peripheral
@property (strong, nonatomic) CBPeripheral *connectedPeripheral;
// scaned deviceList
@property (strong, nonatomic) NSMutableArray<CBPeripheral *> *scanedDeviceList;
// current aProfiles
@property (strong, nonatomic) ATProfiles *currentProfiles;

#pragma mark - RACSubject
// rac signal for scaning
@property (strong, nonatomic) RACSubject *didScaning;
// rac signal for stop scaning
@property (strong, nonatomic) RACSubject *didStopScan;
// rac signal for device found
@property (strong, nonatomic) RACSubject *didDeviceFound;
// rac signal for device not found
@property (strong, nonatomic) RACSubject *didNotFound;
// rac signal for connect success
@property (strong, nonatomic) RACSubject *didConnectSuccess;
// rac signal for connect fail
@property (strong, nonatomic) RACSubject *didConnectFail;
// rac signal for disconnect
@property (strong, nonatomic) RACSubject *didDisconnect;
// rac signal for turn on
@property (strong, nonatomic) RACSubject *didTurnOn;
// rac signal for turn off
@property (strong, nonatomic) RACSubject *didTurnOff;
// rac signal for color animation
@property (strong, nonatomic) RACSubject *didPerformColorAnimation;
// rac signal for send data
@property (strong, nonatomic) RACSubject *didSendData;

#pragma mark - public methods

#pragma mark scan
/**
 *	@author Aesir Titan, 2016-07-24 17:07:51
 *
 *	@brief start scan with auto timeout (default is 5 seconds)
 */
- (void)startScanWithAutoTimeout;

/**
 *	@author Aesir Titan, 2016-05-16 16:05:45
 *
 *	@brief stop scan right now
 */
- (void)stopScan;

#pragma mark connect
/**
 *	@author Aesir Titan, 2016-05-09 18:05:59
 *
 *	@brief connect a peripheral
 *
 *	@param smartLamp	peripheral
 */
- (void)connectSmartLamp:(CBPeripheral *)smartLamp;

/**
 *	@author Aesir Titan, 2016-05-09 18:05:17
 *
 *	@brief disconnect current peripheral
 */
- (void)disConnectSmartLamp;

/**
 *	@author Aesir Titan, 2016-07-24 17:07:19
 *
 *	@brief connect or disconnect peripheral
 */
- (void)connectOrDisconnect;

#pragma mark turn on or turn off
/**
 *	@author Aesir Titan, 2016-04-29 15:04:12
 *
 *	@brief turn on or turn off
 *
 *	@param work	YES:turn on, NO:turn off
 */
- (void)letSmartLampTurnOnIf:(BOOL)isYes;

/**
 *	@author Aesir Titan, 2016-04-29 15:04:21
 *
 *	@brief perform sleep mode
 */
- (void)letSmartLampPerformSleepMode;

#pragma mark control
/**
 *	@author Aesir Titan, 2016-07-20 17:07:16
 *
 *	@brief color animation mode
 */
- (void)letSmartLampPerformColorAnimation;
/**
 *	@author Aesir Titan, 2016-07-20 17:07:07
 *
 *	@brief color
 */
- (void)letSmartLampUpdateColor;

/**
 *	@author Aesir Titan, 2016-07-20 17:07:23
 *
 *	@brief update brightness
 */
- (void)letSmartLampUpdateBrightness;
/**
 *	@author Aesir Titan, 2016-07-20 17:07:31
 *
 *	@brief update all status
 */
- (void)letSmartLampUpdateAllStatus;
/**
 *	@author Aesir Titan, 2016-07-24 19:07:06
 *
 *	@brief apply aProfiles
 *
 *	@param aProfiles	aProfiles
 */
- (void)letSmartLampApplyProfiles:(ATProfiles *)aProfiles;

#pragma mark creator

/**
 *	@author Aesir Titan, 2016-04-29 16:07:35
 *
 *	@brief creator
 */
+ (instancetype)defaultCentralManager;

/**
 *	@author Aesir Titan, 2016-04-29 16:07:52
 *
 *	@brief creator
 */
+ (instancetype)sharedCentralManager;


@end





