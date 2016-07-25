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
#import <MJRefresh.h>

#define NIB_DEVICE @"DeviceTableViewCell"
@interface DeviceViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) CBPeripheral *connectedPeripheral;

@property (strong, nonatomic) NSArray *scanedDeviceList;

@end

@implementation DeviceViewController

#pragma mark - 视图事件

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 初始化导航栏
    [self _initNavigationBar];
    // 初始化表视图
    [self _initTableView];
    // 设置通知
    [self _setupNotification];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.rootVC.allowsShowAlert = NO;
    [atCentralManager startScanWithAutoTimeout];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [atCentralManager stopScan];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.rootVC.allowsShowAlert = YES;
}


#pragma mark - 私有方法

#pragma mark 初始化
// 初始化导航栏
- (void)_initNavigationBar{
    self.navigationItem.title = @"设备";
}

// 初始化tableview
- (void)_initTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:NIB_DEVICE bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NIB_DEVICE];
    self.tableView.rowHeight = 70;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 50)];
    
    
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = atColor.backgroundColor;
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [atCentralManager startScanWithAutoTimeout];
    }];
    
}
// 设置通知
- (void)_setupNotification{
    [atNotificationCenter addObserver:self selector:@selector(receiveFoundDeviceNotification:) name:NOTI_BLE_SCAN object:nil];
    [atNotificationCenter addObserver:self selector:@selector(receiveConnectNotification:) name:NOTI_BLE_CONNECT object:nil];
}

#pragma mark 懒加载
// 已连接的设备
- (CBPeripheral *)connectedPeripheral{
    if (!_connectedPeripheral) {
        _connectedPeripheral = [atCentralManager connectedPeripheral];
    }
    return _connectedPeripheral;
}
// 懒加载 - 扫描到的设备列表
- (NSArray *)scanedDeviceList{
    if (!_scanedDeviceList) {
        _scanedDeviceList = [atCentralManager scanedDeviceList];
    }
    return _scanedDeviceList;
}
#pragma mark 通知
// 扫描通知
- (void)receiveFoundDeviceNotification:(NSNotification *)noti{
    if ([noti.name isEqualToString:NOTI_BLE_SCAN]) {
        // 开始扫描
        if ([noti.object isEqualToString:NOTI_BLE_SCAN_START]) {
            
        }
        // 停止扫描
        else if ([noti.object isEqualToString:NOTI_BLE_SCAN_STOP]){
            [self reloadData];
        }
        // 发现设备
        else if ([noti.object isEqualToString:NOTI_BLE_SCAN_FOUND]) {
            
            
        }
        // 未发现设备
        else if ([noti.object isEqualToString:NOTI_BLE_SCAN_NOTFOUND]){
            
            
        }
    }
}
// 连接状态通知
- (void)receiveConnectNotification:(NSNotification *)noti{
    if ([noti.name isEqualToString:NOTI_BLE_CONNECT]) {
        [self reloadData];
    }
}
// 重载数据
- (void)reloadData{
    self.connectedPeripheral = [atCentralManager connectedPeripheral];
    self.scanedDeviceList = [atCentralManager scanedDeviceList];
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
}

#pragma mark - 数据源和代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.scanedDeviceList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NIB_DEVICE];
    cell.model = self.scanedDeviceList[indexPath.row];
    
    if ([self.scanedDeviceList[indexPath.row] isEqual:self.connectedPeripheral]) {
        cell.cell_switch.on = YES;
    } else {
        cell.cell_switch.on = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}



@end
