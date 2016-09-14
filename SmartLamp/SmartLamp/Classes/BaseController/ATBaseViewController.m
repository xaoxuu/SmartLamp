//
//  ATBaseViewController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-11.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ATBaseViewController.h"

@interface ATBaseViewController ()

@end

@implementation ATBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // remove separactor
    [self.navigationController.navigationBar.subviews[0].subviews[0] removeFromSuperview];
    // subviews extend layout include opaque bars
    self.extendedLayoutIncludesOpaqueBars = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
