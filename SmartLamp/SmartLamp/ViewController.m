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

- (ATCentralManager *)iPhone{
    
    if (!_iPhone) {
        
        _iPhone = [ATCentralManager defaultCentralManager];
        
        
    }
    return _iPhone;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
