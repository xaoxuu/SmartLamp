//
//  ATLeftViewController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-11.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ATLeftViewController.h"
#import "ATLeftTableViewController.h"

@interface ATLeftViewController ()

@property (strong, nonatomic) ATLeftTableViewController *tableViewVC;

@end

@implementation ATLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.tableViewVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ATLeftTableViewController"];
//    self.tableViewVC.view.frame = self.view.bounds;
//    [self addChildViewController:self.tableViewVC];
//    [self.view addSubview:self.tableViewVC.view];
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
