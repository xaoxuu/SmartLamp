//
//  BluetoothViewController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-04-21.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "BluetoothViewController.h"


@interface BluetoothViewController () <UITableViewDataSource,UITableViewDelegate>

//@property (strong, nonatomic) MJRefreshHeader *header;

@property (weak, nonatomic) IBOutlet UITableView *smartLampListTableView;

@property (strong, nonatomic) UIRefreshControl *refreshControl;



@property (strong, nonatomic) NSTimer *myTimer;

@property (assign, nonatomic) CGFloat myTimerProgress;

@end

@implementation BluetoothViewController

#pragma mark - 视图事件 🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀

- (void)viewDidLoad {
    
    [super viewDidLoad];
//     Do any additional setup after loading the view.
    
    
    [self initWithRefreshControl];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    if (self.iPhone.connecting) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您已连接"
                                                                       message:[NSString stringWithFormat:@"是否断开与\"%@\"的连接?",self.iPhone.peripheral.name]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        
        // ==================== [ 生成UIAlertAction ] ==================== //
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"断开" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       
                                                       // 连接选中的蓝牙灯
                                                       [self.iPhone disConnectSmartLamp];
                                                       
                                                       
                                                       [self dismissViewControllerAnimated:YES completion:nil];
                                                       
                                                       [self searchBluetoothDevice];
                                                       
                                                   }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self searchBluetoothDevice];
        }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        
        /*======================[ push alertView ]======================*/
        [self presentViewController:alert animated:YES completion:nil];
        
    
        
    } else{
        
        // 页面刚出现的时候自动搜索蓝牙设备, 优化体验
        [self searchBluetoothDevice];
        
    }
    
    
    

    
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
    self.smartLampList = nil;
    [self.iPhone stopScan];
    
}





//-(void)viewWillDisappear:(BOOL)animated{
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - 控件事件 🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀


// 点击了搜索按钮
- (IBAction)searchButton:(UIBarButtonItem *)sender {
    
    [ATFileManager removeFile:ATFileTypeDevice];
    // 调用搜索的方法, 之所以这样封装起来, 是为了在其他条件下调用
    [self searchBluetoothDevice];
    
}





















#pragma mark - 代理方法 🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵


#pragma mark 🔵 UITableView DataSource

// 每一组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.smartLampList.count;
    
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
    CBPeripheral *smartLamp = self.smartLampList[indexPath.row];
    
    
    
    
    // 给控件赋值
    cell.textLabel.text = smartLamp.name;
    cell.imageView.image = [UIImage imageNamed:@"smartLamp"];
    cell.detailTextLabel.text = @"可用的蓝牙灯设备";
    
    /*======================[ 3.返回cell ]======================*/
    return cell;
    
    
}



#pragma mark 🔵 UITableView Delegate

// 选中某一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    // ==================== [ 实例化选中的对象 ] ==================== //
    CBPeripheral *selectedSmartLamp = self.smartLampList[indexPath.row];
    
    
    // ==================== [ 生成UIAlertController ] ==================== //

    [self pushAlertViewWithTitle:@"连接"
                      andMessage:[NSString stringWithFormat:@"是否连接\"%@\"?",selectedSmartLamp.name]
                           andOk:@"连接"
                       andCancel:@"取消"
                   andOkCallback:^{
                       // 连接选中的蓝牙灯
                       [self.iPhone connectSmartLamp:selectedSmartLamp];
                       
                       // 保存已连接的设备
                       [self saveConnectedDevice:selectedSmartLamp.name];
                       
                       // 返回上个页面并显示连接成功, 如果不加延时会打断数据传送导致崩溃
                       [self performSelector:@selector(popBack) withObject:nil afterDelay:2.0];
                       
                       NSLog(@"连接了");
                       
                       
                   }  andCancelCallback:^{
                       
                   }];
}


#pragma mark - 私有方法 🚫🚫🚫🚫🚫🚫🚫🚫🚫🚫

- (void)popBack{
    
    // 返回上个页面并显示连接成功
    [self.navigationController popViewControllerAnimated:YES];
    
}

// 初始化RefreshControl
- (void)initWithRefreshControl{
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self
                            action:@selector(searchBluetoothDevice)
                  forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新设备列表"];
    
    [self.smartLampListTableView addSubview:self.refreshControl];
    
}

// 刷新列表方法
- (void)refreshTableViewAction:(UIRefreshControl *)refreshControl{
    
    // ==================== [ 搜索前的准备 ] ==================== //
    [self.iPhone readyForScan];
    self.myTimerProgress = 1;
    if (!self.refreshControl.refreshing) [self.refreshControl beginRefreshing];
    // 每次点击搜索按钮都清空上一次的数据, 并重新搜索新的蓝牙列表数据
    self.smartLampList = nil;
    
    
    if (refreshControl.refreshing) {
        
        refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"正在扫描可用设备"];
        [self searchBluetoothDevice];
        
    }
    
}

// 搜索设备
- (void)searchBluetoothDevice{
    
    // 正在搜索的时候又按下了搜索按钮, 就忽略重复指令
    if (self.myTimerProgress) return;
    
    // ==================== [ 搜索 ] ==================== //
    [self performSelector:@selector(refreshTableViewAction:) withObject:self.refreshControl];
    
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scaning:) userInfo:nil repeats:YES];
    
}


- (void)notFound{
    
    // 如果已经连接了蓝牙设备, 就不再弹出警告
    if (self.iPhone.peripheral) return;
    
    [self pushAlertViewWithTitle:@"未发现蓝牙设备"
                      andMessage:@"请检查蓝牙灯电源是否打开"
                           andOk:@"好的"
                       andCancel:@""
                   andOkCallback:^{
                       
                   } andCancelCallback:^{
                       
                   }];
}


- (void)scaning:(id)sender{
    
    self.myTimerProgress += 1.0;

    // 调用模型方法, 搜索蓝牙列表
    self.smartLampList = [self.iPhone searchSmartLamp];
    [self.smartLampListTableView reloadData];
        
    
    if (self.smartLampList.count||self.myTimerProgress>4) {
        
        self.myTimerProgress = 0;
        [self.myTimer invalidate];
        [self.myTimer fire];
        
        
        if (!self.smartLampList.count) {
            [self notFound];
        }
        [self.iPhone stopScan];
        [self.refreshControl endRefreshing];
        
        
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新设备列表"];
        
    }
    
}



- (void)saveConnectedDevice:(NSString *)smartLampName{
    
    NSMutableArray *plist = [ATFileManager readFile:ATFileTypeDevice];
    if ([plist containsObject:smartLampName]) [plist removeObject:smartLampName];
    
    [plist addObject:smartLampName];
    [ATFileManager saveFile:ATFileTypeDevice withPlist:plist];
    NSLog(@"已记录%ld个设备",plist.count);
    
}

@end
