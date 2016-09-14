//
//  UIColor+MaterialDesign.h
//  Foundation
//
//  Created by Aesir Titan on 2016-08-13.
//  Copyright © 2016 Titan Studio. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIColor (MaterialDesign)

#pragma mark red -> purple
+ (UIColor *)md_red;
+ (UIColor *)md_pink;
+ (UIColor *)md_purple;
+ (UIColor *)md_deepPurple;

#pragma mark blue -> cyan
+ (UIColor *)md_indigo;
+ (UIColor *)md_blue;
+ (UIColor *)md_lightBlue;
+ (UIColor *)md_cyan;
+ (UIColor *)md_teal;

#pragma mark green -> yellow
+ (UIColor *)md_green;
+ (UIColor *)md_lightGreen;
+ (UIColor *)md_lime;
+ (UIColor *)md_yellow;
+ (UIColor *)md_amber;

#pragma mark orange -> gray
+ (UIColor *)md_orange;
+ (UIColor *)md_deepOrange;
+ (UIColor *)md_brown;
+ (UIColor *)md_blueGray;
+ (UIColor *)md_gray;


@end
