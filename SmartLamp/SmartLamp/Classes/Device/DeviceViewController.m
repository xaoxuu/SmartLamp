//
//  DeviceViewController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-13.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "DeviceViewController.h"
#import "ATRadarAnimationView.h"

#import "DeviceTableViewCell.h"
#import "MJRefresh.h"
#import "UITableView+ATTableView.h"

#define NIB_DEVICE @"DeviceTableViewCell"
@interface DeviceViewController () <UITableViewDataSource, UITableViewDelegate>

// table view
@property (strong, nonatomic) UITableView *tableView;
// connected peripheral
@property (strong, nonatomic) CBPeripheral *connectedPeripheral;
// scaned device list
@property (strong, nonatomic) NSArray *scanedDeviceList;

@end

@implementation DeviceViewController

#pragma mark - view events

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // setupNavigationBar
    [self setupNavigationBar];
    // setupTableView
    [self setupTableView];
    // subscribeRAC
    [self subscribeRAC];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // do not allows to show alert
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.rootVC.allowsShowAlert = NO;
    // reload data
    [self reloadData];
    // start scan
    [atCentralManager startScanWithAutoTimeout];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    // do not allows to show alert
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.rootVC.allowsShowAlert = YES;
    // reload data
    [self reloadData];
    // stop scan
    [atCentralManager stopScan];
}


#pragma mark - private methods

#pragma mark initialization methods

// setup navigation bar
- (void)setupNavigationBar{
    self.navigationItem.title = @"设备";
}

// setup table view
- (void)setupTableView{
    // init and add to superview
    self.tableView = [UITableView at_tableViewWithTarget:self frame:normal registerNibForCellReuseIdentifier:NIB_DEVICE];
    // table header and footer height
    self.tableView.at_tableHeaderView(none).at_rowHeight(70);
    // refresh
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [atCentralManager startScanWithAutoTimeout];
        [self.tableView.mj_header performSelector:@selector(endRefreshing) withObject:nil afterDelay:3.0f];
    }];
    
}

// subscribeRAC
- (void)subscribeRAC{
    // stop scan -> reload data
    [atCentralManager.didStopScan subscribeNext:^(id x) {
        [self reloadData];
    }];
    // refresh data
    [self.didSelected subscribeNext:^(id x) {
        [self.tableView.mj_header beginRefreshing];
    }];
    
}

// reloadData
- (void)reloadData{
    self.connectedPeripheral = [atCentralManager connectedPeripheral];
    self.scanedDeviceList = [atCentralManager scanedDeviceList];
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
}


#pragma mark lazy load

// connectedPeripheral
- (CBPeripheral *)connectedPeripheral{
    if (!_connectedPeripheral) {
        _connectedPeripheral = [atCentralManager connectedPeripheral];
    }
    return _connectedPeripheral;
}

// scanedDeviceList
- (NSArray *)scanedDeviceList{
    if (!_scanedDeviceList) {
        _scanedDeviceList = [atCentralManager scanedDeviceList];
    }
    return _scanedDeviceList;
}


#pragma mark - table view data source

// number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// number of rows in section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.scanedDeviceList.count;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // dequeue reusable cell with reuse identifier
    DeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NIB_DEVICE];
    // do something
    cell.model = self.scanedDeviceList[indexPath.row];
    if ([self.scanedDeviceList[indexPath.row] isEqual:self.connectedPeripheral]) {
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
