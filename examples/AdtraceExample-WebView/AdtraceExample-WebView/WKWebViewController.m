//
//  WKWebViewController.m
//  AdtraceExample-WebView
//
//  Created by Uglješa Erceg on 31/05/16.
//  Copyright © 2016 adtrace GmbH. All rights reserved.
//

#import "WKWebViewController.h"

@interface WKWebViewController ()

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
    WKWebView *webView = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:self.view.bounds];
    webView.navigationDelegate = self;
    [self.view addSubview:webView];

    _adtraceBridge = [[AdtraceBridge alloc] init];
    [_adtraceBridge loadWKWebViewBridge:webView wkWebViewDelegate:self];

    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"AdtraceExample-WebView" ofType:@"html"];
    NSString *appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
}

- (void)callWkHandler:(id)sender {
    
}

@end
