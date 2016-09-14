//
//  UITextView+ATExtension.h
//  ATFoundation
//
//  Created by Aesir Titan on 2016-09-07.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Foundation+CoreGraphics.h"

@interface UITextView (ATExtension)


/*!
 *	@author Aesir Titan, 2016-09-06
 *
 *	@brief adjust view's frame when keyboard popup
 *
 *	@param view	adjust this view's frame
 */
- (void)at_adjustViewFrameWithKeyboard:(UIView *)view;


- (CGFloat)at_heightWithText:(NSString *)text heightRange:(ATFloatRange)range;


@end
