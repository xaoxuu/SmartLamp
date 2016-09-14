//
//  UIViewController+BaseVC.m
//  DearyPet
//
//  Created by Aesir Titan on 2016-08-19.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "UIViewController+BaseVC.h"


@implementation UIViewController (BaseVC)

// InTabBarControllerRootViewController
- (void)at_hideNavigationBarInRootController{
    if (self.navigationController.viewControllers.count == 1) {
        // root view controller
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    } else{
        // not root view controller
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}



@end
