//
//  UITextField+ATExtension.h
//  ATFoundation
//
//  Created by Aesir Titan on 2016-08-31.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (ATExtension)



/*!
 *	@author Aesir Titan, 2016-08-31
 *
 *	@brief clear all text
 */
- (void)at_clearText;

/*!
 *	@author Aesir Titan, 2016-09-06
 *
 *	@brief adjust view's frame when keyboard popup
 *
 *	@param view	adjust this view's frame
 */
- (void)at_adjustViewFrameWithKeyboard:(UIView *)view;

@end

