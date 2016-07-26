//
//  SceneTableViewCell.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-13.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "SceneTableViewCell.h"

@interface SceneTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *sceneImage;

@property (weak, nonatomic) IBOutlet UILabel *sceneTitle;
@property (weak, nonatomic) IBOutlet UILabel *sceneBright;
@property (weak, nonatomic) IBOutlet UILabel *sceneColor;
@property (weak, nonatomic) IBOutlet UILabel *sceneTimer;

@end

@implementation SceneTableViewCell

#pragma mark - 视图事件

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self _initUI];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


// 设置模型
- (void)setModel:(ATProfiles *)model{
    // 图片
    self.sceneImage.image = model.image;
    // 标题
    self.sceneTitle.text = model.title;
    // 亮度
    NSNumber *brightness = [NSNumber numberWithFloat:model.brightness];
    NSString *brightnessStr = [NSNumberFormatter localizedStringFromNumber:brightness numberStyle:NSNumberFormatterPercentStyle];
    self.sceneBright.text = [NSString stringWithFormat:@"亮度: %@",brightnessStr];
    // 颜色
    switch (model.colorAnimation) {
        case ColorAnimationNone: {
            self.sceneColor.text = @"单色模式";
            break;
        }
        case ColorAnimationSaltusStep3: {
            self.sceneColor.text = @"三色跳变";
            break;
        }
        case ColorAnimationSaltusStep7: {
            self.sceneColor.text = @"七色跳变";
            break;
        }
        case ColorAnimationGratation: {
            self.sceneColor.text = @"三色渐变";
            break;
        }
    }
    // 定时
    if (model.timer) {
        self.sceneTimer.text = [NSString stringWithFormat:@"%ld分钟后关灯",model.timer];
    } else{
        self.sceneTimer.text = @"";
    }
    
    
    
}


#pragma mark - 私有方法

// 初始化UI
- (void)_initUI{
    NSString *tmp = [NSString stringWithFormat:@"%d",arc4random()%8];
    self.sceneImage.image = [UIImage imageNamed:tmp];
    self.sceneImage.clipsToBounds = YES;
    
    self.backgroundColor = [UIColor clearColor];
    
}

@end
