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

@class ATCentralManager;
extern ATCentralManager *atCentral;

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "ATProfiles.h"

@interface ATCentralManager : NSObject <NSCopying,CBCentralManagerDelegate,CBPeripheralDelegate>

#pragma mark - model
// current connected peripheral
@property (strong, readonly, nonatomic) CBPeripheral *aPeripheral;
// scaned deviceList
@property (strong, readonly, nonatomic) NSMutableArray<CBPeripheral *> *peripheralList;
// current aProfiles
@property (strong, readonly, nonatomic) ATProfiles *aProfiles;
// scan timeout
@property (assign, readonly, nonatomic) NSTimeInterval scanTimeout;
// is turn on or not
@property (assign, readonly, nonatomic) BOOL isTurnOn;

#pragma mark - RACSubject

// rac signal for scannable or not
@property (strong, nonatomic) RACSubject *didScannable;
// rac signal for scaning or not
@property (strong, nonatomic) RACSubject *didScaning;
// rac signal for device found or not
@property (strong, nonatomic) RACSubject *didDeviceFound;
// rac signal for connect success or not
@property (strong, nonatomic) RACSubject *didConnect;
// rac signal for turn on or not
@property (strong, nonatomic) RACSubject *didTurnOn;
// rac signal for color animation
@property (strong, nonatomic) RACSubject *didColorfulMode;
// rac signal for send data
@property (strong, nonatomic) RACSubject *didSendData;

#pragma mark - public methods

#pragma mark scan
/**
 *	@author Aesir Titan, 2016-07-24 17:07:51
 *
 *	@brief start scan with auto timeout (default is 12 seconds)
 */
- (ATCentralManager *(^)())startScanWithAutoTimeout;

/**
 *	@author Aesir Titan, 2016-05-16 16:05:45
 *
 *	@brief stop scan right now
 */
- (ATCentralManager *(^)())stopScan;

#pragma mark connect
/**
 *	@author Aesir Titan, 2016-05-09 18:05:59
 *
 *	@brief connect a peripheral
 *
 *	@param smartLamp	peripheral
 */
- (ATCentralManager *(^)(CBPeripheral *))connectSmartLamp;

/**
 *	@author Aesir Titan, 2016-05-09 18:05:17
 *
 *	@brief disconnect current peripheral
 */
- (ATCentralManager *(^)())disConnectSmartLamp;

/**
 *	@author Aesir Titan, 2016-07-24 17:07:19
 *
 *	@brief connect or disconnect peripheral
 */
- (ATCentralManager *(^)())connectOrDisconnect;

#pragma mark turn on or turn off
/**
 *	@author Aesir Titan, 2016-08-07 14:08:28
 *
 *	@brief turn on
 */
- (ATCentralManager *(^)(BOOL))letSmartLampTurnOnOrOff;
/**
 *	@author Aesir Titan, 2016-08-07 14:08:38
 *
 *	@brief turn on
 */
- (ATCentralManager *(^)())letSmartLampTurnOn;
/**
 *	@author Aesir Titan, 2016-08-07 14:08:43
 *
 *	@brief turn off
 */
- (ATCentralManager *(^)())letSmartLampTurnOff;
/**
 *	@author Aesir Titan, 2016-04-29 15:04:21
 *
 *	@brief perform sleep mode
 */
- (ATCentralManager *(^)())letSmartLampPerformSleepMode;

#pragma mark control
/**
 *	@author Aesir Titan, 2016-07-20 17:07:16
 *
 *	@brief color animation mode
 */
- (ATCentralManager *(^)())letSmartLampPerformColorMode;
/**
 *	@author Aesir Titan, 2016-07-20 17:07:07
 *
 *	@brief color
 */
- (ATCentralManager *(^)())letSmartLampUpdateColor;

/**
 *	@author Aesir Titan, 2016-07-20 17:07:23
 *
 *	@brief update brightness
 */
- (ATCentralManager *(^)())letSmartLampUpdateBrightness;
/**
 *	@author Aesir Titan, 2016-07-20 17:07:31
 *
 *	@brief update all status
 */
- (ATCentralManager *(^)())letSmartLampUpdateAllStatus;
/**
 *	@author Aesir Titan, 2016-07-24 19:07:06
 *
 *	@brief apply aProfiles
 *
 *	@param aProfiles	aProfiles
 */
- (ATCentralManager *(^)(ATProfiles *))letSmartLampApplyProfiles;

#pragma mark creator

/**
 *	@author Aesir Titan, 2016-04-29 16:07:35
 *
 *	@brief creator
 */
+ (instancetype)defaultManager;

/**
 *	@author Aesir Titan, 2016-04-29 16:07:52
 *
 *	@brief creator
 */
+ (instancetype)sharedManager;


@end




