//
//  BluetoothViewController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-04-21.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "BluetoothViewController.h"

@interface BluetoothViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *deviceListTableView;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) NSTimer *myTimer;

@property (assign, nonatomic) CGFloat myTimerProgress;

@end

@implementation BluetoothViewController

#pragma mark - 视图事件 🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀

- (void)viewDidLoad {
    [super viewDidLoad];
//     Do any additional setup after loading the view.
    
    [self initialization];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    if (self.iPhone.isConnecting) {
        
        [self pushAlertViewWithTitle:@"您已连接"
                          andMessage:[NSString stringWithFormat:@"是否断开与\"%@\"的连接?",[[ATFileManager readFile:ATFileTypeDevice] lastObject]]
                               andOk:@"断开"
                           andCancel:@"取消"
                       andOkCallback:^{
                           
                           // 连接选中的蓝牙灯
                           [self.iPhone disConnectSmartLamp];
                           
                       }
                   andCancelCallback:^{}];
        
    }
        
    // 页面刚出现的时候自动搜索蓝牙设备, 优化体验
    [self searchDevice];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

// 页面消失后, 
-(void)viewDidDisappear:(BOOL)animated{
    
    [self.myTimer invalidate];
    [self.iPhone  stopScan];
    
}



#pragma mark - 控件事件 🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀

// 点击了清空按钮
- (IBAction)clearButton:(UIBarButtonItem *)sender {
    
    [ATFileManager removeFile:ATFileTypeDevice];
    
}


#pragma mark - 代理方法 🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵


#pragma mark 🔵 UITableView DataSource

// 每一组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    // 行数等于搜索到的蓝牙设备的个数(已过滤掉其他蓝牙设备,仅保留蓝牙灯)
    return self.iPhone.scanedDeviceList.count;
    
}

// 每一行显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /*======================[ 1.创建可重用的cell ]======================*/
    static NSString *reuseId = @"smartLamps";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
        
        /*🖥*/NSLog(@"新建了一个cell");
        
    }
    
    /*======================[ 2.给cell内子控件赋值 ]======================*/
    // 实例化
    CBPeripheral *device = self.iPhone.scanedDeviceList[indexPath.row];
    
    // 给控件赋值
    cell.textLabel.text = device.name;
    cell.imageView.image = [UIImage imageNamed:@"smartLamp"];
    cell.detailTextLabel.text = @"可用的蓝牙灯设备";
    
    /*======================[ 3.返回cell ]======================*/
    return cell;
    
    
}


#pragma mark 🔵 UITableView Delegate

// 选中某一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    // ==================== [ 实例化选中的对象 ] ==================== //
    CBPeripheral *selected = self.iPhone.scanedDeviceList[indexPath.row];
    
    
    // ==================== [ 生成UIAlertController ] ==================== //
    [self pushAlertViewWithTitle:@"连接"
                      andMessage:[NSString stringWithFormat:@"是否连接\"%@\"?",selected.name]
                           andOk:@"连接"
                       andCancel:@"取消"
                   andOkCallback:^{
                       // 连接选中的蓝牙灯
                       [self.iPhone connectSmartLamp:selected];
                       // 保存已连接的设备
                       [self saveConnectedDevice:selected.name];
                       // 返回上个页面, 如果不加延时会打断数据传送导致崩溃
                       [self performSelector:@selector(popBack) withObject:nil afterDelay:2.0];
                       NSLog(@"连接了");
                       
                   }
               andCancelCallback:^{}];
    
}


#pragma mark - 私有方法 🚫🚫🚫🚫🚫🚫🚫🚫🚫🚫

- (void)initialization{
    
    // ==================== [ 下拉刷新的初始化 ] ==================== //
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self
                            action:@selector(searchDevice)
                  forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新设备列表"];
    
    [self.deviceListTableView addSubview:self.refreshControl];
    
    
    
}

// 返回上个页面
- (void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

// 搜索设备
- (void)searchDevice{
    
    // 正在搜索的时候又按下了搜索按钮, 就忽略重复指令
    // 只有在myTimerProgress为0的时候才执行
    if (!self.myTimerProgress) {
        
        // 中心设备开始扫描
        [self.iPhone startScan];
        
        // ==================== [ 刷新视图 ] ==================== //
        // 必须置为非0值,防止重复执行
        self.myTimerProgress = 1;
        // 开始刷新
        [self.refreshControl beginRefreshing];
        // 刷新视图的标题
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"正在扫描可用设备"];
        
        // 每隔一段时间查看一次 self.iPhone.scanedDeviceList
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scaning:) userInfo:nil repeats:YES];
        
    }
    
}

// 循环调用的扫描方法
- (void)scaning:(id)sender{
    
    // 步进
    self.myTimerProgress += 1.0;
    // 刷新TableView
    [self.deviceListTableView reloadData];
    
    // 如果扫描到了设备或者时间超过上限(5秒)
    if (self.iPhone.scanedDeviceList.count||self.myTimerProgress>4) {
        
        // 时间到了依然没有找到设备(同时要求设备没有连接)就弹出未找到设备的消息
        if (!self.iPhone.scanedDeviceList.count&&!self.iPhone.isConnecting) {
            [self pushAlertViewWithTitle:@"未发现蓝牙设备"
                              andMessage:@"请检查蓝牙灯电源是否打开"
                                   andOk:@"好的"
                               andCancel:@""
                           andOkCallback:^{}
                       andCancelCallback:^{}];
        }
        
        // 停止定时器
        self.myTimerProgress = 0;
        [self.myTimer invalidate];
        [self.myTimer fire];
        
        // 停止刷新
        [self.refreshControl endRefreshing];
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新设备列表"];
        
        // 调用后台刷新
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                        target:self
                                                      selector:@selector(scaningBackstage:)
                                                      userInfo:nil
                                                       repeats:YES];
        
    }
    
}

// 在后台以缓慢的速度刷新
- (void)scaningBackstage:(id)sender{
    
    // 步进
    self.myTimerProgress += 3.0;
    // 刷新TableView
    [self.deviceListTableView reloadData];
    
    // 时间超过上限(大约100秒)
    if (self.myTimerProgress>100) {

        // 停止定时器
        self.myTimerProgress = 0;
        [self.myTimer invalidate];
        [self.myTimer fire];
        // 停止扫描
        [self.iPhone stopScan];
        
    }
    
}

// 保存已连接的设备名
- (void)saveConnectedDevice:(NSString *)deviceName{
    
    NSMutableArray *plist = [ATFileManager readFile:ATFileTypeDevice];
    if ([plist containsObject:deviceName]) {
        [plist removeObject:deviceName];
    }
    [plist addObject:deviceName];
    [ATFileManager saveFile:ATFileTypeDevice withPlist:plist];
    
}


@end
