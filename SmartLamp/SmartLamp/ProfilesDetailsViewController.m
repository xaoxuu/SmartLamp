//
//  ProfilesDetailsViewController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-05-10.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "ProfilesDetailsViewController.h"
#import "UITextField+ATText.h"

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



@property (strong, nonatomic) NSArray *timerList;



@end

@implementation ProfilesDetailsViewController

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
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.titleTextField textFieldState:ATTextFieldStateEditEnd];
    [self.detailTextField textFieldState:ATTextFieldStateEditEnd];
    
}


- (IBAction)touchReturn:(UITextField *)sender {
    
    if (sender == self.titleTextField) {
        [self.titleTextField textFieldState:ATTextFieldStateEditEnd];
        [self.detailTextField textFieldState:ATTextFieldStateEditing];
        
    }else if (sender == self.detailTextField){
        [self.detailTextField textFieldState:ATTextFieldStateEditEnd];
    }
    
}



- (IBAction)editEnd:(UITextField *)sender {
    
    [sender textFieldState:ATTextFieldStateEditEnd];
    
}

- (IBAction)editing:(UITextField *)sender {
    
    [sender textFieldState:ATTextFieldStateEditing];
    
}






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

- (IBAction)touchUp:(id)sender {
    
    if ([sender isKindOfClass:[UITextField class]]) {
        [sender textFieldState:ATTextFieldStateEditEnd];
    }else if ([sender isKindOfClass:[UIButton class]]){
        
        [sender buttonState:ATButtonStateUp];
        
    }
    
    
}

- (IBAction)touchDown:(id)sender {
    
    if ([sender isKindOfClass:[UITextField class]]) {
        [sender textFieldState:ATTextFieldStateEditing];
    }else if ([sender isKindOfClass:[UIButton class]]){
        
        [sender buttonState:ATButtonStateDown];
        
    }
    
}


- (IBAction)colorSegmented:(UISegmentedControl *)sender {
    
    self.aProfiles.colorAnimation = self.colorSegmented.selectedSegmentIndex;
    [self.iPhone letSmartLampPerformColorAnimation:self.aProfiles.colorAnimation];
    
}





- (IBAction)redSlider:(UISlider *)sender {
    
    [self refreshRGBValue];
    
}




- (IBAction)greenSlider:(UISlider *)sender {
    
    [self refreshRGBValue];
    
}



- (IBAction)blueSlider:(UISlider *)sender {
    
    [self refreshRGBValue];
    
}

- (IBAction)brightnessSlider:(UISlider *)sender {
    
    [self refreshRGBValue];
    
}


- (IBAction)saveButton:(UIButton *)sender {
    
    [self saveCache];
    [self addToProfilesList];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}




#pragma mark - 私有方法 🚫🚫🚫🚫🚫🚫🚫🚫🚫🚫


- (void)initialization{
    
    [self.titleTextField textFieldState:ATTextFieldStateEditEnd];
    [self.detailTextField textFieldState:ATTextFieldStateEditEnd];
    [self.saveButton buttonState:ATButtonStateUp];
    
    
}

- (void)updateFrame{
    
    
    self.titleTextField.text = self.aProfiles.title;
    self.detailTextField.text = self.aProfiles.detail;
    [self.imageButton setBackgroundImage:self.aProfiles.image forState:UIControlStateNormal];
    [self.timerPicker selectRow:(0.2 * self.aProfiles.timer) inComponent:0 animated:YES];
    
    self.colorSegmented.selectedSegmentIndex = self.aProfiles.colorAnimation;
    
    [self.redSlider setValue:self.aProfiles.red animated:YES];
    [self.greenSlider setValue:self.aProfiles.green animated:YES];
    [self.blueSlider setValue:self.aProfiles.blue animated:YES];
    [self.brightnessSlider setValue:self.aProfiles.brightness animated:YES];

    
    
}


-(NSArray *)timerList{
    
    if (!_timerList) {
        
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
        _timerList = tempArr;

    }
    return _timerList;
    
}


- (void)refreshRGBValue{
    
    float alpha = _brightnessSlider.value;
    float red = _redSlider.value;
    float green = _greenSlider.value;
    float blue = _blueSlider.value;
    
    // 刷新Slider的颜色
    _brightnessSlider.minimumTrackTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:alpha];
    _redSlider.minimumTrackTintColor = [UIColor colorWithRed:1 green:1-red blue:1-red alpha:alpha];
    _greenSlider.minimumTrackTintColor = [UIColor colorWithRed:1-green green:1 blue:1-green alpha:alpha];
    _blueSlider.minimumTrackTintColor = [UIColor colorWithRed:1-blue green:1-blue blue:1 alpha:alpha];
    
    
    // 给蓝牙设备发送指令
    
    [self.iPhone letSmartLampSetColorWithR:red G:green B:blue andBright:alpha];
    
    
}



- (void)saveCache{
    
    // 标题
    self.aProfiles.title = [_titleTextField.text isEqualToString:@""]?@"情景模式":_titleTextField.text;
    
    // 图片
    self.aProfiles.image = self.imageButton.currentBackgroundImage;
    
    // 描述
    self.aProfiles.detail = [_detailTextField.text isEqualToString:@""]?@"没有描述信息":_detailTextField.text;
    
    // 定时
    // 渐变
    
    // RGB和亮度
    self.aProfiles.red = self.redSlider.value;
    self.aProfiles.green = self.greenSlider.value;
    self.aProfiles.blue = self.blueSlider.value;
    self.aProfiles.brightness = self.brightnessSlider.value;
    
    
    [ATFileManager saveCache:self.aProfiles];
    
}

- (void)addToProfilesList{
    
    self.profilesList = [ATFileManager readFile:ATFileTypeProfilesList];
    
    for (ATProfiles *local in self.profilesList) {
        if ([local.title isEqualToString:self.aProfiles.title]) {
            [self.profilesList removeObject:local];
        }
    }
    [self.profilesList addObject:self.aProfiles];
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
    
    return self.timerList.count;
    
}

#pragma mark 🔵 UIPickerView Delegate
// 每一行的数据 = 每一个父类对象的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    // 获取一列中每一行的数据, 显示到view
    return self.timerList[row];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    // 获取一列中选中的一行的索引, 赋值到属性中
    self.aProfiles.timer = 5 * row;
    
}


@end
