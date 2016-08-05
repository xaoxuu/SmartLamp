//
//  ATProfiles.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-05-10.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ATProfiles : NSObject <NSCoding>

// color animation
typedef NS_ENUM(NSUInteger,ColorAnimation){
    // no animation
    ColorAnimationNone = 0x29,
    // saltus step 3
    ColorAnimationSaltusStep3 = 0x26,
    // saltus step 7
    ColorAnimationSaltusStep7 = 0x27,
    // gratation
    ColorAnimationGratation = 0x28,
    
};

// title
@property (copy, nonatomic) NSString *title;

// detail
@property (copy, nonatomic) NSString *detail;

// image
@property (strong, nonatomic) UIImage *image;

// timer
@property (assign, nonatomic) NSUInteger timer;

// color animation
@property (assign, nonatomic) ColorAnimation colorAnimation;

// color
@property (strong, nonatomic) UIColor *color;

// brightness
@property (assign, nonatomic) CGFloat brightness;

// creator
+ (instancetype)defaultProfiles;


@end
