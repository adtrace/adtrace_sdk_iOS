//
//  WKWebViewController.m
//  AdtraceExample-WebView
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
    [_adtraceBridge augmentHybridWebView];

    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"AdtraceExample-FbPixel" ofType:@"html"];
    NSString *appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
}

- (void)callWkHandler:(id)sender {
    
}

@end
