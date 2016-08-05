//
//  ATBaseNavigationController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-11.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ATBaseNavigationController.h"
#import "ATNavigationBar.h"

@interface ATBaseNavigationController ()

@end

@implementation ATBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // init UI
    [self _initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// init UI
- (void)_initUI{
    // navigation bar
    ATNavigationBar *atNavBar = [ATNavigationBar barWithBarTintColor:atColor.themeColor];
    [self setValue:atNavBar forKey:@"navigationBar"];
    // color
    self.view.tintColor = atColor.backgroundColor;
    self.navigationItem.titleView.tintColor = atColor.backgroundColor;
    
}



@end
