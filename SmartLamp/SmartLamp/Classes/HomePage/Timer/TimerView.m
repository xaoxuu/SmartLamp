//
//  TimerView.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-19.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "TimerView.h"
#import "ATSwitch.h"

@interface TimerView () <UIPickerViewDataSource,UIPickerViewDelegate>
// time list
@property (strong, nonatomic) NSArray *timeList;
// time picker
@property (weak, nonatomic) IBOutlet UIPickerView *timerPicker;
// tip label
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
// switch
@property (weak, nonatomic) IBOutlet ATSwitch *switchButton;
// selected row
@property (assign, nonatomic) NSUInteger selectedRow;

@end

@implementation TimerView

#pragma mark - view events

- (void)awakeFromNib{
    [self layoutIfNeeded];
    // init UI
    [self _initUI];
    // handle switch events
    [self handleSwitchEvents];
}

// handle switch events
- (void)handleSwitchEvents{
    [[self.switchButton rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISwitch *sender) {
        // do something
        [self updateLabel];
        // get selected row
        atCentralManager.currentProfiles.timer = 5 * self.selectedRow * self.switchButton.on;
        [atCentralManager letSmartLampPerformSleepMode];
        [atCentralManager.didSendData sendNext:nil];
    }];
}


// init UI
- (void)_initUI{
    // selected row
    self.selectedRow = atCentralManager.currentProfiles.timer / 5;
    // picker
    [self.timerPicker selectRow:self.selectedRow inComponent:0 animated:YES];
    // switch
    [self.switchButton at_themeColorStyle];
    [self.switchButton setSelected:self.selectedRow];
    // label
    [self updateLabel];
    
}

// update label
- (void)updateLabel{
    if (self.selectedRow && self.switchButton.on) {
        self.tipLabel.text = [NSString stringWithFormat:@"当前状态: %@后关闭",self.timeList[_selectedRow]];
    } else{
        self.tipLabel.text = @"不使用定时关灯";
    }
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


#pragma mark - picker view data source

// number of components in picker view
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// number of rows in component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.timeList.count;
}


#pragma mark picker view delegate

// title for row
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    // get data from model list
    return self.timeList[row];
}

// did select row
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    // do something
    self.selectedRow = row;
    [self updateLabel];
    atCentralManager.currentProfiles.timer = 5 * row * self.switchButton.on;
    [atCentralManager.didSendData sendNext:nil];
}


@end
