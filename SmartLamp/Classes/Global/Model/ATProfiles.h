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
typedef NS_ENUM(NSUInteger,ATColorMode){
    // no animation
    ATColorModeNone = 0x29,
    // saltus step 3
    ATColorModeSaltusStep3 = 0x26,
    // saltus step 7
    ATColorModeSaltusStep7 = 0x27,
    // gratation
    ATColorModeGratation = 0x28,
    
};

// title
@property (copy, nonatomic) NSString *title;

// detail
@property (copy, nonatomic) NSString *detail;

// icon
@property (strong, nonatomic) UIImage *icon;

// image
@property (strong, nonatomic) UIImage *image;

// timer
@property (assign, nonatomic) NSUInteger timer;

// color animation
@property (assign, nonatomic) ATColorMode colorMode;

// color
@property (strong, nonatomic) UIColor *color;

// brightness
@property (assign, nonatomic) CGFloat brightness;

// creator
+ (instancetype)defaultProfiles;

- (instancetype(^)())randomSelectImage;

@end
