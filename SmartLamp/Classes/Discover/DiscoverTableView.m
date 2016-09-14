//
//  DiscoverTableView.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-24.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "DiscoverTableView.h"
#import "NetworkManager.h"
#import "ATManager+View.h"
#import "ATManager+TableView.h"
#import "ATManager+Network.h"
#import <MJRefresh/MJRefresh.h>
#import <MJExtension/MJExtension.h>
// child
#import "DiscoverModel.h"

#import "DiscoverTableViewCell.h"

#import "WebViewController.h"

#define cachePath [@"ContentType" stringByAppendingFormat:@"%ld",self.contentType].cachePath

// macro
#define NIB_DISCOVER @"DiscoverTableViewCell"


@interface DiscoverTableView () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

// list
@property (strong, nonatomic) NSMutableArray<List *> *dataList;

// page
@property (assign, nonatomic) NSUInteger page;
// count
@property (assign, nonatomic) NSUInteger count;

// scroll
@property (copy, nonatomic) void (^scrollViewDidScroll)(UIScrollView *scrollView);


// content type
@property (assign, nonatomic) ContentType contentType;
// maxtime
@property (copy, nonatomic) NSString *maxtime;

@end

@implementation DiscoverTableView

+ (instancetype)tableViewWithFrame:(CGRect)frame index:(NSUInteger)index scrollViewDidScroll:(void (^)(UIScrollView *scrollView))scrollView{
    return [[self alloc] initWithFrame:frame index:index scrollViewDidScroll:scrollView];
}

- (instancetype)initWithFrame:(CGRect)frame index:(NSUInteger)index scrollViewDidScroll:(void (^)(UIScrollView *scrollView))scrollView{
    if (self = [super initWithFrame:frame]) {
        [self _initData];
        if (index <= 4) {
            self.contentType = index;
        }
        [self setupTableView];
        self.scrollViewDidScroll = scrollView;
    }
    return self;
}

- (void)_initData{
    
    _dataList = [NSMutableArray array];
    _page = 0;
    _count = 5;
}


- (void)reloadData {
    [self.tableView reloadData];
    [self.tableView.mj_header beginRefreshing];
}


// setup tableview
- (void)setupTableView{
    [self addSubview:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)]];
    // init and add to superview
    self.tableView = [UITableView at_tableViewWithView:self frame:self.bounds style:UITableViewStyleGrouped registerNibForCellReuseIdentifier:NIB_DISCOVER];
    // style
    self.tableView.at_backgroundColor(atColor.groupTableViewBackground);
    // header and footer height
    self.tableView.at_sectionHeaderHeight(8).at_sectionFooterHeight(8);
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    // refresh
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 0;
        [self loadNewDataFromNetwork];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.dataList.count) {
            _page++;
        }
        [self loadMoreDataFromNetwork];
    }];
    
    NSArray *cache = cachePath.readArray;
    self.dataList = [List mj_objectArrayWithKeyValuesArray:cache];
    [self loadNewDataFromNetwork];
    
}

- (void)loadNewDataFromNetwork{
    
    [HYBNetworking getWithUrl:atNetwork.url params:[atNetwork parameterWithContentType:self.contentType maxtime:nil page:0] success:^(id response) {
        [self.tableView.mj_header endRefreshing];
        // maxtime
        self.maxtime = response[@"info"][@"maxtime"];
        // get data
        NSArray *dataList = [response objectForKey:@"list"];
        self.dataList = [List mj_objectArrayWithKeyValuesArray:dataList];
        cachePath.savePlist(dataList);
        
        // main thread main queue update UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } fail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
    
    
}

- (void)loadMoreDataFromNetwork{
    [HYBNetworking getWithUrl:atNetwork.url params:[atNetwork parameterWithContentType:self.contentType maxtime:self.maxtime page:0] success:^(id response) {
        [self.tableView.mj_footer endRefreshing];
        // maxtime
        self.maxtime = response[@"info"][@"maxtime"];
        // get data
        NSArray *dataList = [response objectForKey:@"list"];
        NSArray<List *> *tmp = [List mj_objectArrayWithKeyValuesArray:dataList];
        [self.dataList addObjectsFromArray:tmp];
        cachePath.savePlist(dataList);
        
        // main thread main queue update UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } fail:^(NSError *error) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
}



#pragma mark - table view data source

// number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.count;
}

// number of rows in section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // dequeue reusable cell with reuse identifier
    DiscoverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NIB_DISCOVER];
    // do something
    cell.model = self.dataList[indexPath.section];
    // return cell
    return cell;
}


#pragma mark table view delegate

// did select row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // deselect row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // do something
//    List *news = self.dataList[indexPath.row];
//    WebViewController *web = [[WebViewController alloc] init];
//    web.title = news.title;
//    web.urlStr = news.link;
//    [self.controller.navigationController pushViewController:web animated:YES];
    
}


#pragma mark - scroll view delegate

// scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.scrollViewDidScroll) {
        self.scrollViewDidScroll(scrollView);
    }
    
}



@end
