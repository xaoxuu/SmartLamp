//
//  SceneCollectionViewCell.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-26.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "SceneCollectionViewCell.h"
#import "ATMDButton.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>



@interface SceneCollectionViewCell () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) UIView *infoView;

// image
@property (weak, nonatomic) UIImageView *sceneIcon;
// title
@property (weak, nonatomic) YYLabel *sceneTitle;

@property (weak, nonatomic) YYLabel *sceneDetail;

@property (weak, nonatomic) ATMDButton *deleteButton;


@property (strong, nonatomic) UIImageView *sceneImage;

@property (weak, nonatomic) ATMDButton *changeImageButton;

@property (weak, nonatomic) ATMDButton *applyButton;

// image picker
@property (strong, nonatomic) UIImagePickerController *picker;

@end

@implementation SceneCollectionViewCell

+ (instancetype)reusableCellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"SceneCollectionViewCell";
    [collectionView registerClass:[SceneCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    SceneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialization];
    }
    return self;
}

- (void)_initialization {
    // Initialization code
    
    // scene image
    UIImageView *sceneImage = [[UIImageView alloc] initWithFrame:self.bounds];
    [self.contentView addSubview:sceneImage];
    self.sceneImage = sceneImage;
    sceneImage.contentMode = UIViewContentModeScaleAspectFill;
    sceneImage.image = [UIImage imageNamed:@"image_launch"];
    sceneImage.userInteractionEnabled = YES;
    sceneImage.clipsToBounds = YES;
    [sceneImage at_addTapGestureHandler:^(UITapGestureRecognizer * _Nonnull sender) {
        atCentral.letSmartLampApplyProfiles(_model);
        self.applyButton.selected = !self.applyButton.selected;
    }];
    // info view
    UIView *infoView = [[UIView alloc] init];
    [self.contentView addSubview:infoView];
    self.infoView = infoView;
    infoView.width = self.width;
    infoView.height = 48;
    infoView.left = 0;
    infoView.bottom = self.contentView.height;
    infoView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    // scene icon
    UIImageView *sceneIcon = [[UIImageView alloc] initWithFrame:CGRectMake(sMargin, sMargin, sSmallIconWH, sSmallIconWH)];
    [infoView addSubview:sceneIcon];
    self.sceneIcon = sceneIcon;
    self.sceneIcon.layer.at_maskToCircle();
    self.sceneIcon.layer.at_whiteBorder(1);
    // scene title
    YYLabel *sceneTitle = [[YYLabel alloc] init];
    [infoView addSubview:sceneTitle];
    self.sceneTitle = sceneTitle;
    sceneTitle.textColor = atColor.white;
    sceneTitle.font = [UIFont systemFontOfSize:14];
    sceneTitle.text = @"情景模式";
    sceneTitle.top = sceneIcon.top;
    sceneTitle.left = CGRectGetMaxX(sceneIcon.frame) + sMargin;
    sceneTitle.width = infoView.width - sceneTitle.left - sMargin;
    sceneTitle.height = HeightWithTextFontMaxWidth(@"情景模式", [UIFont systemFontOfSize:14], sceneTitle.width);
    // scene detail
    YYLabel *sceneDetail = [[YYLabel alloc] init];
    [infoView addSubview:sceneDetail];
    self.sceneDetail = sceneDetail;
    sceneDetail.textColor = atColor.white;
    sceneDetail.font = [UIFont systemFontOfSize:12];
    sceneDetail.text = @"情景模式详情";
    sceneDetail.left = sceneTitle.left;
    sceneDetail.width = sceneTitle.width;
    sceneDetail.height = HeightWithTextFontMaxWidth(@"情景模式详情", [UIFont systemFontOfSize:12], sceneDetail.width);
    sceneDetail.bottom = sceneIcon.bottom;
    // del button
    ATMDButton *deleteButton = [[ATMDButton alloc] initWithFrame:sceneIcon.frame];
    [infoView addSubview:deleteButton];
    self.deleteButton = deleteButton;
    [deleteButton setImage:[UIImage imageNamed:@"icon_edit"] forState:UIControlStateNormal];
    deleteButton.layer.at_maskToCircle();
    [deleteButton at_addTouchUpInsideHandler:^(UIButton * _Nonnull sender) {
        [self _showPicker];
    }];
    // apply button
    ATMDButton *applyButton = [[ATMDButton alloc] initWithFrame:sceneIcon.frame];
    [infoView addSubview:applyButton];
    self.applyButton = applyButton;
    [applyButton setImage:[UIImage imageNamed:@"icon_apply"] forState:UIControlStateNormal];
    applyButton.layer.at_maskToCircle();
    [applyButton at_addTouchUpInsideHandler:^(UIButton * _Nonnull sender) {
        atCentral.letSmartLampApplyProfiles(_model);
        self.applyButton.selected = !self.applyButton.selected;
    }];
    [self.applyButton setBackgroundImage:[UIImage at_imageWithColor:atColor.theme size:self.applyButton.frame.size alpha:1] forState:UIControlStateSelected];
    // adjust
    applyButton.right = infoView.width - sMargin;
    deleteButton.right = applyButton.left - sMargin;
    
    
}


- (void)setModel:(ATProfiles *)model{
    _model = model;
    self.sceneIcon.image = model.icon;
    self.sceneImage.image = model.image;
    self.sceneTitle.text = model.title;
    self.applyButton.selected = [model isEqual:atCentral.aProfiles];
    
    // detail
    NSString *color;
    switch (model.colorMode) {
        case ATColorModeNone: {
            color = @"单色模式";
            break;
        }
        case ATColorModeSaltusStep3: {
            color = @"三色跳变";
            break;
        }
        case ATColorModeSaltusStep7: {
            color = @"七色跳变";
            break;
        }
        case ATColorModeGratation: {
            color = @"三色渐变";
            break;
        }
    }
    self.sceneDetail.text = color;
    if (model.colorMode == ATColorModeNone) {
        // update scene brightness label
        NSNumber *brightness = [NSNumber numberWithFloat:model.brightness];
        NSString *brightnessStr = [NSNumberFormatter localizedStringFromNumber:brightness numberStyle:NSNumberFormatterPercentStyle];
        NSString *brightStr = [NSString stringWithFormat:@", %@亮度",brightnessStr];
        self.sceneDetail.text = [self.sceneDetail.text stringByAppendingString:brightStr];
    }
    NSString *timer;
    if (model.timer) {
        timer = [NSString stringWithFormat:@", %ld分钟后关灯",model.timer];
    } else{
        timer = @"";
    }
    self.sceneDetail.text = [self.sceneDetail.text stringByAppendingString:timer];
    
    
}



#pragma mark - private methods


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self.picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.sceneImage.image = image;
    self.model.image = image;
    [self layoutIfNeeded];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.picker dismissViewControllerAnimated:YES completion:nil];
    [self removeFromSuperview];
}


- (void)_showPicker{
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.picker.mediaTypes = @[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie];
    self.picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.controller presentViewController:self.picker animated:YES completion:nil];
    
}

- (UIImagePickerController *)picker{
    if (!_picker) {
        // create it
        _picker = [[UIImagePickerController alloc]init];
        // do something...
        _picker.view.backgroundColor = atColor.theme;
        _picker.delegate = self;
        _picker.allowsEditing = YES;
        
    }
    return _picker;
}


@end
