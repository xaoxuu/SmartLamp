//
//  NewsCellView.m
//  NEXUS
//
//  Created by Aesir Titan on 2016-05-27.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "NewsCellView.h"

#import "UIImageView+WebCache.h"

@implementation NewsCellView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.cellImageView.clipsToBounds = YES;
    self.cellImageView.layer.cornerRadius = 2;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(NewsModel *)model
{
    _model = model;
    self.cellImageView.image = [UIImage imageNamed:@"discover_placeholder"];
    if (model.imageurls) {
        NSArray *urlArr = model.imageurls;
        if (urlArr.count) {
            NSString *imageUrl;
            for (id str in [urlArr[0] allValues]) {
                if ([str isKindOfClass:[NSString class]]&&[str containsString:@"http"]) {
                    imageUrl = str;
                }
            }
            [self.cellImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"discover_placeholder"]];
            self.cellImageView.layer.at_shadow(ATShadowCenterLight);
        }
    }
    
    self.lbTitle.text = model.title;
    self.lbDate.text = model.pubDate;
    self.lbSource.text = model.source;
    [self layoutIfNeeded];
}



@end
