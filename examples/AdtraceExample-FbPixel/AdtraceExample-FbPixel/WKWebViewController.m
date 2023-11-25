//
//  WKWebViewController.m
//  AdtraceExample-WebView
//
//  Created by Uglješa Erceg (@uerceg) on 23rd August 2018.
//  Copyright © 2018-Present Adtrace GmbH. All rights reserved.
//

#import "WKWebViewController.h"

@interface WKWebViewController ()<WKNavigationDelegate>

@end

@implementation WKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadWKWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadWKWebView {
    
    WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:self.view.frame];
    _adtraceBridge = [[AdtraceBridge alloc] init];
    [_adtraceBridge loadWKWebViewBridge:wkWebView wkWebViewDelegate:self];
    [_adtraceBridge augmentHybridWebView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AdtraceExample-FbPixel" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [wkWebView loadRequest:request];
    [self.view addSubview:wkWebView];
}

@end
