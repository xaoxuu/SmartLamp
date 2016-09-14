//
//  ATFoundation.h
//  ATKit
//
//  Created by Aesir Titan on 2016-09-12.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

//  >>>>>>>>>>>>>>>>>>>>  Aesir Titan  <<<<<<<<<<<<<<<<<<<<
//  >>                                                   <<
//  >>  http://ayan.site                                 <<  (我的主页)
//  >>  http://github.com/AesirTitan)                    <<  (github主页)
//  >>  http://nexusonline.github.io)                    <<  (macOS应用下载站)
//  >>  http://www.jianshu.com/notebooks/6236581/latest) <<  (ATKit使用文档)
//  >>                                                   <<
//  >>>>>>>>>>>>>>>>>>>>  Aesir Titan  <<<<<<<<<<<<<<<<<<<<


#pragma mark - Foundation
// 对layer的链式封装，便于快速设置图层样式
#import <ATKit/CALayer+ATChainedWrapper.h>
// NSLog的宏以及Log字典、数组内容的扩展
#import <ATKit/Foundation+ATLogExtension.h>
// 沙盒文件流的链式封装，一行代码搞定沙盒文件操作
#import <ATKit/NSString+ATFileStreamChainedWrapper.h>
// NSString类的扩展（随机字符串等）
#import <ATKit/NSString+ATExtension.h>
// 对NSObject的performSelector的block封装，基于<BlocksKit>改编
#import <ATKit/NSObject+ATBlockWrapper.h>
// 对NSTimer的block封装，基于<BlocksKit>改编
#import <ATKit/NSTimer+ATBlockWrapper.h>


#pragma mark - UIKit
// 对UIBarButtonItem的block封装，基于<BlocksKit>改编
#import <ATKit/UIBarButtonItem+ATBlockWrapper.h>

// 颜色管理器，在AppDelegate中设置全局的主题色，然后所有代码中使用'atColor.xx'来调用颜色
#import <ATKit/UIColorManager.h>
// 颜色增强工具
#import <ATKit/UIColor+ATExtension.h>
// MaterialDesign配色方案，前缀为'md'例如[UIColor md_blue]
#import <ATKit/UIColor+MaterialDesign.h>
// AT的配色方案，前缀为'at'例如[UIColor at_cyan]
#import <ATKit/UIColor+ATColorPack.h>

// 事件响应的Target
#import <ATKit/Foundation+ATEventTarget.h>
// 对UIControl的block封装，基于<BlocksKit>改编（包含常用控件）
#import <ATKit/UIControl+ATBlockWrapper.h>
// UITextField的功能扩展
#import <ATKit/UITextField+ATExtension.h>

// CIImage的功能扩展
#import <ATKit/CIImage+ATScaleExtension.h>
// 从UIImageView指定位置获取颜色
#import <ATKit/UIImageView+ATGetColor.h>
// UIImage的功能扩展
#import <ATKit/UIImage+ATExtension.h>

// UIView的功能扩展
#import <ATKit/UIView+ATExtension.h>
// UIView的动画效果封装，便于调用
#import <ATKit/UIView+ATAnimationWrapper.h>
// UIView的Frame封装，便于快速设定一个view的frame
#import <ATKit/UIView+ATFrameWrapper.h>
// UIView的手势封装，便于快速给一个view添加手势
#import <ATKit/UIView+ATGestureExtension.h>

// UITextView的功能扩展
#import <ATKit/UITextView+ATExtension.h>

// UIFont的封装
#import <ATKit/UIFont+ATWrapper.h>



