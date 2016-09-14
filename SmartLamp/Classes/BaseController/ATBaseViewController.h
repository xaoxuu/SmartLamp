//
//  ATBaseViewController.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-11.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATNavigationView.h"

@interface ATBaseViewController : UIViewController

// rac be selected
@property (strong, nonatomic) RACSubject *didSelected;
// navigation view
@property (strong, nonatomic) ATNavigationView *atNavigationView;


@end
