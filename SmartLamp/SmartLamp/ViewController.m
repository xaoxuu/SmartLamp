//
//  ViewController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-04-21.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "ViewController.h"

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

// 按钮轻触时
- (IBAction)touchDown:(UIButton *)sender {
    
    [sender buttonState:ATButtonStateTap];
    
}

// 按钮正常状态
- (IBAction)touchUp:(UIButton *)sender {
    
    if (sender.isSelected == YES) {
        [sender buttonState:ATButtonStateSelected];
    } else{
        [sender buttonState:ATButtonStateNormal];
    }
    
}

#pragma mark - 🚫🚫🚫🚫🚫🚫🚫🚫🚫🚫 私有方法 

// 新建一个AlertView
-(SCLAlertView *)newAlert{
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.showAnimationType = FadeIn;
    alert.hideAnimationType = FadeOut;
    alert.backgroundType = Blur;

    return alert;
    
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
        
        if (!_profilesList) {
            _profilesList = [NSMutableArray arrayWithObject:self.aProfiles];
        }
        
    }
    
    return _profilesList;
    
}


- (UIColor *)tintColor{
    
    return [UIColor colorWithRed:0.42f green:0.80f blue:1.00f alpha:1.00f];
    
}




@end
