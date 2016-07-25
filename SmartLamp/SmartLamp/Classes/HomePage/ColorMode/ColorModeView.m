//
//  ColorModeView.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-19.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ColorModeView.h"
#import "UIImageView+GetColorAtPixel.h"
#import "ATMaterialButton.h"

@interface ColorModeView ()

// 中心设备, 单例
@property (strong, nonatomic) ATCentralManager *centralManager;

@property (weak, nonatomic) IBOutlet UIImageView *palette;

@property (weak, nonatomic) IBOutlet UIView *paletteView;

@property (weak, nonatomic) UIPanGestureRecognizer *pan;

@property (weak, nonatomic) UITapGestureRecognizer *tap;


// 圆环
@property (strong, nonatomic) UIImageView *circle;

@property (weak, nonatomic) IBOutlet UIView *colorAnimationBtnView;

@end

@implementation ColorModeView

#pragma mark - 视图事件

- (void)awakeFromNib{
    [self layoutIfNeeded];
    
    // 初始化UI
    [self _initUI];
    // 设置手势
    [self _setupGestureRecognizer];
    
}

// 滑动手势
- (void)pan:(UIPanGestureRecognizer *)sender {
    [self deSelectAnimationButton];
    CGPoint point = [sender locationInView:self.palette];
    //set background color of view
    // 设置视图背景颜色
    [self getColorAtPoint:point completion:^(UIColor *color) {
        // 更新颜色
        atCentralManager.currentProfiles.color = color;
        // 更新蓝牙灯状态
        [atCentralManager letSmartLampUpdateColor];
        // 更新圆环位置
        [self updateCircleWithPoint:point];
        
    }];
}

// 点击手势
- (void)tap:(UITapGestureRecognizer *)sender {
    [self deSelectAnimationButton];
    CGPoint point = [sender locationInView:self.palette];
    //set background color of view
    // 设置视图背景颜色
    [self getColorAtPoint:point completion:^(UIColor *color) {
        // 更新颜色
        atCentralManager.currentProfiles.color = color;
        // 更新蓝牙灯状态
        [atCentralManager letSmartLampUpdateColor];
        // 更新圆环位置
        [self updateCircleWithPoint:point];
        
    }];
}

#pragma mark - 控件事件

// 点击了动画按钮
- (IBAction)animationBtn:(ATMaterialButton *)sender {
    atCentralManager.currentProfiles.colorAnimation = sender.tag;
    [atCentralManager letSmartLampPerformColorAnimation];
}



#pragma mark - 私有方法

// 初始化UI
- (void)_initUI{
    self.palette.layer.shadowOffset = CGSizeMake(0, 0);
    self.palette.layer.shadowRadius = 2;
    self.palette.layer.shadowOpacity = 0.5;
}
// 设置手势
- (void)_setupGestureRecognizer{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    self.tap = tap;
    [self.paletteView addGestureRecognizer:self.tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    self.pan = pan;
    [self.paletteView addGestureRecognizer:self.pan];
    
    
    
}

// Access to the specified pixel color, and perform operations
// 获取指定像素点的颜色, 并执行操作
- (void)getColorAtPoint:(CGPoint)point completion:(void(^)(UIColor *color))completion{
    
    CGFloat x = point.x - 0.5*self.palette.frame.size.width - 1;
    CGFloat y = point.y - 0.5*self.palette.frame.size.height - 1;
    CGFloat r = 0.5 * (self.palette.frame.size.width - 5);
    
    // When the touch point is inside palette coordinates.
    // 当触摸点在取色板内部时调用
    if (powf(x,2) + powf(y, 2) < powf(r, 2)) {
        completion([self.palette at_getColorAtPixel:point]);
        atCentralManager.currentProfiles.colorAnimation = ColorAnimationNone;
    }
    
}

// 更新圆环的位置
- (void)updateCircleWithPoint:(CGPoint)point{
    
    [self.circle removeFromSuperview];
    CGSize size = self.circle.frame.size;
    point.x -= size.width * 0.5;
    point.y -= size.height * 0.5;
    self.circle.frame = (CGRect){point,size};
    
    [self.palette addSubview:self.circle];
    
}

// 取消选中动画按钮
- (void)deSelectAnimationButton{
    for (ATMaterialButton *btn in self.colorAnimationBtnView.subviews) {
        btn.selected = NO;
    }
}

#pragma mark 懒加载

-(UIImageView *)circle{
    
    if (!_circle) {
        self.circle = [[UIImageView alloc] initWithFrame:(CGRect){0,0,20,20}];
        self.circle.image = [UIImage imageNamed:@"Icon_Circle"];
        [self.circle setUserInteractionEnabled:NO];
    }
    
    return _circle;
    
}

@end
