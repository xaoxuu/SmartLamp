//
//  DiscoverTableView.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-24.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DiscoverTableView : UIView

// tableview
@property (strong, nonatomic) UITableView *tableView;


+ (instancetype)tableViewWithFrame:(CGRect)frame index:(NSUInteger)index scrollViewDidScroll:(void(^)(UIScrollView *scrollView))scrollView;

- (void)reloadData;


//- (void)loadDataWithPage:(NSUInteger)page count:(NSUInteger)count;


@end
