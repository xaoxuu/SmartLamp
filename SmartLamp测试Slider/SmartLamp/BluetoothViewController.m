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

#pragma mark - 🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀 视图事件

- (void)viewDidLoad {
    [super viewDidLoad];
//     Do any additional setup after loading the view.
    
    [self initialization];
    
    
}
// 隐藏状态栏
- (BOOL)prefersStatusBarHidden{
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    

  
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    // 页面刚出现的时候自动搜索蓝牙设备, 优化体验
    if (!self.iPhone.scanedDeviceList) {
        [self searchDevice];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

// 页面消失后, 
-(void)viewDidDisappear:(BOOL)animated{
    
    [self.myTimer invalidate];
    [self.iPhone  stopScan];
    
}



#pragma mark - 🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀 控件事件

// 点击了清空按钮
- (IBAction)clearButton:(UIBarButtonItem *)sender {
    
    // 断开连接
    [self.iPhone disConnectSmartLamp];
    
    // 清空本地缓存
    [ATFileManager removeFile:ATFileTypeDevice];
    
    // 弹窗提示
    [self showAlertWithClearList];
    
}

#pragma mark - 🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵 连接设备

// 搜索设备
- (void)searchDevice{
    
    // 正在搜索的时候又触发了搜索方法, 就忽略重复指令
    // 只有在myTimerProgress为0的时候才执行
    if (!self.myTimerProgress) {
        
        // ==================== [ 初始化定时器 ] ==================== //
        // 必须置为非0值,防止重复执行
        self.myTimerProgress = 1;
        [self.myTimer invalidate];
        [self.myTimer fire];
        
        // ==================== [ 刷新视图 ] ==================== //
        // 开始刷新
        [self.refreshControl beginRefreshing];
        // 刷新视图的标题
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"正在扫描可用设备"];
        
        
        // ==================== [ 扫描 ] ==================== //
        [self.iPhone startScan];
        
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
        
        // 停止定时器
        self.myTimerProgress = 0;
        [self.myTimer invalidate];
        [self.myTimer fire];
        
        // 停止刷新
        [self.refreshControl endRefreshing];
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新设备列表"];
        
        // 时间到了依然没有找到设备(同时要求设备没有连接)就弹出未找到设备的消息
        if (!self.iPhone.scanedDeviceList.count&&!self.iPhone.isConnecting) {
            
            [self showAlertWithDeviceNotFoundWithAction:^{
                [self searchDevice];
            }];
            
            
        }
        
        
    }
    
}


#pragma mark - 🚫🚫🚫🚫🚫🚫🚫🚫🚫🚫 私有方法 

#pragma mark 🚫 初始化

- (void)initialization{
    
    // ==================== [ 下拉刷新的初始化 ] ==================== //
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self
                            action:@selector(searchDevice)
                  forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新设备列表"];
    
    [self.deviceListTableView addSubview:self.refreshControl];
    
    
    
}

#pragma mark 🚫 调用
// 返回上个页面
- (void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 🚫 保存数据
// 保存已连接的设备名
- (void)saveConnectedDevice:(NSString *)deviceName{
    
    NSMutableArray *plist = [ATFileManager readFile:ATFileTypeDevice];
    if ([plist containsObject:deviceName]) {
        [plist removeObject:deviceName];
    }
    [plist addObject:deviceName];
    [ATFileManager saveFile:ATFileTypeDevice withPlist:plist];
    
}


#pragma mark 🚫 AlertView

// 是否连接
- (void)showAlertWithWhetherConnectWithAction:(void (^)())action deviceName:(NSString *)deviceName{
    
    SCLAlertView *alert = self.newAlert;
    
    [alert addButton:@"连接" actionBlock:^{
        action();
        NSLog(@"点击了连接");
    }];
    NSString *subTitle = [NSString stringWithFormat:@"是否连接蓝牙灯\"%@\"?",deviceName];
    [alert showQuestion:self title:@"是否连接" subTitle:subTitle closeButtonTitle:@"取消" duration:0.0f];
    
    
}

// 清空已连接设备缓存
- (void)showAlertWithClearList{
    
    SCLAlertView *alert = self.newAlert;
    [alert showSuccess:self title:@"清空缓存" subTitle:@"已经清空已连接的设备缓存。" closeButtonTitle:@"我知道了" duration:0.0f];
    
    
}

#pragma mark - 🔵 代理方法 🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵


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
    
    [self showAlertWithWhetherConnectWithAction:^{
        // 连接选中的蓝牙灯
        [self.iPhone connectSmartLamp:selected];
        // 保存已连接的设备
        [self saveConnectedDevice:selected.name];
        // 返回上个页面, 如果不加延时会打断数据传送导致崩溃
        [self performSelector:@selector(popBack) withObject:nil afterDelay:2.0];
        
        // 显示正在连接
        [self.alertForScaning hideView];
        [self showAlertWithConnecting];
        
        
    } deviceName:selected.name];
    
}




@end
