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

@property (weak, nonatomic) IBOutlet UITableView *profilesTableView;




@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (weak, nonatomic) IBOutlet UIButton *addButton;


@end

@implementation ProfilesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialization];
    [self updateFrame];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    [self updateFrame];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    if (self.profilesTableView.editing) {
        [self.profilesTableView setEditing:NO animated:YES];
    }
    
    
}

// 页面消失之后, 把情景模式配置数据存储到本地
-(void)viewDidDisappear:(BOOL)animated{
    
    
    
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/






- (IBAction)editButton:(UIButton *)sender {
    
    if (self.profilesTableView.editing) {
        
        [self.profilesTableView setEditing:NO animated:YES];
        
    }else{
        
        [self.profilesTableView setEditing:YES animated:YES];
        
        
    }
    
}






// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)


#pragma mark - 私有方法 🚫🚫🚫🚫🚫🚫🚫🚫🚫🚫

- (void)initialization{
    
    [self.editButton     buttonState:ATButtonStateUp];
    [self.addButton buttonState:ATButtonStateUp];
    
    
}


- (void)updateFrame{
    
    self.profilesList = nil;
    self.profilesList = [ATFileManager readFile:ATFileTypeProfilesList];
    [self.profilesTableView reloadData];
    [self.profilesTableView reloadSectionIndexTitles];
    
}

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
        [self.profilesTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
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
                       
                       [self.tabBarController setSelectedIndex:0];
                       
                       NSLog(@"点击了应用");
                   } andCancelCallback:^{
                       NSLog(@"点击了取消");
                   }];

}








@end
