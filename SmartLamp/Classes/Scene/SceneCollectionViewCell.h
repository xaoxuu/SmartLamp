//
//  SceneCollectionViewCell.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-26.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATTableViewCell.h"

@interface SceneCollectionViewCell : UICollectionViewCell

// scene model
@property (strong, nonatomic) ATProfiles *model;

// delete
@property (copy, nonatomic) void (^deleteAction)(UIButton *sender);

// set selected
@property (assign, nonatomic) BOOL isSelect;
+ (instancetype)reusableCellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;

@end
