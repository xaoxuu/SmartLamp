//
//  ATToolBar.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-19.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ATToolBarDelegate;

@interface ATToolBar : UIView

// delegate
@property (weak, nonatomic) id<ATToolBarDelegate> delegate;


- (void (^)(NSUInteger))selectIndex;

#pragma mark - creator

#pragma mark only titles with frame
/**
 *	@author Aesir Titan, 2016-08-04 12:08:45
 *
 *	@brief create a toolbar
 *
 *	@param frame		frame
 *	@param titles		titles
 *	@param color		color
 *	@param btnAction	action
 *
 *	@return
 */
+ (instancetype)toolbarWithFrame:(CGRect)frame titles:(NSArray *)titles titleColor:(UIColor *)color action:(void (^)(NSUInteger index))action;
/**
 *	@author Aesir Titan, 2016-08-04 12:08:45
 *
 *	@brief create a toolbar
 *
 *	@param frame		frame
 *	@param titles		titles
 *	@param color		color
 *	@param btnAction	action
 *
 *	@return
 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles titleColor:(UIColor *)color action:(void (^)(NSUInteger index))action;

#pragma mark only titles with view
/**
 *	@author Aesir Titan, 2016-08-04 12:08:45
 *
 *	@brief create a toolbar and add to view
 *
 *	@param frame		view
 *	@param titles		titles
 *	@param color		color
 *	@param btnAction	action
 *
 *	@return
 */
//+ (instancetype)toolbarAddToView:(UIView *)view titles:(NSArray *)titles titleColor:(UIColor *)color action:(void (^)(NSUInteger index))btnAction;
+ (instancetype)toolbarWithTitleView:(UIView *)view titles:(NSArray *)titles titleColor:(UIColor *)color action:(void (^)(NSUInteger index))action;
/**
 *	@author Aesir Titan, 2016-08-04 12:08:45
 *
 *	@brief create a toolbar and add to view
 *
 *	@param frame		view
 *	@param titles		titles
 *	@param color		color
 *	@param btnAction	action
 *
 *	@return
 */
- (instancetype)initWithTitleView:(UIView *)view titles:(NSArray *)titles titleColor:(UIColor *)color action:(void (^)(NSUInteger index))action;

#pragma mark titles and contents
/**
 *	@author Aesir Titan, 2016-08-04 13:08:02
 *
 *	@brief create a toolbar and content view
 *
 *	@param view			title view
 *	@param titles		titles
 *	@param color		title color
 *	@param contentView	content view
 *	@param contents		contents
 *	@param action		action
 *
 *	@return
 */
+ (instancetype)toolbarWithTitleView:(UIView *)view titles:(NSArray *)titles titleColor:(UIColor *)color contentView:(UIView *)contentView contents:(NSArray<UIView *> *)contents action:(void (^)(NSUInteger index))action;
/**
 *	@author Aesir Titan, 2016-08-04 13:08:02
 *
 *	@brief create a toolbar and content view
 *
 *	@param view			title view
 *	@param titles		titles
 *	@param color		title color
 *	@param contentView	content view
 *	@param contents		contents
 *	@param action		action
 *
 *	@return
 */
- (instancetype)initWithTitleView:(UIView *)view titles:(NSArray *)titles titleColor:(UIColor *)color contentView:(UIView *)contentView contents:(NSArray<UIView *> *)contents action:(void (^)(NSUInteger index))action;


@end

@protocol ATToolBarDelegate <NSObject>

@optional
// toolbar title delegate
- (void)toolbarTitleDidSelectedIndex:(NSNumber *)index;
- (void)toolbarTitleWillScrollToIndex:(NSNumber *)index;
// toolbar content view delegate
- (void)toolbarContentViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)toolbarContentViewDidScroll:(UIScrollView *)scrollView;
- (void)toolbarContentViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)toolbarContentViewDidScrollToTop:(UIScrollView *)scrollView;



@end

