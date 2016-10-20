//
//  ATRadioButton.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-02.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ATMaterialButton.h"

@interface ATRadioButton : ATMaterialButton
/**
 *	@author Aesir Titan, 2016-08-02 15:08:11
 *
 *	@brief deselect all button
 */
- (void)deSelectAllButton;
/**
 *	@author Aesir Titan, 2016-08-02 15:08:22
 *
 *	@brief deselect all button but ignore self
 */
- (void)deSelectAllButtonIgnoreSelf;

@end
