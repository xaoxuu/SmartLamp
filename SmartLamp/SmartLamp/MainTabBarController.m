//
//  MainTabBarController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-06-27.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()





@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(screenEdgePan:)];
    self.edgePan.edges = UIRectEdgeLeft;
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self.view addGestureRecognizer:self.pan];
    [self.view addGestureRecognizer:self.edgePan];
    
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(-1.5, 0);
    self.view.layer.shadowOpacity = 0.5f;
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:NOTI_LEFTVIEW object:nil];
    
    
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


- (void)screenEdgePan:(UIScreenEdgePanGestureRecognizer *)edgePan{
    
    if (edgePan.edges == UIRectEdgeLeft) {
        [self openLeftView];
    }

    
}

- (void)panAction:(UIPanGestureRecognizer *)pan{
    
    if (pan && pan.state == UIGestureRecognizerStateBegan) {
        CGPoint translation = [pan translationInView:self.view];
        if (translation.x < 0 ) {
            [self closeLeftView];
        }
        
    }
    
}


- (void)openLeftView{
    
    [UIView animateWithDuration:0.38 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.center = CGPointMake(SCREEN_W * 1.2, SCREEN_H * 0.5);
        self.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        self.isLeftViewOpen = YES;
    }];
    
}

- (void)closeLeftView{
    
    [UIView animateWithDuration:0.38 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.center = CGPointMake(SCREEN_W * 0.5, SCREEN_H * 0.5);
        self.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.isLeftViewOpen = NO;
        NSLog(@"isopen: %d",self.isLeftViewOpen);
    }];
    
}

- (void)receiveNotification:(NSNotification *)notification{
    // 🖥
    NSLog(@"isopen: %d",!self.isLeftViewOpen);
    NSLog(@"isopen: %d",[notification.object isEqualToString:LEFTVIEW_OPEN]);
    if (!self.isLeftViewOpen && [notification.object isEqualToString:LEFTVIEW_OPEN]) {
        [self openLeftView];
    } else {
        [self closeLeftView];
    }
    
}





@end
