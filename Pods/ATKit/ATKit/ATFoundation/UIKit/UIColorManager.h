//
//  UIColorManager.h
//  Foundation
//
//  Created by Aesir Titan on 2016-08-21.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIColorManager;
extern UIColorManager *atColor;

@interface UIColorManager : NSObject

#pragma mark - theme color

// theme color
@property (strong, nonatomic) UIColor *theme;

// accent color
@property (strong, nonatomic) UIColor *accent;

// background default is white
@property (strong, nonatomic) UIColor *background;


#pragma mark - color tool

- (void)saveCurrentColorProfiles;

- (void)saveColorProfilesWithTheme:(UIColor *)theme accent:(UIColor *)accent background:(UIColor *)background;

#pragma mark - system color

- (UIColor *)black;      // 0.0 white
- (UIColor *)darkGray;   // 0.333 white
- (UIColor *)gray;       // 0.5 white
- (UIColor *)lightGray;  // 0.667 white
- (UIColor *)white;      // 1.0 white
- (UIColor *)clear;      // 0.0 white, 0.0 alpha
- (UIColor *)groupTableViewBackground;


#pragma mark - life circle

+ (instancetype)defaultManager;

@end


