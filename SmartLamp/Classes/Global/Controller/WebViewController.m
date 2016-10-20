//
//  WebViewController.m
//  SmartLamp
//
//  Created by Aesir Titan on 2016-08-07.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// setup web view
- (void)setupWebView{
    // init and add to superview
    
    if (self.urlStr.length) {
        
        // url
        NSURL *url = [NSURL URLWithString:self.urlStr];
        // web
        UIWebView *web = [[UIWebView alloc] initWithFrame:self.view.bounds];
        web.height -= 64;
        [self.view addSubview:web];
        // request
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:6.0f];
        // load request
        [web loadRequest:request];
        
    } else{
        ATLogFail(@"URL not found");
    }
    
}

- (instancetype)initWithTitle:(NSString *)title urlStr:(NSString *)urlStr {
    if (self = [super init]) {
        self.title = title;
        self.urlStr = urlStr;
    }
    return self;
}


@end
