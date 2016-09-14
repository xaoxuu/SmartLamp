//
//  CALayer+ATChainedWrapper.h
//  ATKit
//
//  Created by Aesir Titan on 2016-09-02.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CALayer (ATChainedWrapper)

#pragma mark - corner
/*!
 *	@author Aesir Titan, 2016-08-29
 *
 *	@brief clip
 */
- (CALayer *(^)())at_maskToCircle;

#pragma mark - shadow
/*!
 *	@author Aesir Titan, 2016-08-29
 *
 *	@brief ATShadow
 */
typedef NS_ENUM(NSUInteger,ATShadow) {
    /*!
     *	@author Aesir Titan, 2016-08-29
     *
     *	for light top bar
     */
    ATShadowDownLight,
    /*!
     *	@author Aesir Titan, 2016-08-29
     *
     *	for normal top bar
     */
    ATShadowDownNormal,
    /*!
     *	@author Aesir Titan, 2016-08-29
     *
     *	for raised button
     */
    ATShadowDownFloat,
    /*!
     *	@author Aesir Titan, 2016-08-29
     *
     *	for light bottom bar
     */
    ATShadowUpLight,
    /*!
     *	@author Aesir Titan, 2016-08-29
     *
     *	for normal bottom bar
     */
    ATShadowUpNormal,
    /*!
     *	@author Aesir Titan, 2016-08-29
     *
     *	for light view
     */
    ATShadowCenterLight,
    /*!
     *	@author Aesir Titan, 2016-08-29
     *
     *	for normal view
     */
    ATShadowCenterNormal,
    /*!
     *	@author Aesir Titan, 2016-08-29
     *
     *	for dark view
     */
    ATShadowCenterHeavy,
};

/*!
 *	@author Aesir Titan, 2016-08-30
 *
 *	@brief get shadow
 */
- (CALayer *(^)(ATShadow type))at_shadow;

#pragma mark - border

/*!
 *	@author Aesir Titan, 2016-08-29
 *
 *	@brief a white border with width
 */
- (CALayer *(^)(CGFloat width))at_whiteBorder;

/*!
 *	@author Aesir Titan, 2016-08-29
 *
 *	@brief a theme color border with width
 */
- (CALayer *(^)(CGFloat width))at_themeBorder;

@end
