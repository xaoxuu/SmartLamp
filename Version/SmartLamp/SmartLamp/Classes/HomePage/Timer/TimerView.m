//
//  TimerView.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-19.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "TimerView.h"

@interface TimerView () <UIPickerViewDataSource,UIPickerViewDelegate>
// 时间列表
@property (strong, nonatomic) NSArray *timeList;
// 时间选择器
@property (weak, nonatomic) IBOutlet UIPickerView *timerPicker;
// 提示文字
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
// 开关按钮
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
// 选中行
@property (assign, nonatomic) NSUInteger selectedRow;

@end

@implementation TimerView

#pragma mark - 视图事件
- (void)awakeFromNib{
    [self layoutIfNeeded];
    [self _initUI];
}




#pragma mark - 控件事件

- (IBAction)switchButtonTapped:(UISwitch *)sender {
    [self updateLabel];
    // 获取一列中选中的一行的索引, 赋值到属性中
    atCentralManager.currentProfiles.timer = 5 * self.selectedRow * self.switchButton.on;
    [atCentralManager letSmartLampPerformSleepMode];
    

}


#pragma mark - 私有方法

// 初始化UI
- (void)_initUI{
    self.selectedRow = atCentralManager.currentProfiles.timer / 5;
    
    [self.timerPicker selectRow:self.selectedRow inComponent:0 animated:YES];
    
    [self.switchButton setSelected:self.selectedRow];
    self.switchButton.tintColor = atColor.themeColor_light;
    self.switchButton.onTintColor = atColor.themeColor_light;
    self.switchButton.thumbTintColor = atColor.themeColor;
    self.switchButton.transform = CGAffineTransformMakeScale(0.7, 0.7);
    
    [self updateLabel];
    
}

// 更新标签文字
- (void)updateLabel{
    if (self.selectedRow && self.switchButton.on) {
        self.tipLabel.text = [NSString stringWithFormat:@"当前状态: %@后关闭",self.timeList[_selectedRow]];
    } else{
        self.tipLabel.text = @"不使用定时关灯";
    }
}

#pragma mark 懒加载
// 定时关灯的时间数组
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

#pragma mark - 数据源和代理

#pragma mark UIPickerView DataSource

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return self.timeList.count;
    
}

#pragma mark UIPickerView Delegate
// 每一行的数据 = 每一个父类对象的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    // 获取一列中每一行的数据, 显示到view
    return self.timeList[row];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    self.selectedRow = row;
    [self updateLabel];
    atCentralManager.currentProfiles.timer = 5 * row * self.switchButton.on;
    // 发送通知
    [atNotificationCenter postNotificationName:NOTI_BLE_STATUS object:NOTI_BLE_STATUS_CHANGE];
    
}


@end
