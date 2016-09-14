//
//  SceneViewController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-13.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "SceneViewController.h"
#import "ATRadarAnimationView.h"
#import "SceneTableViewCell.h"
#import "MJRefresh.h"
#import "HomeViewController.h"
#import "UITableView+ATTableView.h"

#define NIB_SCENE @"SceneTableViewCell"
@interface SceneViewController () <UITableViewDataSource, UITableViewDelegate>

// table view
@property (strong, nonatomic) UITableView *tableView;
// scene list
@property (strong, nonatomic) NSMutableArray<ATProfiles *> *sceneList;
// selected row
@property (assign, nonatomic) NSUInteger selectedRow;
// selected left view
@property (strong, nonatomic) UIView *selectedView;
// selected left view point.y
@property (assign, nonatomic) CGFloat selectedY;

@end

@implementation SceneViewController

#pragma mark - view events

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // init UI
    [self _initUI];
    // subscribe RAC
    [self subscribeRAC];
    // setup table view
    [self setupTableView];
    // setup selected view
    [self setupSelectedView];
    // setup navigation bar
    [self setupNavigationBar];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [self reloadData];
}

- (void)viewDidDisappear:(BOOL)animated{
    [self.tableView setEditing:NO animated:YES];
    [ATFileManager saveProfilesList:self.sceneList];
}

#pragma mark - private methods

// setup selectedview
- (void)setupSelectedView{
    // init and add to superview
    self.selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 110)];
    [self.view addSubview:self.selectedView];
    // style
    self.selectedView.backgroundColor = atColor.themeColor;
}

// reload data
- (void)reloadData{
    
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    
}

// set selected row
- (void)setSelectedRow:(NSUInteger)selectedRow{
    _selectedRow = selectedRow;
    [UIView animateWithDuration:0.38f animations:^{
        self.selectedView.at_y = self.tableView.rowHeight * selectedRow + 1 - self.tableView.contentOffset.y;
    }];
}


#pragma mark lazy load

// sceneList
- (NSMutableArray<ATProfiles *> *)sceneList{
    if (!_sceneList) {
        _sceneList = [ATFileManager readProfilesList];
    }
    return _sceneList;
}


#pragma mark initialization methods

// init UI
- (void)_initUI{
    
}

// subscribeRAC
- (void)subscribeRAC{
    [self.didSelected subscribeNext:^(id x) {
        [self.tableView.mj_header beginRefreshing];
    }];
}

// setup navigation bar
- (void)setupNavigationBar{
    self.navigationItem.title = @"情景模式";
    // left button
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"scene_menu" highImage:@"scene_menu" action:^{
        if (self.tableView.editing) {
            [self.tableView setEditing:NO animated:YES];
        }else{
            [self.tableView setEditing:YES animated:YES];
        }
    }];
    // right button
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"scene_add" highImage:@"scene_add" action:^{
        ATProfiles *aProfiles = [ATProfiles defaultProfiles];
        [self.sceneList insertObject:aProfiles atIndex:0];
        self.selectedRow += 1;
        [ATFileManager saveProfilesList:self.sceneList];
        [self.tableView.mj_header endRefreshing];
        [self.tableView setEditing:NO animated:YES];
    }];
    
}

// setup table view
- (void)setupTableView{
    // init and add to superview
    self.tableView = [UITableView at_tableViewWithTarget:self frame:normal registerNibForCellReuseIdentifier:NIB_SCENE];
    // table header and footer height
    self.tableView.at_tableHeaderView(none).at_sectionHeaderHeight(0).at_rowHeight(110);
    // refresh
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableView.mj_header endRefreshing];
        [self reloadData];
    }];
    
}



#pragma mark - table view data source

// number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// number of rows in section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sceneList.count;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // dequeue reusable cell with reuse identifier
    SceneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NIB_SCENE];
    // do something
    cell.model = self.sceneList[indexPath.row];
    // return cell
    return cell;
}

// commit editing style
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    // will delete
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // NSMutableArray remove object at index
        [self.sceneList removeObjectAtIndex:indexPath.row];
        // save cache
        [ATFileManager saveProfilesList:self.sceneList];
        // table view delete rows at index path
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        if (self.selectedRow || !self.sceneList.count) {
            self.selectedRow -= 1;
        }
    }
}

// move
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    // get source from modelList
    id source = self.sceneList[sourceIndexPath.row];
    // remove source from modelList
    [self.sceneList removeObjectAtIndex:sourceIndexPath.row];
    // insert source to destination index path
    [self.sceneList insertObject:source atIndex:destinationIndexPath.row];
    // save cache
    [ATFileManager saveProfilesList:self.sceneList];
}


#pragma mark table view delegate

// did select row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // deselect row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // do something
    // apply scene mode
    [atCentralManager letSmartLampApplyProfiles:self.sceneList[indexPath.row]];
    self.selectedRow = indexPath.row;
    [self.tableView.mj_header endRefreshing];
}


#pragma mark - scroll view delegate

// will begin dragging
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.selectedY = _selectedView.at_y + scrollView.contentOffset.y;
}

// scrolling
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.selectedView.at_y = self.selectedY - scrollView.contentOffset.y;
}

// did zoom
- (void)scrollViewDidZoom:(UIScrollView *)scrollView NS_AVAILABLE_IOS(3_2){
    
}

// did scroll to top
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    
}


@end
