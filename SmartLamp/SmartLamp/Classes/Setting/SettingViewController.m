//
//  SettingViewController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-02.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingHeaderView.h"
#import "SettingTableViewCell.h"


#define NIB_SETTING @"SettingTableViewCell"
@interface SettingViewController ()

// 设置列表
@property (strong, nonatomic) NSMutableArray *settingList;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}


// 初始化UI
- (void)_initUI{
    self.automaticallyAdjustsScrollViewInsets = YES;
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imgv.image = [UIImage imageNamed:@"0"];
    [self.view addSubview:imgv];
    self.navigationItem.title = @"设置";
    [self.navigationController.navigationBar.subviews[0] removeFromSuperview];
}





@end
