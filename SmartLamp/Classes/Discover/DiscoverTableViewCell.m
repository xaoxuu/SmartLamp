//
//  DiscoverTableViewCell.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-02.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "DiscoverTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "YYPhotoGroupView.h"

@interface DiscoverTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *cell_userImage;

@property (weak, nonatomic) IBOutlet UILabel *cell_nickname;

@property (weak, nonatomic) IBOutlet UILabel *cell_time;

@property (weak, nonatomic) IBOutlet UILabel *cell_contentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *cell_contentImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellImageHeight;

@end
@implementation DiscoverTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.layer.at_shadow(ATShadowCenterLight);
    [self.cell_contentImage at_addTapGestureHandler:^(UITapGestureRecognizer * _Nonnull sender) {
        [self showPhotoBrowser];
    }];
    
    
}

- (void)setModel:(List *)model{
    _model = model;
    
    _cell_userImage.layer.cornerRadius = 0.5 * _cell_userImage.width;
    [_cell_userImage sd_setImageWithURL:[NSURL URLWithString:model.profile_image]];
    
    _cell_nickname.text = model.name;
    _cell_time.text = model.create_time;
    _cell_contentLabel.text = model.text;
    
    if (model.image0.length) {
        [_cell_contentImage sd_setImageWithURL:[NSURL URLWithString:model.image0]];
        CGFloat modelW = [model.width doubleValue];
        CGFloat modelH = [model.height doubleValue];
        CGFloat cellH = modelH * self.width / modelW;
        _cellImageHeight.constant = fmin(cellH, 320);
        
    } else{
        _cell_contentImage = nil;
        _cellImageHeight.constant = 0;
    }
    
}


- (void)showPhotoBrowser{
    NSMutableArray *items = [NSMutableArray array];
    YYPhotoGroupItem *item = [YYPhotoGroupItem new];
    item.thumbView = self.cell_contentImage;
    // image url
    NSString *urlStr = self.model.image0;
    if (!urlStr) {
        urlStr = self.model.cdn_img;
    }
    item.largeImageURL = [NSURL URLWithString:urlStr];
    [items addObject:item];
    
    
    YYPhotoGroupView *groupView = [[YYPhotoGroupView alloc]initWithGroupItems:items];
    [groupView presentFromImageView:self.cell_contentImage toContainer:self.controller.navigationController.view animated:YES completion:nil];
    
}

- (void)showPhotoBrowserWithThumb:(UIImageView *)thumb url:(NSString *)url fromView:(UIView *)fromView{
    // item
    NSMutableArray *items = [NSMutableArray array];
    YYPhotoGroupItem *item = [YYPhotoGroupItem new];
    item.thumbView = thumb;
    // image url
    item.largeImageURL = [NSURL URLWithString:url];
    [items addObject:item];
    // show
    YYPhotoGroupView *groupView = [[YYPhotoGroupView alloc]initWithGroupItems:items];
    [groupView presentFromImageView:fromView toContainer:self.controller.navigationController.view animated:YES completion:nil];
}

@end
