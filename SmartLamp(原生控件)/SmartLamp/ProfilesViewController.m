//
//  ProfilesViewController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-04-21.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "ProfilesViewController.h"
#import "ATProfiles.h"


@interface ProfilesViewController () <UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *profilesListTableView;

@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (weak, nonatomic) IBOutlet UIButton *addButton;


@end

@implementation ProfilesViewController

#pragma mark - 视图事件 🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialization];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    // 更新视图控件内容
    [self updateFrame];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    if (self.profilesListTableView.editing) {
        [self.profilesListTableView setEditing:NO animated:YES];
    }
    
}

#pragma mark - 控件事件 🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀

// 编辑按钮
- (IBAction)editButton:(UIButton *)sender {
    
    if (self.profilesListTableView.editing) {
        
        [self.profilesListTableView setEditing:NO animated:YES];
        
    }else{
        
        [self.profilesListTableView setEditing:YES animated:YES];
        
    }
    
}


#pragma mark - 私有方法 🚫🚫🚫🚫🚫🚫🚫🚫🚫🚫

// 初始化
- (void)initialization{
    
    [self.editButton buttonState:ATButtonStateUp];
    [self.addButton  buttonState:ATButtonStateUp];
    
}

// 更新视图控件内容
- (void)updateFrame{
    
    self.profilesList = nil;
    self.profilesList = [ATFileManager readFile:ATFileTypeProfilesList];
    [self.profilesListTableView reloadData];
    
}

// 保存用户配置列表
- (void)saveProfilesList{
    
    [ATFileManager saveFile:ATFileTypeProfilesList withPlist:self.profilesList];
    
}


#pragma mark - 数据源和代理 🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵

#pragma mark 🔵 UITableView DataSource

// 每一组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.profilesList.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    /*======================[ 1.创建可重用的cell ]======================*/
    static NSString *reuseId = @"profilesList";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
        
        /*🖥*/NSLog(@"新建了一个cell");
        
    }
    
    /*======================[ 2.给cell内子控件赋值 ]======================*/
    // 实例化
    ATProfiles *aProfiles = self.profilesList[indexPath.row];
    
    // 给控件赋值
    cell.textLabel.text = aProfiles.title;
    cell.imageView.image = aProfiles.image;
    cell.detailTextLabel.text = aProfiles.detail;
    
    /*======================[ 3.返回cell ]======================*/
    return cell;
    
}

// 删除某一行
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        /*======================[ 1.删除的方法 ]======================*/
        // 2.从这个组中移除指定对象
        [self.profilesList removeObjectAtIndex:indexPath.row];
        // 3.将删除后的文件覆盖本地文件
        [self saveProfilesList];
        
        
        /*======================[ 2.删除的动画 ]======================*/
        [self.profilesListTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
    }
    
}

// 移动某一行到某一行
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    
    /*======================[ 1.将源从数组中取出 ]======================*/
    id source = self.profilesList[sourceIndexPath.row];
    
    /*======================[ 2.将源从数组中删除 ]======================*/
    [self.profilesList removeObjectAtIndex:sourceIndexPath.row];
    
    /*======================[ 3.将源插入指定位置 ]======================*/
    [self.profilesList insertObject:source atIndex:destinationIndexPath.row];
    
    /*======================[ 4.将修改后的配置覆盖到本地 ]======================*/
    [self saveProfilesList];
    
}

#pragma mark 🔵 UITableView Delegate

// 选中某一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    // ==================== [ 实例化选中的对象 ] ==================== //
    ATProfiles *selectedProfiles = self.profilesList[indexPath.row];
    
    [self pushAlertViewWithTitle:@"应用情景模式"
                      andMessage:[NSString stringWithFormat:@"是否应用情景模式\"%@\"?",selectedProfiles.title]
                           andOk:@"应用"
                       andCancel:@"取消"
                   andOkCallback:^{
                       
                       // 应用选中的配置
                       self.aProfiles = selectedProfiles;
                       [ATFileManager saveCache:self.aProfiles];
                       // 切换视图
                       [self.tabBarController setSelectedIndex:0];
                       
                       NSLog(@"应用了\"%@\"",selectedProfiles.title);
                   } andCancelCallback:^{
                       NSLog(@"点击了取消");
                   }];
    
}



@end
