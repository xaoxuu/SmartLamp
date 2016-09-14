//
//  ATTableViewCell.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-21.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface ATTableViewCell : UITableViewCell

// ripple color
@property (strong, nonatomic) IBInspectable UIColor *rippleColor;

// right image view
@property (strong, nonatomic) UIImageView *accessoryImageV;

// right image
//@property (strong, nonatomic) UIImage *rightImage;


@end
