//
//  ATRootViewController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-06-27.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "ATRootViewController.h"

@interface ATRootViewController ()

@property (strong, nonatomic) LeftTableViewController *left;

@property (strong, nonatomic) BaseViewController *base;



@end

@implementation ATRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.left = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftTableViewController"];
    self.base = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
    
    [self addChildViewController:self.left];
    [self.view addSubview:self.left.view];
    
    [self addChildViewController:self.base];
    [self.view addSubview:self.base.view];
    
    
    
    
}


//设置 状态栏的文字颜色为 高亮  白色
- (UIStatusBarStyle )preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
