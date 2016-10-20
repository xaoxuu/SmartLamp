//
//  ATCarouselView+Creator.h
//  DearyPet
//
//  Created by Aesir Titan on 2016-08-27.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <ATKit/ATCarouselView.h>

@interface ATCarouselView (Creator)


+ (instancetype)carouselWithView:(UIView *)view imageURLs:(NSArray<NSString *> *)imageURLs titles:(NSArray<NSString *> *)titles action:(void (^)(NSUInteger index))action;

+ (instancetype)carouselWithView:(UIView *)view count:(NSUInteger)count bundleImageName:(NSString *)bundleImageName titles:(NSArray<NSString *> *)titles action:(void (^)(NSUInteger index))action;


@end
