//
//  WKWebViewController.h
//  AdtraceExample-WebView
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

#import "AdtraceBridge.h"

@interface WKWebViewController : UINavigationController<WKNavigationDelegate>

@property AdtraceBridge *adtraceBridge;

@end
