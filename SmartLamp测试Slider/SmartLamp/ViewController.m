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

#pragma mark - 🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀 视图事件

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
        
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀 控件事件


- (IBAction)touchDown:(UIButton *)sender {
    
    [sender buttonState:ATButtonStateDown];
    
}




- (IBAction)touchUp:(UIButton *)sender {
    
    [sender buttonState:ATButtonStateUp];
    
}

#pragma mark - 🚫🚫🚫🚫🚫🚫🚫🚫🚫🚫 私有方法 

-(SCLAlertView *)newAlert{
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.showAnimationType = FadeIn;
    alert.hideAnimationType = FadeOut;
    alert.backgroundType = Blur;

    return alert;
    
}

//-(SCLAlertView *)alertForScaning{
//    
//    if (!_alertForScaning) {
//        _alertForScaning = [[SCLAlertView alloc] init];
//        _alertForScaning.showAnimationType = FadeIn;
//        _alertForScaning.hideAnimationType = FadeOut;
//        _alertForScaning.backgroundType = Blur;
//    }
//    
//    return _alertForScaning;
//    
//}

//- (void)showAlertWithScaningWithDuration:(NSTimeInterval)duration andStopAction:(void (^)())action{
//    
//    SCLAlertView *alert = [[SCLAlertView alloc] init];
//    alert.showAnimationType = FadeIn;
//    alert.hideAnimationType = FadeOut;
//    alert.backgroundType = Blur;
//    
//    [alert addButton:@"停止扫描" actionBlock:^{
//        action();
//        NSLog(@"点击了停止扫描");
//    }];
//    
//    self.autoConnect = [alert addSwitchViewWithLabel:@"自动连接"];
//    
//    [alert showWaiting:self title:@"正在扫描" subTitle:@"正在扫描周围可用的蓝牙灯，请稍等。。。" closeButtonTitle:nil duration:duration];
//    
//}


//- (void)showAlertWithConnecting{
//    
//    SCLAlertView *alert = [[SCLAlertView alloc] init];
//    alert.showAnimationType = FadeIn;
//    alert.hideAnimationType = FadeOut;
//    alert.backgroundType = Blur;
//    [alert showWaiting:self title:@"正在连接" subTitle:@"正在连接蓝牙灯，请稍等。。。" closeButtonTitle:nil duration:2.0f];
//    
//}



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


- (UIColor *)tintColor{
    
    return [UIColor colorWithRed:0.419 green:0.8 blue:1 alpha:1];
    
    
}

@end
