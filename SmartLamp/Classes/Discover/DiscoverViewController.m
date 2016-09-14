//
//  DiscoverViewController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-02.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

// support file
#import "DiscoverViewController.h"
#import "ATTabBarView+MD.h"

#import "DiscoverHeaderView.h"
#import "DiscoverTableView.h"


@interface DiscoverViewController () <UIScrollViewDelegate>

// tool bar
@property (strong, nonatomic) ATTabBarView *atToolBar;
// header view
@property (strong, nonatomic) UIView *headerView;
// tool bar view
@property (strong, nonatomic) UIView *titleView;
// content view
@property (strong, nonatomic) UIView *contentView;

// titles
@property (strong, nonatomic) NSArray<NSString *> *titles;
// index
@property (assign, nonatomic) NSUInteger index;

@end


static CGFloat height_nav = 64;

static CGFloat height_tool = 40;
static CGFloat height_header = 160;

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _initData];
    [self _initUI];
    [self subscribeRAC];
    
    [self setupSubviews];
    
    [self setupToolBar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    
}

- (void)subscribeRAC{
    [self.didSelected subscribeNext:^(id x) {
        
    }];
}

- (void)_initData{
    
    // 新闻标题和标题id
    _titles = @[@"图文并茂",@"搞笑图片",@"精彩段子",@"音频",@"视频"];
    
    self.index = 0;
    
}



// init UI
- (void)_initUI{
    self.view.backgroundColor = atColor.background;
    [self.navigationController setNavigationBarHidden:YES];
}


// setup views
- (void)setupSubviews{
    [self.view addSubview:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)]];
    // header view
    self.headerView = [DiscoverHeaderView headerWithHeight:height_header];
    [self.view addSubview:self.headerView];
    // title view
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, height_tool)];
    self.titleView.bottom = self.headerView.bottom;
    [self.headerView addSubview:self.titleView];
    // nav
    self.atNavigationView = [ATNavigationView viewWithBarTintColor:atColor.clear height:64 title:@"发现"];
    [self.headerView addSubview:self.atNavigationView];
    
    // content
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, height_header, kScreenW, kScreenH - height_nav - height_tool - 49)];
    self.contentView.backgroundColor = atColor.groupTableViewBackground;
    [self.view insertSubview:self.contentView atIndex:0];
    
}

// setup tool bar
- (void)setupToolBar{
    
    self.atToolBar = [ATTabBarView tabBarWithTitleView:self.titleView titles:self.titles titleColor:atColor.white rippleColor:atColor.clear.darkRatio(0.2) contentView:self.contentView content:^UIView *(NSUInteger index) {
        // return a table view
        DiscoverTableView *tableView = [DiscoverTableView tableViewWithFrame:self.contentView.bounds index:index scrollViewDidScroll:^(UIScrollView *scrollView) {
            if (scrollView.contentOffset.y<height_header-height_nav-height_tool) {
                self.headerView.height = height_header - scrollView.contentOffset.y;
                self.titleView.bottom = self.headerView.bottom;
                // content view
                self.contentView.top = height_header - scrollView.contentOffset.y;
                
            } else{
                self.headerView.height = height_nav+height_tool;
                self.titleView.top = height_nav;
                // content view
                self.contentView.top = height_nav+height_tool;
            }
            
        }];
        return tableView;
    } action:^(NSUInteger index) {
        
    }];
    
}




@end
