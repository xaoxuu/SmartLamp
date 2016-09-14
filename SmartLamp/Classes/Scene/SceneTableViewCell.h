//
//  SceneTableViewCell.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-13.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATTableViewCell.h"

@interface SceneTableViewCell : ATTableViewCell

// scene model
@property (strong, nonatomic) ATProfiles *model;

@end
