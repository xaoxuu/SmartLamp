//
//  SceneTableViewCell.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-07-13.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "SceneTableViewCell.h"

@interface SceneTableViewCell ()

// image
@property (weak, nonatomic) IBOutlet UIImageView *sceneImage;
// title
@property (weak, nonatomic) IBOutlet UILabel *sceneTitle;
// brightness
@property (weak, nonatomic) IBOutlet UILabel *sceneBright;
// color
@property (weak, nonatomic) IBOutlet UILabel *sceneColor;
// timer
@property (weak, nonatomic) IBOutlet UILabel *sceneTimer;

@end

@implementation SceneTableViewCell


#pragma mark - view events

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

- (void)prepareForReuse{
    [super prepareForReuse];
    self.alpha = 0.3f;
    self.transform = CGAffineTransformMakeScale(1.18f, 1.18f);
    [UIView animateWithDuration:0.5f delay:0.0f usingSpringWithDamping:1.0f initialSpringVelocity:0.1f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1;
    } completion:^(BOOL finished) {
        self.transform = CGAffineTransformIdentity;
    }];
    
}


#pragma mark - private methods

// init UI
- (void)_initUI{
    NSString *tmp = [NSString stringWithFormat:@"%d",arc4random()%8];
    self.sceneImage.image = [UIImage imageNamed:tmp];
    self.sceneImage.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
}

// set model
- (void)setModel:(ATProfiles *)model{
    // image
    self.sceneImage.image = model.image;
    // title
    self.sceneTitle.text = model.title;
    // brightness
    NSNumber *brightness = [NSNumber numberWithFloat:model.brightness];
    NSString *brightnessStr = [NSNumberFormatter localizedStringFromNumber:brightness numberStyle:NSNumberFormatterPercentStyle];
    self.sceneBright.text = [NSString stringWithFormat:@"亮度: %@",brightnessStr];
    // color
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
    // timer
    if (model.timer) {
        self.sceneTimer.text = [NSString stringWithFormat:@"%ld分钟后关灯",model.timer];
    } else{
        self.sceneTimer.text = @"";
    }
    
}


@end
