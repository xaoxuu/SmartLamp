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

#pragma mark - 视图事件 🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 控件事件 🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀


- (IBAction)touchDown:(UIButton *)sender {
    
    [sender buttonState:ATButtonStateDown];
    
}




- (IBAction)touchUp:(UIButton *)sender {
    
    [sender buttonState:ATButtonStateUp];
    
}

#pragma mark - 私有方法 🚫🚫🚫🚫🚫🚫🚫🚫🚫🚫

// 弹出AlertView
- (void)pushAlertViewWithTitle:(NSString *)title
                    andMessage:(NSString *)message
                         andOk:(NSString *)ok
                     andCancel:(NSString *)cancel
                 andOkCallback:(void (^)())okCallback
             andCancelCallback:(void (^)())cancelCallback {

    // 生成alert
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    
    // 生成okAction
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:ok
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         // Ok按钮的回调
                                                         okCallback();
                                                     }];
    // 把ok按钮添加进去
    [alert addAction:okAction];
    
    // 只有需要cancel按钮的时候才创建cancel按钮
    if (![cancel isEqualToString:@""]) {
        // 生成cancelAction
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancel
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 // cancel按钮的回调
                                                                 cancelCallback();
                                                             }];
        // 把cancelAction添加进去
        [alert addAction:cancelAction];
    }
    
    // push
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark 🚫 懒加载

// 中心设备, 单例
- (ATCentralManager *)iPhone{
    
    if (!_iPhone) {
        
        _iPhone = [ATCentralManager defaultCentralManager];
        
    }
    
    return _iPhone;
    
}

// 当前的情景模式
-(ATProfiles *)aProfiles{
    
    if (!_aProfiles) {
        
        // 如果有缓存, 就直接加载缓存;如果没有, 就新建一个实例
        _aProfiles = [ATFileManager readCache]?[ATFileManager readCache]:[ATProfiles defaultProfiles];
        
    }
    
    return _aProfiles;
    
}

// 情景模式的配置列表
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


@end
