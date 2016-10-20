//
//  ATBaseTabBarController.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-13.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
// child
#import "ATTabBar.h"

@interface ATBaseTabBarController : UITabBarController

@property (strong, nonatomic) ATTabBar *atTabBar;

@end
