//
//  Foundation+CoreGraphics.h
//  ATFoundation
//
//  Created by Aesir Titan on 2016-09-02.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


// screen marco
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define kScreenCenterX (0.5 * kScreenW)
#define kScreenCenterY (0.5 * kScreenH)



#pragma mark CGSize

/*!
 *	@author Aesir Titan
 *
 *	@brief CGSizeUp
 *
 *	@param upOffset	up offset
 *
 *	@return a size
 */
CG_EXTERN CGSize CGSizeUp(CGFloat upOffset);

/*!
 *	@author Aesir Titan
 *
 *	@brief CGSizeDown
 *
 *	@param downOffset	down offset
 *
 *	@return a size
 */
CG_EXTERN CGSize CGSizeDown(CGFloat downOffset);

#pragma mark CGRect

/*!
 *	@author Aesir Titan
 *
 *	@brief CGRectWithTopMargin
 *
 *	@param top	top margin
 *
 *	@return a rect
 */
CG_EXTERN CGRect CGRectWithTopMargin(CGFloat top);

/*!
 *	@author Aesir Titan
 *
 *	@brief CGRectWithTopAndBottomMargin
 *
 *	@param top		top margin
 *	@param bottom	bottom margin
 *
 *	@return a rect
 */
CG_EXTERN CGRect CGRectWithTopAndBottomMargin(CGFloat top, CGFloat bottom);

/*!
 *	@author Aesir Titan
 *
 *	@brief convert the target view's frame to superview
 *
 *	@param targetView	target view
 *	@param superView	super view
 *
 *	@return a rect
 */
CG_EXTERN CGRect CGRectWithViewInScreen(UIView *targetView);


struct ATUIntegerRange {
    NSUInteger minValue;
    NSUInteger maxValue;
};

typedef struct ATUIntegerRange ATUIntegerRange;

/*!
 *	@author Aesir Titan
 *
 *	@brief get a length range
 *
 *	@param minLength	min length
 *	@param maxLength	max length
 *
 *	@return a length range
 */
CG_EXTERN ATUIntegerRange ATUIntegerRangeMake(NSUInteger minValue, NSUInteger maxValue);

/*!
 *	@author Aesir Titan
 *
 *	@brief get a random from length range
 *
 *	@param length	langth range
 *
 *	@return a random length
 */
CG_EXTERN NSUInteger ATRandomUIntegerFrom(ATUIntegerRange range);


struct ATFloatRange{
    CGFloat minValue;
    CGFloat maxValue;
};
typedef struct ATFloatRange ATFloatRange;

/*!
 *	@author Aesir Titan
 *
 *	@brief get a CGFloat range
 *
 *	@param minFloat	min value
 *	@param maxFloat	max value
 *
 *	@return a CGFloat range
 */
CG_EXTERN ATFloatRange ATFloatRangeMake(CGFloat minValue, CGFloat maxValue);




