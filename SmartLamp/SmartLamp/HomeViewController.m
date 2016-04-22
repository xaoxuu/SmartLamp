//
//  HomeViewController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-04-21.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "HomeViewController.h"
#import "BLEUtil.h"

@interface HomeViewController ()


@property (weak, nonatomic) IBOutlet UIButton *lampLogo;

@property (strong, nonatomic) IBOutlet UIView *backgroundView;


@property (weak, nonatomic) IBOutlet UISlider *brightnessSlider;

@property (weak, nonatomic) IBOutlet UISlider *redSlider;

@property (weak, nonatomic) IBOutlet UISlider *greenSlider;

@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UIButton *bluetoothButton;
@property (weak, nonatomic) IBOutlet UIView *tabBarBackground;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prefersStatusBarHidden];

}
- (BOOL)prefersStatusBarHidden{
    
    return YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [_bluetoothButton shadowLayer:ATWidgetAnimationButtonUp];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)brightnessSlider:(UISlider *)sender {
    
    [self refreshRGBValue];
    
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
- (IBAction)touchDown:(UIButton *)sender {

    [sender shadowLayer:ATWidgetAnimationButtonDown];
}



- (IBAction)touchUp:(UIButton *)sender {

    [sender shadowLayer:ATWidgetAnimationButtonUp];
    
}


#pragma mark - 私有方法 🚫🚫🚫🚫🚫🚫🚫🚫🚫🚫

- (void)refreshRGBValue{
    float alpha = _brightnessSlider.value;
    float red = _redSlider.value;
    float green = _greenSlider.value;
    float blue = _blueSlider.value;
    
    UIColor *trueColor = [UIColor colorWithRed:red
                                         green:green
                                          blue:blue
                                         alpha:alpha];
    
    UIColor *buttonStyle = [UIColor colorWithRed:0.5 * red   + 0.3
                                           green:0.5 * green + 0.3
                                            blue:0.5 * blue  + 0.3
                                           alpha:0.7 * alpha + 0.3];
    

    
    // 背景颜色
    _backgroundView.backgroundColor = trueColor;
    // 蓝牙按钮的颜色
    
    _bluetoothButton.backgroundColor = buttonStyle;
    
    // 灯的颜色
//    _lampLogo.tintColor = darkStyle;
    
    // 刷新Slider的颜色
    _brightnessSlider.minimumTrackTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:alpha];
    _redSlider.minimumTrackTintColor = [UIColor colorWithRed:1 green:1-red blue:1-red alpha:alpha];
    _greenSlider.minimumTrackTintColor = [UIColor colorWithRed:1-green green:1 blue:1-green alpha:alpha];
    _blueSlider.minimumTrackTintColor = [UIColor colorWithRed:1-blue green:1-blue blue:1 alpha:alpha];
    
    
    // 给蓝牙设备发送指令
    
    [kBLEUtil ble07_red:(int)red blue:(int)blue green:(int)green];
    
}



@end
