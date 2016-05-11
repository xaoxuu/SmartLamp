//
//  ViewController.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-04-21.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "ATCentralManager.h"
#import "ATProfiles.h"
#import "ATFileManager.h"
#import "UIButton+ATButton.h"

@interface ViewController : UIViewController


@property (strong, nonatomic) ATCentralManager *iPhone;

@property (strong, nonatomic) NSMutableArray<ATProfiles *> *profilesList;

@property (strong, nonatomic) ATProfiles *aProfiles;

@property (strong, nonatomic) NSArray<CBPeripheral *> *smartLampList;


- (IBAction)touchUp:(UIButton *)sender;

- (IBAction)touchDown:(UIButton *)sender;


- (void)pushAlertViewWithTitle:(NSString *)title
                    andMessage:(NSString *)message
                         andOk:(NSString *)ok
                     andCancel:(NSString *)cancel
                 andOkCallback:(void (^)())okCallback
             andCancelCallback:(void (^)())cancelCallback;



@end

