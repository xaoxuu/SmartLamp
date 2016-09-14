//
//  NewsCellView.h
//  NEXUS
//
//  Created by Aesir Titan on 2016-05-27.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATTableViewCell.h"
#import "NewsModel.h"

@interface NewsCellView : ATTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;


@property (weak, nonatomic) IBOutlet UILabel *lbSource;
@property (weak, nonatomic) IBOutlet UILabel *lbDate;

@property (nonatomic,strong) NewsModel * model;


@end
