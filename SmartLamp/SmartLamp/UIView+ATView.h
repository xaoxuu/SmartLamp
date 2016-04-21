//
//  UIView+ATView.h
//  Aesir Titan UIView Category
//
//  Created by Aesir Titan on 2016.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

// 只导入 ATStandard 规范就可以了, 因为在自定义 ATStandard 的时候导入了 Foundation 和 UIKit
#import "ATStandard.h"



@interface UIView (ATView) <ATBaseView>

/**
 *	@author Aesir Titan
 *
 *	@brief 设置控件的阴影效果
 *
 *	@param state	控件状态
 */
- (void)shadowLayer:(ATWidgetAnimation)state;

@end
