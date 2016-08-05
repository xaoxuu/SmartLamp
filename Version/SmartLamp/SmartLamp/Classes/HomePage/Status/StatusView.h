//
//  StatusView.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-19.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATProfiles.h"

@interface StatusView : UIView
// 情景模式图片
@property (weak, nonatomic) IBOutlet UIButton *detail_SceneImage;
// 情景模式
@property (strong, nonatomic) ATProfiles *aProfiles;
// 更新UI
- (void)updateUI;

@end
