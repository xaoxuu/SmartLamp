//
//  WebViewController.h
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-07.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ATBaseViewController.h"

@interface WebViewController : ATBaseViewController

// url
@property (copy, nonatomic) NSString *urlStr;

- (instancetype)initWithTitle:(NSString *)title urlStr:(NSString *)urlStr;

@end
