//
//  DeviceViewController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-13.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

// support file
#import "DeviceViewController.h"
#import "ATManager+TableView.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
// child
#import "DeviceTableViewCell.h"
// macro
#define NIB_DEVICE @"DeviceTableViewCell"

@interface DeviceViewController () <UITableViewDataSource, UITableViewDelegate>

// table view
@property (strong, nonatomic) UITableView *tableView;
// connected peripheral
@property (strong, nonatomic) CBPeripheral *aPeripheral;
// scaned device list
@property (strong, nonatomic) NSArray *peripheralList;

@end

@implementation DeviceViewController

#pragma mark - view events

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    // setupTableView
    [self setupTableView];
    // setupNavigationBar
    [self setupNavigationBar];
    // subscribeRAC
    [self subscribeRAC];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // do not allows to show alert
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.rootVC.allowsShowAlert = NO;
    // reload data
    [self reloadData];
    if (!atCentral.aPeripheral) {
        atCentral.startScanWithAutoTimeout();
    }
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    // do not allows to show alert
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.rootVC.allowsShowAlert = YES;
    // reload data
    [self reloadData];
    // stop scan
    atCentral.stopScan();
}


#pragma mark - private methods

#pragma mark initialization methods

// setup navigation bar
- (void)setupNavigationBar{
    
    self.atNavigationView = [ATNavigationView viewWithBarTintColor:atColor.theme height:64 title:@"设备"];
    [self.view addSubview:self.atNavigationView];
    
    [self.atNavigationView at_rightButtonWithImage:@"icon_refresh" action:^{
        // start scan
        [self.tableView.mj_header beginRefreshing];
    }];
    
}

// setup table view
- (void)setupTableView{
    // init and add to superview
    self.tableView = [UITableView at_tableViewWithTarget:self frame:top(44) style:UITableViewStylePlain registerNibForCellReuseIdentifier:NIB_DEVICE];
    // table header and footer height
    self.tableView.at_tableHeaderView(none()).at_rowHeight(70);
    // refresh
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        atCentral.startScanWithAutoTimeout();
        [self.tableView.mj_header performSelector:@selector(endRefreshing) withObject:nil afterDelay:atCentral.scanTimeout];
    }];
    
}

// subscribeRAC
- (void)subscribeRAC{
    [atCentral.didScannable subscribeNext:^(id x) {
        if (![x boolValue]) {
            [self.tableView.mj_header endRefreshing];
        }
    }];
    [atCentral.didScaning subscribeNext:^(id x) {
        if ([x boolValue]) {
            // start scan
            [self.tableView.mj_header beginRefreshing];
        } else{
            // stop scan -> reload data
            [self reloadData];
        }
        
    }];
    
    // refresh data
    [self.didSelected subscribeNext:^(id x) {
        [self.tableView.mj_header beginRefreshing];
    }];
    
}

// reloadData
- (void)reloadData{
    self.aPeripheral = atCentral.aPeripheral;
    self.peripheralList = atCentral.peripheralList;
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
}


#pragma mark lazy load

// aPeripheral
- (CBPeripheral *)aPeripheral{
    if (!_aPeripheral) {
        _aPeripheral = atCentral.aPeripheral;
    }
    return _aPeripheral;
}

// peripheralList
- (NSArray *)peripheralList{
    if (!_peripheralList) {
        _peripheralList = atCentral.peripheralList;
    }
    return _peripheralList;
}


#pragma mark - table view data source

// number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// number of rows in section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.peripheralList.count;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // dequeue reusable cell with reuse identifier
    DeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NIB_DEVICE];
    // do something
    cell.model = self.peripheralList[indexPath.row];
    if ([self.peripheralList[indexPath.row] isEqual:self.aPeripheral]) {
        cell.cell_switch.on = YES;
    } else {
        cell.cell_switch.on = NO;
    }
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




@end
