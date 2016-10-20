//
//  UIColorManager.m
//  Foundation
//
//  Created by Aesir Titan on 2016-08-21.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import "UIColorManager.h"
#import "UIColor+MaterialDesign.h"
#import "UIColor+ATExtension.h"

UIColorManager *atColor = nil;

#define ColorProfiles_Theme @"ColorProfiles_Theme"
#define ColorProfiles_Accent @"ColorProfiles_Accent"
#define ColorProfiles_Background @"ColorProfiles_Background"

@implementation UIColorManager

#pragma mark - color tool

- (void)saveColorProfilesWithTheme:(UIColor *)theme accent:(UIColor *)accent background:(UIColor *)background{
    self.theme = theme;
    self.accent = accent;
    self.background = background;
    // save
    [self saveCurrentColorProfiles];
}

- (void)saveCurrentColorProfiles{
    [[NSUserDefaults standardUserDefaults] setObject:self.theme.hexString forKey:ColorProfiles_Theme];
    [[NSUserDefaults standardUserDefaults] setObject:self.accent.hexString forKey:ColorProfiles_Accent];
    [[NSUserDefaults standardUserDefaults] setObject:self.background.hexString forKey:ColorProfiles_Background];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)readColorProfiles{
    NSString *theme = [[NSUserDefaults standardUserDefaults] objectForKey:ColorProfiles_Theme];
    NSString *accent = [[NSUserDefaults standardUserDefaults] objectForKey:ColorProfiles_Accent];
    NSString *background = [[NSUserDefaults standardUserDefaults] objectForKey:ColorProfiles_Background];
    if (theme.length) {
        self.theme = [UIColor colorWithHex:theme.integerValue];
    }
    if (accent.length) {
        self.accent = [UIColor colorWithHex:accent.integerValue];
    }
    if (background.length) {
        self.background = [UIColor colorWithHex:background.integerValue];
    }
}

#pragma mark - system color

- (UIColor *)black{
    return [UIColor blackColor];
}
- (UIColor *)darkGray{
    return [UIColor darkGrayColor];
}
- (UIColor *)gray{
    return [UIColor grayColor];
}
- (UIColor *)lightGray{
    return [UIColor lightGrayColor];
}
- (UIColor *)white{
    return [UIColor whiteColor];
}
- (UIColor *)clear{
    return [UIColor clearColor];
}
- (UIColor *)groupTableViewBackground{
    return [UIColor groupTableViewBackgroundColor];
}


#pragma mark - life circle

#pragma mark init

+ (void)load{
    [super load];
    [self defaultManager];
}

#pragma mark creator

// defaultManager
+ (instancetype)defaultManager{
    return [self sharedManager];
}

// sharedManager
+ (instancetype)sharedManager{
    if (!atColor) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if (!atColor) {
                atColor = [[UIColorManager alloc]init];
            }
        });
    }
    return atColor;
}

// allocWithZone
+ (instancetype) allocWithZone:(NSZone *)zone{
    if (!atColor) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if (!atColor) {
                atColor = [super allocWithZone:zone];
            }
        });
    }
    return atColor;
}

// init
- (instancetype)init{
    if (!atColor){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if (!atColor){
                atColor = [[UIColorManager alloc] init];
            }
        });
    }
    
    // init
    _theme = [UIColor md_blue];
    _accent = [UIColor md_orange];
    _background = [UIColor whiteColor];
    
    // load cache
    [self readColorProfiles];
    
    return atColor;
    
}

// copyWithZone
+ (id)copyWithZone:(struct _NSZone *)zone{
    return [self sharedManager];
}

// copyWithZone
- (id)copyWithZone:(struct _NSZone *)zone{
    return [UIColorManager sharedManager];
}

// mutableCopyWithZone
+ (id)mutableCopyWithZone:(struct _NSZone *)zone{
    return [self sharedManager];
}

// mutableCopyWithZone
- (id)mutableCopyWithZone:(struct _NSZone *)zone{
    return [UIColorManager sharedManager];
}

// copy
+ (id)copy{
    return [UIColorManager sharedManager];
}

@end




