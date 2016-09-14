//
//  LeftViewController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-21.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupBackground];
    
//    [self setupLaunch];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// setup background
- (void)setupBackground{
    self.view.backgroundColor = atColor.theme;
    // init and add to superview
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageV.image = [UIImage imageNamed:@"image_leftView"];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageV];
    
}

// setup launch
- (void)setupLaunch{
    // init and add to superview
    UIView *launch = [[NSBundle mainBundle] loadNibNamed:@"Launch" owner:nil options:nil][0];
    launch.bottom = self.view.bottom;
    launch.centerX = self.view.centerX;
    [self.view addSubview:launch];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIView animateWithDuration:2.0f delay:3.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            launch.alpha = 0;
        } completion:^(BOOL finished) {
            [launch removeFromSuperview];
        }];
    });
    
    
}

@end
