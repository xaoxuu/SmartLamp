//
//  SceneViewController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-13.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

// support file
#import "SceneViewController.h"
#import "ATManager+View.h"
#import "ATManager+Navigation.h"
#import "ATManager+TableView.h"
#import "MJRefresh.h"
// child
#import "SceneCollectionView.h"

@interface SceneViewController ()

// SceneCollectionView
@property (strong, nonatomic) SceneCollectionView *collectionView;
// selected row
@property (assign, nonatomic) NSUInteger selectedRow;

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
    // setup
    
    // setup navigation bar
    [self setupNavigationBar];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    [self.tableView setEditing:NO animated:YES];
    [self.collectionView saveData];
    
}

#pragma mark - private methods


// reload data
- (void)reloadData{
    
//    [self.tableView reloadData];
//    [self.tableView.mj_header endRefreshing];
    
}



#pragma mark initialization methods

// init UI
- (void)_initUI{
    self.collectionView = [[NSBundle mainBundle] loadNibNamed:@"SceneCollectionView" owner:nil options:nil][0];
    
    [self.view addSubview:self.collectionView];
}

// subscribeRAC
- (void)subscribeRAC{
    [self.didSelected subscribeNext:^(id x) {
//        [self.tableView.mj_header beginRefreshing];
    }];
}

// setup navigation bar
- (void)setupNavigationBar{
    
    
    
    self.atNavigationView = [ATNavigationView viewWithBarTintColor:atColor.theme height:64 title:@"情景模式"];
    [self.view addSubview:self.atNavigationView];
    
    [self.atNavigationView at_rightButtonWithImage:@"scene_add" action:^{
        [self.collectionView addItem];
    }];
    
    
}


@end
