//
//  ATBaseViewController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-11.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ATBaseViewController.h"
#import "UIViewController+BaseVC.h"


@interface ATBaseViewController ()

@end

@implementation ATBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // init UI
    self.view.backgroundColor = atColor.background;
    // subviews extend layout include opaque bars
//    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    
    [self at_disableGeatureInChlidController];
    
    [self at_hideNavigationBarInRootController];
    
}



- (RACSubject *)didSelected{
    if (!_didSelected) {
        // create it
        _didSelected = [RACSubject subject];
        // do something...
        
    }
    return _didSelected;
}

@end
