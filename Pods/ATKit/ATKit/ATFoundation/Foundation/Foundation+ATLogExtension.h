//
//  Foundation+ATLogExtension.h
//  Foundation
//
//  Created by Aesir Titan on 2016-08-13.
//  Copyright © 2016 Titan Studio. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifdef __OBJC__ // ==================== [ __OBJC__ Macro ] ==================== //
#ifdef DEBUG // ==================== [ DEBUG Macro ] ==================== //


#define ATLog(format, ...) NSLog((@"\nfunc:%s" "line:%d\n" "💬" format "\n\n"), __FUNCTION__, __LINE__, ##__VA_ARGS__)

#define ATLogFunc NSLog((@"\nfunc:%s" "line:%d\n" "\n"), __FUNCTION__, __LINE__)


// result macro
#define ATLogBOOL(BOOL) NSLog((@"\nfunc:%s" "line:%d\n" "%@" "\n\n"), __FUNCTION__, __LINE__, BOOL ? @"🔵Success" : @"🔴Fail")

#define ATLogSuccess(format, ...) NSLog((@"\nfunc:%s" "line:%d\n" "🔵success: " format "\n\n"), __FUNCTION__, __LINE__, ##__VA_ARGS__)

#define ATLogFail(format, ...) NSLog((@"\nfunc:%s" "line:%d\n" "🔴error: " format "\n\n"), __FUNCTION__, __LINE__, ##__VA_ARGS__)

#define ATLogError(NSError) NSLog((@"\nfunc:%s" "line:%d\n" "🔴%@" "\n\n"), __FUNCTION__, __LINE__, NSError.localizedDescription)


// obj macro
#define ATLogOBJ(NSObject) NSLog((@"\nfunc:%s" "line:%d\n" "💬%@" "\n\n"), __FUNCTION__, __LINE__, NSObject)


// CG macro
#define ATLogNSInteger(NSInteger) NSLog((@"\nfunc:%s" "line:%d\n" "💬%ld" "\n\n"), __FUNCTION__, __LINE__, NSInteger)
#define ATLogNSUInteger(NSUInteger) NSLog((@"\nfunc:%s" "line:%d\n" "💬%lld" "\n\n"), __FUNCTION__, __LINE__, NSUInteger)

#define ATLogCGFloat(CGFloat) NSLog((@"\nfunc:%s" "line:%d\n" "💬%f" "\n\n"), __FUNCTION__, __LINE__, CGFloat)
#define ATLogCGPoint(CGPoint) NSLog((@"\nfunc:%s" "line:%d\n" "💬%@" "\n\n"), __FUNCTION__, __LINE__, NSStringFromCGPoint(CGPoint))

#define ATLogCGSize(CGSize) NSLog((@"\nfunc:%s" "line:%d\n" "💬%@" "\n\n"), __FUNCTION__, __LINE__, NSStringFromCGSize(CGSize))
#define ATLogCGRect(CGRect) NSLog((@"\nfunc:%s" "line:%d\n" "💬%@" "\n\n"), __FUNCTION__, __LINE__, NSStringFromCGRect(CGRect))


#else

#define ATLog(format, ...)
#define ATLogFunc
// result macro
#define ATLogBOOL(BOOL)
#define ATLogSuccess(format, ...)
#define ATLogFail(format, ...)
#define ATLogError(NSError)
// obj macro
#define ATLogOBJ(NSObject)
// CG macro
#define ATLogNSInteger(NSInteger)
#define ATLogNSUInteger(NSUInteger)
#define ATLogCGFloat(CGFloat) 
#define ATLogCGPoint(CGPoint)
#define ATLogCGSize(CGSize)
#define ATLogCGRect(CGRect)


#endif // ==================== [ DEBUG Macro ] ==================== //

#else
#endif // ==================== [ __OBJC__ Macro ] ==================== //





