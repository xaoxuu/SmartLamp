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
#import <MJRefresh.h>
#import "HomeViewController.h"

#define NIB_SCENE @"SceneTableViewCell"
@interface SceneViewController () <UITableViewDataSource, UITableViewDelegate>
// table view
@property (strong, nonatomic) UITableView *tableView;

// 情景模式列表
@property (strong, nonatomic) NSMutableArray<ATProfiles *> *sceneList;
// 已选行
@property (assign, nonatomic) NSUInteger selectedRow;
// 已选行左侧的view
@property (strong, nonatomic) UIView *selectedView;
// 已选行的y坐标
@property (assign, nonatomic) CGFloat selectedY;

@end

@implementation SceneViewController
#pragma mark - 视图事件
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 初始化table view
    [self _initTableView];
    // 初始化UI
    [self _initUI];
    // 初始化导航栏
    [self _initNavigationBar];
    
    
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

#pragma mark - 私有方法

#pragma mark 懒加载
- (NSMutableArray<ATProfiles *> *)sceneList{
    if (!_sceneList) {
        _sceneList = [ATFileManager readProfilesList];
    }
    return _sceneList;
}
#pragma mark 🚫 初始化

- (void)_initUI{
    
    self.selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 110)];
    self.selectedView.backgroundColor = atColor.themeColor;
    [self.view addSubview:self.selectedView];
    
    
}

- (void)_initNavigationBar{
    self.navigationItem.title = @"情景模式";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"scene_menu" highImage:@"scene_menu" target:self action:@selector(leftBarBtn)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"scene_add" highImage:@"scene_add" target:self action:@selector(rightBarBtn)];
    
}

// 导航栏左按钮
- (void)leftBarBtn{
    if (self.tableView.editing) {
        [self.tableView setEditing:NO animated:YES];
    }else{
        [self.tableView setEditing:YES animated:YES];
    }
}
// 导航栏右按钮
- (void)rightBarBtn{
    ATProfiles *aProfiles = [ATProfiles defaultProfiles];
    [self.sceneList insertObject:aProfiles atIndex:0];
    self.selectedRow += 1;
    [ATFileManager saveProfilesList:self.sceneList];
    [self reloadData];
    [self.tableView setEditing:NO animated:YES];
}

- (void)_initTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:NIB_SCENE bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NIB_SCENE];
    self.tableView.rowHeight = 110;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 76)];
    
    self.tableView.sectionHeaderHeight = 0;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = atColor.backgroundColor;
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self reloadData];
    }];
    
}

#pragma mark 重载数据

- (void)reloadData{
    
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    
    
}

// 设置选中行
- (void)setSelectedRow:(NSUInteger)selectedRow{
    _selectedRow = selectedRow;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.selectedView.at_y = self.tableView.rowHeight * selectedRow + 1 - self.tableView.contentOffset.y;
    }];
    
}

#pragma mark - 🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵 数据源和代理


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sceneList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SceneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NIB_SCENE];
    cell.model = self.sceneList[indexPath.row];
    return cell;
}

// 选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 应用情景模式
    [atCentralManager letSmartLampApplyProfiles:self.sceneList[indexPath.row]];
    self.selectedRow = indexPath.row;
    [self reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}


// 删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.sceneList removeObjectAtIndex:indexPath.row];
        [ATFileManager saveProfilesList:self.sceneList];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        if (self.selectedRow || !self.sceneList.count) {
            self.selectedRow -= 1;
        }
    }
}
// 移动
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    id source = self.sceneList[sourceIndexPath.row];
    [self.sceneList removeObjectAtIndex:sourceIndexPath.row];
    [self.sceneList insertObject:source atIndex:destinationIndexPath.row];
    [ATFileManager saveProfilesList:self.sceneList];
    
}

// 开始滑动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.selectedY = _selectedView.at_y + scrollView.contentOffset.y;
}

// 滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.selectedView.at_y = self.selectedY - scrollView.contentOffset.y;
}

@end
