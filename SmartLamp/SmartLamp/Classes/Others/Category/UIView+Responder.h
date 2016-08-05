//
//  UIView+Responder.h
//  GoingFarm
//
//  Created by Aesir Titan on 2016-07-26.
//  Copyright © 2016年 computer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Responder)

/**
 *	@author Aesir Titan, 2016-08-04 16:08:41
 *
 *	@brief find super controller
 *
 *	@return  super controller
 */
- (UIViewController *)at_superController;

@end
