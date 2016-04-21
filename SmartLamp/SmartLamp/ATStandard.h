//
//  ATStandard.h
//  Aesir Titan Standard Protocol
//
//  Created by Aesir Titan on 2016.
//  Copyright © 2016 Titan Studio. All rights reserved.
//
//
//  ======================================================
//               Aesir Titan Standard Protocol
//     ================================================
//
//
/*
 
    在这里将模板更换为本项目具体的类
    本项目的类从属关系为:
    本项目模型的基类 <= 父类       <= ... <= 子类

    ATBookList    <= ATBookType        <= ATBook

 
 */

// 在这里导入一次 Foundation / UIKit , 所有遵守 ATStandard 协议的类及其子类都无需导入了
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/***************************  ATBaseModel == AT基类模型协议  ***************************/
@protocol ATBaseModel <NSObject>

/*======================[ 文件 ]======================*/
//                          最小的子类头文件
#define ATClassH            "ATbook.h"

//                          文件名(不包含扩展名)
#define PLIST               @"books"
//                          缓存文件名(不包含扩展名)
#define CACHE               @"tempBook"


/*======================[ 类和对象 ]======================*/
//                          父类和父类对象
#define ATClassGroup        ATBookType
#define objectGroup         bookType
//                          父类的属性 (可变数组, 里面装的是所有子类对象)
#define objects             books

//                          子类和子类对象
#define ATClass             ATBook
#define object              book


/*======================[ 类和对象的方法 ]======================*/
//                          父类的静态构造方法
#define objectGroupWithDic  bookTypeWithDic
//                          子类的静态构造方法
#define objectWithDic       bookWithDic


/*======================[ 属性归档 ]======================*/
// 父类属性的宏               父类属性的 key
#define TITLE               @"typeTitle"
#define BOOKS               @"books"

// 子类属性的宏               子类属性的 key
#define LOGO                @"logo"
#define NAME                @"name"
#define AUTHOR              @"author"
#define INTRO               @"intro"
#define CONTENT             @"content"



@end

@class ATClass;
/***************************  ATModelGroup == AT父类模型协议  ***************************/
@protocol ATModelGroup <NSObject,NSCoding>

/*======================[ 方法 ]======================*/
@required

/**
 *	@author Aesir Titan
 *
 *	@brief 示例构造方法
 *
 *	@param dic	用于初始化的数据源字典
 *
 *	@return 返回用字典设置了属性的对象
 */
- (instancetype)initWithDic:(NSDictionary *)dic;

/**
 *	@author Aesir Titan
 *
 *	@brief 静态构造方法
 *
 *	@param dic	用于初始化的数据源字典
 *
 *	@return 返回用字典设置了属性的对象
 */
+ (instancetype)objectGroupWithDic:(NSDictionary *)dic;

/**
 *	@author Aesir Titan
 *
 *	@brief 重写 init, 防止对象初始化为 nil
 *
 *	@return 返回有默认属性的对象
 */
- (instancetype)init;

/**
 *	@author Aesir Titan
 *
 *	@brief 重写 description, 便于在控制台调试
 *
 *	@return 返回这个对象的标题属性
 */
- (NSString *)description;


@optional

/**
 *	@author Aesir Titan
 *
 *	@brief 增加一个子类对象到自身 objects 数组
 *
 *	@param object	子类对象
 *	@param index	objects 数组索引
 */
- (void)insertObject:(ATClass *)object atIndex:(NSUInteger)index;

@end

/***************************  ATModel == AT类模型协议  ***************************/
@protocol ATModel <NSObject,NSCoding>

/*======================[ 方法 ]======================*/
@required

/**
 *	@author Aesir Titan
 *
 *	@brief 示例构造方法
 *
 *	@param dic	用于初始化的数据源字典
 *
 *	@return 返回用字典设置了属性的对象
 */
- (instancetype)initWithDic:(NSDictionary *)dic;

/**
 *	@author Aesir Titan
 *
 *	@brief 静态构造方法
 *
 *	@param dic	用于初始化的数据源字典
 *
 *	@return 返回用字典设置了属性的对象
 */
+ (instancetype)objectWithDic:(NSDictionary *)dic;

/**
 *	@author Aesir Titan
 *
 *	@brief 重写 init, 防止对象初始化为 nil
 *
 *	@return 返回有默认属性的对象
 */
- (instancetype)init;

/**
 *	@author Aesir Titan
 *
 *	@brief 重写 description, 便于在控制台调试
 *
 *	@return 返回这个对象的标题属性
 */
- (NSString *)description;


@end

/***************************  ATBaseView == AT基类视图协议  ***************************/
@protocol ATBaseView <NSObject>

/*======================[ 控件 ]======================*/

/**
 *	@author Aesir Titan
 *
 *	@brief 控件样式的枚举
 */
typedef NS_ENUM(NSInteger, ATWidgetAnimation) {
    /**
     *	@author Aesir Titan
     *
     *	没有阴影效果
     */
    ATWidgetAnimationNone,
    /**
     *	@author Aesir Titan
     *
     *	标题样式
     */
    ATWidgetAnimationTitleStyle,
    /**
     *	@author Aesir Titan
     *
     *	编辑样式
     */
    ATWidgetAnimationEditing,
    /**
     *	@author Aesir Titan
     *
     *	非编辑样式
     */
    ATWidgetAnimationEditEnd,
    /**
     *	@author Aesir Titan
     *
     *	按钮松开样式
     */
    ATWidgetAnimationButtonUp,
    /**
     *	@author Aesir Titan
     *	
     *	按钮按下样式
     */
    ATWidgetAnimationButtonDown,
};




@end
