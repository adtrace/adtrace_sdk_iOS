//
//  ViewController.m
//  AdtraceExample-WebView
//

#import "UIWebViewController.h"

@interface UIWebViewController ()

@end

@implementation UIWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadUIWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadUIWebView {
    UIWebView *uiWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:uiWebView];

    _adtraceBridge = [[AdtraceBridge alloc] init];
    [_adtraceBridge loadUIWebViewBridge:uiWebView webViewDelegate:self];
    [_adtraceBridge augmentHybridWebView];

    _jsContext = [uiWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    _jsContext[@"console"][@"log"] = ^(JSValue * msg) {
        NSLog(@"JavaScript %@ log message: %@", [JSContext currentContext], msg);
    };

    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"AdtraceExample-FbPixel" ofType:@"html"];
    NSString *appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [uiWebView loadHTMLString:appHtml baseURL:baseURL];
}

- (void)callUiHandler:(id)sender {

}

@end

