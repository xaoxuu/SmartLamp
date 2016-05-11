//
//  ViewController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-04-21.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "ViewController.h"
#import "ATCentralManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (ATCentralManager *)iPhone{
    
    if (!_iPhone) {
        
        _iPhone = [ATCentralManager defaultCentralManager];
        
    }
    return _iPhone;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






- (IBAction)touchDown:(UIButton *)sender {
    
    [sender buttonState:ATButtonStateDown];
    
}




- (IBAction)touchUp:(UIButton *)sender {
    
    [sender buttonState:ATButtonStateUp];
    
}




- (void)pushAlertViewWithTitle:(NSString *)title
                    andMessage:(NSString *)message
                         andOk:(NSString *)ok
                     andCancel:(NSString *)cancel
                 andOkCallback:(void (^)())okCallback
             andCancelCallback:(void (^)())cancelCallback {

    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    
    // ==================== [ 生成UIAlertAction ] ==================== //
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:ok
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                       
                                                         okCallback();
                                                         
                                                       
                                                     }];
    [alert addAction:okAction];
    
    
    if (![cancel isEqualToString:@""]) {
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancel
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 
                                                                 cancelCallback();
                                                                 
                                                             }];
        
        
        
        
        [alert addAction:cancelAction];
        

        
    }
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}




// 用户配置列表
-(NSMutableArray<ATProfiles *> *)profilesList{
    
    if (!_profilesList) {
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        _profilesList = [user objectForKey:@"profilesList"];
        if (!_profilesList) {
            _profilesList = [NSMutableArray arrayWithObject:self.aProfiles];
        }
        
    }
    
    return _profilesList;
    
}

// 当前配置
-(ATProfiles *)aProfiles{
    
    if (!_aProfiles) {
        
        // 如果有缓存, 就直接加载缓存;如果没有, 就新建一个实例
        _aProfiles = [ATFileManager readCache]?[ATFileManager readCache]:[ATProfiles defaultProfiles];
        
    }
    
    return _aProfiles;
    
}

// 扫描到的设备列表
-(NSArray<CBPeripheral *> *)smartLampList{
    
    if (!_smartLampList.count) {
        _smartLampList = [self.iPhone searchSmartLamp];
    }
    return _smartLampList;
    
}


@end
