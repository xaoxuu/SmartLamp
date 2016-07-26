//
//  ATBaseNavigationController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-11.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ATBaseNavigationController.h"

@interface ATBaseNavigationController ()

@end

@implementation ATBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 初始化UI
- (void)_initUI{
    // 颜色
    self.navigationBar.barTintColor = atColor.themeColor;
    self.navigationBar.tintColor = atColor.backgroundColor;
    self.view.tintColor = atColor.backgroundColor;
    self.navigationItem.titleView.tintColor = atColor.backgroundColor;
    // 标题颜色
    NSDictionary * dict = [NSDictionary dictionaryWithObject:atColor.backgroundColor forKey:NSForegroundColorAttributeName];
    self.navigationBar.titleTextAttributes = dict;
//     隐藏分割线
    [self.navigationBar.subviews[0].subviews[0] removeFromSuperview];
    // 不透明
    self.navigationBar.translucent = NO;
    
}



@end
