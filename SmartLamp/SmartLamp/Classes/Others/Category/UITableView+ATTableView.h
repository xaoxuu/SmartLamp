//
//  UITableView+ATTableView.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-05.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


#define normal   CGRectMake(0, 64, SCREEN_W, SCREEN_H-64-49)
#define viewWithHeight(height) [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, height)]
#define none [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)]

@interface UITableView (ATTableView)

#pragma mark - creator

/**
 *	@author Aesir Titan, 2016-08-05 03:08:22
 *
 *	@brief create a table and setup datasource delegate and add to superview
 *
 *	@param target	controller
 *	@param frame	table view frame
 *	@param reuseId	cell reuse id
 *
 *	@return 
 */
+ (instancetype)at_tableViewWithTarget:(UIViewController<UITableViewDataSource, UITableViewDelegate> *)target
                                 frame:(CGRect)frame
     registerNibForCellReuseIdentifier:(NSString *)reuseId;

+ (instancetype)at_tableViewWithTarget:(UIViewController<UITableViewDataSource, UITableViewDelegate> *)target
                                 frame:(CGRect)frame
     registerNibForCellReuseIdentifier:(NSString *)reuseId detail:(void (^)(UITableView *tableView))detail;


#pragma mark - detail

#pragma mark table
/**
 *	@author Aesir Titan, 2016-08-05 03:08:01
 *
 *	@brief table header view
 */
- (UITableView *(^)(UIView *))at_tableHeaderView;

/**
 *	@author Aesir Titan, 2016-08-05 03:08:16
 *
 *	@brief table footer view
 */
- (UITableView *(^)(UIView *))at_tableFooterView;
#pragma mark section
/**
 *	@author Aesir Titan, 2016-08-05 03:08:26
 *
 *	@brief section header view
 */
- (UITableView *(^)(CGFloat))at_sectionHeaderHeight;
/**
 *	@author Aesir Titan, 2016-08-05 03:08:35
 *
 *	@brief section footer height
 */
- (UITableView *(^)(CGFloat))at_sectionFooterHeight;
#pragma mark table
/**
 *	@author Aesir Titan, 2016-08-05 03:08:46
 *
 *	@brief row height
 */
- (UITableView *(^)(CGFloat))at_rowHeight;

#pragma mark style
/**
 *	@author Aesir Titan, 2016-08-05 03:08:53
 *
 *	@brief background color
 */
- (UITableView *(^)(UIColor *))at_backgroundColor;

@end
