//
//  MainTabBarController.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-06-27.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTabBarController : UITabBarController

@property (assign, nonatomic) BOOL isLeftViewOpen;

@property (strong, nonatomic) UIPanGestureRecognizer *pan;

@property (strong, nonatomic) UIScreenEdgePanGestureRecognizer *edgePan;

- (void)panAction:(UIPanGestureRecognizer *)pan;

@end
