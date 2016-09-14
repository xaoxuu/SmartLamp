//
//  UIFont+ATWrapper.h
//  ATKit
//
//  Created by Aesir Titan on 2016-09-12.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN UIFont *FontWithSize(CGFloat size);

UIKIT_EXTERN UIFont *BoldFontWithSize(CGFloat size);

UIKIT_EXTERN CGFloat HeightWithTextFontWidth(NSString *text,UIFont *font,CGFloat width);

@interface UIFont (ATWrapper)

@end
