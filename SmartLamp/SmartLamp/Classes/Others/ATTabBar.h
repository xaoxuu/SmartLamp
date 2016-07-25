//
//  ATTabBar.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-13.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATTabBar : UITabBar

// 中间按钮事件
@property (copy, nonatomic) void(^action)();

@end
