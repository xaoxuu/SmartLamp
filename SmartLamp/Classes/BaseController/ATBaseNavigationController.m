//
//  ATBaseNavigationController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-11.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ATBaseNavigationController.h"
#import "ATManager+Navigation.h"
#import "UINavigationController+BaseVC.h"
@interface ATBaseNavigationController ()

@end

@implementation ATBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // setup bar style
    [self at_setupBarStyle:ATBarStyleTintOpaque tintColor:atColor.theme];
    
    // setup bar
    [self at_setupNavigationBar:[ATNavigationBar barWithBarTintColor:atColor.theme]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
