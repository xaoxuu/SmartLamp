//
//  HomeViewController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-04-21.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()


@property (weak, nonatomic) IBOutlet UIButton *lampLogo;

@property (strong, nonatomic) IBOutlet UIView *backgroundView;


@property (weak, nonatomic) IBOutlet UISlider *brightnessSlider;

@property (weak, nonatomic) IBOutlet UISlider *redSlider;

@property (weak, nonatomic) IBOutlet UISlider *greenSlider;

@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UIButton *bluetoothButton;

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
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
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
    float a = _brightnessSlider.value * 0.7 + 0.3;
    float r = _redSlider.value;
    float g = _greenSlider.value;
    float b = _blueSlider.value;
    _backgroundView.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:a];
    
    _lampLogo.tintColor = [UIColor colorWithRed:r green:g blue:b alpha:a];
}

@end
