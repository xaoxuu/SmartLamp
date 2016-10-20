//
//  UITableView+Creator.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-10.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "UITableView+Creator.h"

@implementation UITableView (Creator)

#pragma mark - creator



+ (instancetype)at_tableViewWithTarget:(UIViewController<UITableViewDataSource, UITableViewDelegate> *)target
                                 frame:(CGRect)frame
                                 style:(UITableViewStyle)style
     registerNibForCellReuseIdentifier:(NSString *)reuseId {
    
    // init and add to superview
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:style];
    tableView.dataSource = target;
    tableView.delegate = target;
    [target.view addSubview:tableView];
    if (reuseId.length) {
        [tableView registerNib:[UINib nibWithNibName:reuseId bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuseId];
    }
    
    // style
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // table header and footer
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    
    // reutrn
    return tableView;
}


+ (instancetype)at_tableViewWithView:(UIView<UITableViewDataSource, UITableViewDelegate> *)target
                                 frame:(CGRect)frame
                                 style:(UITableViewStyle)style
     registerNibForCellReuseIdentifier:(NSString *)reuseId {
    
    // init and add to superview
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:style];
    tableView.dataSource = target;
    tableView.delegate = target;
    [target addSubview:tableView];
    if (reuseId.length) {
        [tableView registerNib:[UINib nibWithNibName:reuseId bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuseId];
    }
    
    // style
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // table header and footer
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    
    // reutrn
    return tableView;
}


#pragma mark - action

- (void)scrollToTopWhenViewTapped:(UIView *)view{
    [view at_addTapGestureHandler:^(UITapGestureRecognizer * _Nonnull sender) {
        [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }];
}

- (void)refreshWhenViewTapped:(UIView *)view{
    [view at_addTapGestureHandler:^(UITapGestureRecognizer * _Nonnull sender) {
        [self reloadData];
    }];
}

#pragma mark - detail

#pragma mark table

- (UITableView *(^)(UIView *))at_tableHeaderView{
    return ^(UIView *view){
        self.tableHeaderView = view;
        return self;
    };
}

- (UITableView *(^)(UIView *))at_tableFooterView{
    return ^(UIView *view){
        self.tableFooterView = view;
        return self;
    };
}

#pragma mark section

- (UITableView *(^)(CGFloat))at_sectionHeaderHeight{
    return ^(CGFloat height){
        self.sectionHeaderHeight = height;
        return self;
    };
}

- (UITableView *(^)(CGFloat))at_sectionFooterHeight{
    return ^(CGFloat height){
        self.sectionFooterHeight = height;
        return self;
    };
}


#pragma mark row

- (UITableView *(^)(CGFloat))at_rowHeight{
    return ^(CGFloat height){
        self.estimatedRowHeight = height;
        self.rowHeight = height;
        return self;
    };
}



#pragma mark style

- (UITableView *(^)(UIColor *))at_backgroundColor{
    return ^(UIColor *color){
        self.backgroundColor = color;
        return self;
    };
}



@end
