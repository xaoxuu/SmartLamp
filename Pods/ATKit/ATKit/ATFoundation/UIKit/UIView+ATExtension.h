//
//  UIView+ATExtension.h
//  ATFoundation
//
//  Created by Aesir Titan on 2016-08-31.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 *	@author Aesir Titan, 2016-09-01
 *
 *	@brief UIViewWithHeight
 *
 *	@param height	view height
 *
 *	@return a view
 */
CG_EXTERN UIView *UIViewWithHeight(CGFloat height);


@interface UIView (ATExtension)

/*!
 *	@author Aesir Titan, 2016-08-24
 *
 *	@brief find out view's super controller
 *
 *	@return controller
 */
- (nullable UIViewController *)controller;

/*!
 *	@author Aesir Titan, 2016-08-31
 *
 *	@brief remove all subviews
 */
- (void)at_removeAllSubviews:(nullable Class)subClass;

- (void)at_eachSubview:(nullable Class)subClass action:(void (^)(__kindof UIView *subview))action;

/*!
 *	@author Aesir Titan, 2016-09-05
 *
 *	@brief create a rounded view
 *
 *	@param rect	view frame
 *
 *	@return a rounded view
 */
+ (instancetype)at_roundedViewWithFrame:(CGRect)rect;


@end

NS_ASSUME_NONNULL_END