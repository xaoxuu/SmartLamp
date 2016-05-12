//
//  ProfilesDetailsViewController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-05-10.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "ProfilesDetailsViewController.h"
#import "UITextField+ATText.h"
#import "HomeViewController.h"


@interface ProfilesDetailsViewController () <UIPickerViewDataSource,UIPickerViewDelegate>


@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@property (weak, nonatomic) IBOutlet UITextField *detailTextField;

@property (weak, nonatomic) IBOutlet UIButton *imageButton;

@property (weak, nonatomic) IBOutlet UIPickerView *timerPicker;

@property (weak, nonatomic) IBOutlet UISegmentedControl *colorSegmented;

@property (weak, nonatomic) IBOutlet UIView *sliderView;

@property (weak, nonatomic) IBOutlet UISlider *redSlider;

@property (weak, nonatomic) IBOutlet UISlider *greenSlider;

@property (weak, nonatomic) IBOutlet UISlider *blueSlider;

@property (weak, nonatomic) IBOutlet UISlider *brightnessSlider;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (strong, nonatomic) NSArray *timeList;

@end

@implementation ProfilesDetailsViewController

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

-(void)viewDidAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.titleTextField textFieldState:ATTextFieldStateEditEnd];
    [self.detailTextField textFieldState:ATTextFieldStateEditEnd];
    
}

#pragma mark - 控件事件 🍀🍀🍀🍀🍀🍀🍀🍀🍀🍀

// 按下了return键
- (IBAction)touchReturn:(UITextField *)sender {
    
    if (sender == self.titleTextField) {
        [self.titleTextField textFieldState:ATTextFieldStateEditEnd];
        [self.detailTextField textFieldState:ATTextFieldStateEditing];
        
    }else if (sender == self.detailTextField){
        [self.detailTextField textFieldState:ATTextFieldStateEditEnd];
    }
    
}

// 编辑结束
- (IBAction)editEnd:(UITextField *)sender {
    
    [sender textFieldState:ATTextFieldStateEditEnd];
    
}

// 编辑状态
- (IBAction)editing:(UITextField *)sender {
    
    [sender textFieldState:ATTextFieldStateEditing];
    
}

// 图片按钮
- (IBAction)imageButton:(UIButton *)sender {
    
    UIImage *image;
    
    // 这里用do-while为了防止两次出现同样的内容, 优化体验
    do {
        int index = arc4random()%5;
        NSString *imageName = [@"Lamp" stringByAppendingFormat:@"%d",index];
        image = [UIImage imageNamed:imageName];
    } while ([image isEqual:self.imageButton.currentBackgroundImage]);
    
    [self.imageButton setBackgroundImage:image forState:UIControlStateNormal];
    
}

// 色彩动画选项
- (IBAction)colorSegmented:(UISegmentedControl *)sender {
    
    self.aProfiles.colorAnimation = self.colorSegmented.selectedSegmentIndex;
    [self.iPhone letSmartLampPerformColorAnimation:self.aProfiles.colorAnimation];
    // 滑块是否可用
    [self setSliderEnable:!self.aProfiles.colorAnimation];
    
}

// 颜色和亮度滑块
- (IBAction)sliderRGB:(UISlider *)sender {
    
    [self updateSmartLampStatus];
    
}

// 保存按钮
- (IBAction)saveButton:(UIButton *)sender {
    
    [self saveCache];
    [self addToProfilesList];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}


#pragma mark - 私有方法 🚫🚫🚫🚫🚫🚫🚫🚫🚫🚫

// 初始化
- (void)initialization{
    
    [self.titleTextField  textFieldState:ATTextFieldStateEditEnd];
    [self.detailTextField textFieldState:ATTextFieldStateEditEnd];
    [self.saveButton      buttonState:ATButtonStateUp];
    
}

// 更新视图控件内容
- (void)updateFrame{
    
    // 标题
    self.titleTextField.text = self.aProfiles.title;
    // 描述
    self.detailTextField.text = self.aProfiles.detail;
    // 图片
    [self.imageButton setBackgroundImage:self.aProfiles.image forState:UIControlStateNormal];
    // 定时关灯
    [self.timerPicker selectRow:(0.2 * self.aProfiles.timer) inComponent:0 animated:YES];
    // 色彩动画
    self.colorSegmented.selectedSegmentIndex = self.aProfiles.colorAnimation;
    // 滑块
    [self.redSlider setValue:self.aProfiles.red animated:YES];
    [self.greenSlider setValue:self.aProfiles.green animated:YES];
    [self.blueSlider setValue:self.aProfiles.blue animated:YES];
    [self.brightnessSlider setValue:self.aProfiles.brightness animated:YES];
    
    // 滑块是否可用
    [self setSliderEnable:!self.aProfiles.colorAnimation];
    
}

// 更新蓝牙灯的颜色
- (void)updateSmartLampStatus{
    
    // 如果有动画, 就显示动画效果
    if (self.aProfiles.colorAnimation) {
        [self.iPhone letSmartLampPerformColorAnimation:self.aProfiles.colorAnimation];
    }
    // 否则就显示单色模式
    else{
        [self.iPhone letSmartLampSetColorWithR:self.redSlider.value G:self.greenSlider.value B:self.blueSlider.value andBright:self.brightnessSlider.value];
    }
    
}

// 控件可用
- (void)setSliderEnable:(BOOL)isEnable{
    
    self.redSlider.enabled = isEnable;
    self.greenSlider.enabled = isEnable;
    self.blueSlider.enabled = isEnable;
    self.brightnessSlider.enabled = isEnable;
    
}

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

// 保存当前配置到缓存文件
- (void)saveCache{
    
    // 标题
    self.aProfiles.title = [_titleTextField.text isEqualToString:@""]?@"情景模式":_titleTextField.text;
    
    // 图片
    self.aProfiles.image = self.imageButton.currentBackgroundImage;
    
    // 描述
    self.aProfiles.detail = [_detailTextField.text isEqualToString:@""]?@"没有描述信息":_detailTextField.text;
    
    // 定时picker
    // 渐变Segmented
    
    // RGB和亮度
    self.aProfiles.red = self.redSlider.value;
    self.aProfiles.green = self.greenSlider.value;
    self.aProfiles.blue = self.blueSlider.value;
    self.aProfiles.brightness = self.brightnessSlider.value;
    
    
    [ATFileManager saveCache:self.aProfiles];
    
}

// 将当前配置添加到列表中并保存
- (void)addToProfilesList{
    
    // 从本地读取
    self.profilesList = [ATFileManager readFile:ATFileTypeProfilesList];
    
    // 如果有重名的, 就覆盖
    for (ATProfiles *local in self.profilesList) {
        if ([local.title isEqualToString:self.aProfiles.title]) {
            [self.profilesList removeObject:local];
        }
    }
    // 将当前配置添加到列表中
    [self.profilesList addObject:self.aProfiles];
    // 保存
    [ATFileManager saveFile:ATFileTypeProfilesList withPlist:self.profilesList];
    
}


#pragma mark - 代理方法 🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵

#pragma mark 🔵 UIPickerView DataSource

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return self.timeList.count;
    
}

#pragma mark 🔵 UIPickerView Delegate
// 每一行的数据 = 每一个父类对象的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    // 获取一列中每一行的数据, 显示到view
    return self.timeList[row];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    // 获取一列中选中的一行的索引, 赋值到属性中
    self.aProfiles.timer = 5 * row;
    
}


@end
