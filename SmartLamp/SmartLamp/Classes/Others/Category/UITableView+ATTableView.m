//
//  UITableView+ATTableView.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-05.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "UITableView+ATTableView.h"
#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height


#define style_plain   UITableViewStylePlain
#define style_grouped UITableViewStyleGrouped

@implementation UITableView (ATTableView)

#pragma mark - creator

+ (instancetype)at_tableViewWithTarget:(UIViewController<UITableViewDataSource, UITableViewDelegate> *)target
                                 frame:(CGRect)frame
     registerNibForCellReuseIdentifier:(NSString *)reuseId {
    
    // init and add to superview
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_W, SCREEN_H-64-49) style:UITableViewStylePlain];
    tableView.dataSource = target;
    tableView.delegate = target;
    [target.view addSubview:tableView];
    [tableView registerNib:[UINib nibWithNibName:reuseId bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuseId];
    
    // style
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // table header and footer
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    
    // section header and footer
//    tableView.sectionHeaderHeight = 40;
    
    // cell
//    tableView.rowHeight = 110;
    
    // reutrn
    return tableView;
}

+ (instancetype)at_tableViewWithTarget:(UIViewController<UITableViewDataSource, UITableViewDelegate> *)target
                                 frame:(CGRect)frame
     registerNibForCellReuseIdentifier:(NSString *)reuseId detail:(void (^)(UITableView *tableView))detail {
    UITableView *tableView = [self at_tableViewWithTarget:target frame:frame registerNibForCellReuseIdentifier:reuseId];
    detail(tableView);
    return tableView;
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
