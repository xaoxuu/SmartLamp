//
//  SceneCollectionView.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-26.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SceneCollectionView : UIView


- (void)reloadData;

- (void)addItem;

- (void)saveData;

- (void)removeItem;

@end
