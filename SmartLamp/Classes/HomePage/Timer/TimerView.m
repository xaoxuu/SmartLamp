//
//  TimerView.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-19.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "TimerView.h"
#import "ATSwitch.h"
#import "ATTableViewCell.h"

@interface TimerView () <UITableViewDataSource,UITableViewDelegate>
// time list
@property (strong, nonatomic) NSArray *timeList;
// selected row
@property (assign, nonatomic) NSUInteger selectedRow;
// table view
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation TimerView

#pragma mark - view events

- (void)awakeFromNib{
    [self layoutIfNeeded];
    
    self.selectedRow = atCentral.aProfiles.timer / 5;
    
    [self setupTableView];
    
    [super awakeFromNib];
}

// setup table view
- (void)setupTableView{
    // init and add to superview
//    self.tableView = [[UITableView alloc] initWithFrame:self.contentView.frame style:UITableViewStylePlain];
//    [self.contentView addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // style
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 16)];
    self.tableView.rowHeight = 40;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 40)];
    
}


#pragma mark lazy load

// time list
-(NSArray *)timeList{
    
    if (!_timeList) {
        NSMutableArray *tempArr = [NSMutableArray array];
        [tempArr addObject:@"不启用定时关灯"];
        for (int i=1; i<=24; i++) {
            if (5*i<60) {
                NSString *timeStr = [NSString stringWithFormat:@"%d",5*i];
                [tempArr addObject:[timeStr stringByAppendingString:@"分钟"]];
            } else{
                NSString *timeStr = [NSString stringWithFormat:@"%d",5*i/60];
                NSString *tempStr1 = [timeStr stringByAppendingString:@"小时"];
                NSString *tempStr2 = @"";
                timeStr = [NSString stringWithFormat:@"%d",5*i%60];
                if (5*i%60) {
                    tempStr2 = [timeStr stringByAppendingString:@"分钟"];
                }
                [tempArr addObject:[tempStr1 stringByAppendingString:tempStr2]];
            }
        }
        _timeList = tempArr;
    }
    return _timeList;
    
}




#pragma mark - table view data source

// number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// number of rows in section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.timeList.count;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // dequeue reusable cell with reuse identifier
    ATTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        // Create new MDTableViewCell with default style, or you can subclass it.
        cell = [[ATTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"cell"];
        cell.rippleColor = atColor.lightGray.darkRatio(0.2);
        
    }
    
    // do something
    cell.textLabel.text = self.timeList[indexPath.row];
    if (indexPath.row == self.selectedRow) {
        cell.accessoryImageV.image = [UIImage imageNamed:@"icon_selected"];
    } else{
        cell.accessoryImageV.image = nil;
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
    self.selectedRow = indexPath.row;
    atCentral.aProfiles.timer = 5 * indexPath.row;
    [atCentral.didSendData sendNext:nil];
    [self.tableView reloadData];
}




@end
