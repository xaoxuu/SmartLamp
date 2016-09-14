//
//  NSString+ATExtension.h
//  ATFoundation
//
//  Created by Aesir Titan on 2016-08-30.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Foundation+CoreGraphics.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - get a string from ...

/*!
 *	@author Aesir Titan
 *
 *	@brief get a string from NSInteger
 *
 *	@param integer	NSInteger
 *
 *	@return a string
 */
FOUNDATION_EXTERN NSString *NSStringFromInt32(int x);

/*!
 *	@author Aesir Titan
 *
 *	@brief get a string from NSInteger
 *
 *	@param integer	NSInteger
 *
 *	@return a string
 */
FOUNDATION_EXTERN NSString *NSStringFromNSInteger(NSInteger x);

/*!
 *	@author Aesir Titan
 *
 *	@brief get a string from NSUInteger
 *
 *	@param uinteger  NSUInteger
 *
 *	@return a string
 */
FOUNDATION_EXTERN NSString *NSStringFromNSUInteger(NSUInteger x);

/*!
 *	@author Aesir Titan
 *
 *	@brief get a string from CGFloat
 *
 *	@param x	CGFloat
 *
 *	@return a string
 */
FOUNDATION_EXTERN NSString *NSStringFromCGFloat(CGFloat x);

/*!
 *	@author Aesir Titan
 *
 *	@brief get a string from a pointer
 *
 *	@param pointer	object pointer
 *
 *	@return a string
 */
FOUNDATION_EXTERN NSString *NSStringFromPointer(id x);

typedef NS_ENUM(NSUInteger, ATRandomStringType){
    ATRandomName,
    ATRandomPassword,
    
    ATRandomLowerString,
    ATRandomUpperString,
    ATRandomCapitalizeString,
};
/*!
 *	@author Aesir Titan
 *
 *	@brief get a random string
 *
 *	@param type		string type
 *	@param length	length range
 *
 *	@return a random string
 */
FOUNDATION_EXTERN NSString *NSStringFromRandom(ATRandomStringType type, ATUIntegerRange length);

@interface NSString (ATRandomExtension)

/*!
 *	@author Aesir Titan
 *
 *	@brief get a random string for name
 *
 *	@param length	length range (min,max)
 *
 *	@return a random string
 */
+ (NSString *)stringWithRandomNameWithLength:(ATUIntegerRange)length;

/*!
 *	@author Aesir Titan
 *
 *	@brief get a random string for password
 *
 *	@param length	length range (min,max)
 *
 *	@return a random string
 */
+ (NSString *)stringWithRandomPasswordWithLength:(ATUIntegerRange)length;

/*!
 *	@author Aesir Titan
 *
 *	@brief get a random lower string
 *
 *	@param length	length range (min,max)
 *
 *	@return a random string
 */
+ (NSString *)stringWithRandomLowerStringWithLength:(ATUIntegerRange)length;

/*!
 *	@author Aesir Titan
 *
 *	@brief get a random upper string
 *
 *	@param length	length range (min,max)
 *
 *	@return a random string
 */
+ (NSString *)stringWithRandomUpperStringWithLength:(ATUIntegerRange)length;

/*!
 *	@author Aesir Titan
 *
 *	@brief get a random capitalize string
 *
 *	@param length	length range (min,max)
 *
 *	@return a random string
 */
+ (NSString *)stringWithRandomCapitalizeStringWithLength:(ATUIntegerRange)length;

@end

NS_ASSUME_NONNULL_END


