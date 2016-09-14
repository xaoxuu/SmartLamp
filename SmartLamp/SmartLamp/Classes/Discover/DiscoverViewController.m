//
//  DiscoverViewController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-02.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DiscoverTableViewCell.h"
#import "DiscoverTableHeaderView.h"
#import <MJRefresh/MJRefresh.h>
#import "UITableView+ATTableView.h"

#define NIB_DISCOVER @"DiscoverTableViewCell"
@interface DiscoverViewController () <UITableViewDataSource, UITableViewDelegate>



// headerimage
@property (strong, nonatomic) UIImageView *headerImage;
// tableview
@property (strong, nonatomic) UITableView *tableView;

// content view
@property (strong, nonatomic) UIView *contentView;

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _initUI];
    [self subscribeRAC];
    [self setupHeaderView];
    [self setupNavigationBar];
    [self setupTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{

}

- (void)subscribeRAC{
    [self.didSelected subscribeNext:^(id x) {
        [self.tableView.mj_header beginRefreshing];
    }];
}

// init UI
- (void)_initUI{
    self.view.backgroundColor = atColor.backgroundColor;
    [self.navigationController setNavigationBarHidden:YES];
}

// setup header view
- (void)setupHeaderView{
    // init and add to superview
    self.headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 160)];
    [self.view addSubview:self.headerImage];
    // style
    self.headerImage.image = [UIImage imageNamed:@"discover_cover"];
    self.headerImage.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImage.clipsToBounds = YES;
    
}

// setup navigation bar
- (void)setupNavigationBar{
    // init and add to superview
    UIView *nav = [[[NSBundle mainBundle]loadNibNamed:@"DiscoverNavigation" owner:nil options:nil]firstObject];
    [self.view addSubview:nav];
    // style
    
}

// setup tableview
- (void)setupTableView{
    
    // init and add to superview
    self.tableView = [UITableView at_tableViewWithTarget:self frame:normal registerNibForCellReuseIdentifier:NIB_DISCOVER];
    // style
    self.tableView.at_backgroundColor(atColor.clear);
    // header and footer height
    self.tableView.at_tableHeaderView(viewWithHeight(96));
    self.tableView.at_sectionHeaderHeight(40).at_rowHeight(110);
    // refresh
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableView.mj_header endRefreshing];
    }];
    
}



#pragma mark - table view data source

// number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// number of rows in section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // dequeue reusable cell with reuse identifier
    DiscoverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NIB_DISCOVER];
    // do something
//    cell.model = self.<#modelList#>[indexPath.row];
    // return cell
    return cell;
}


#pragma mark table view delegate

// did select row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // deselect row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // do something
    
}

// header for section
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[DiscoverTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 40)];
}


#pragma mark - scroll view delegate

// scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y<96) {
        CGRect frame = CGRectMake(0, 0, SCREEN_W, 160);
        frame.size.height = 160 - scrollView.contentOffset.y;
        self.headerImage.frame = frame;
    }
}



@end
