//
//  ViewController.h
//  AdtraceExample-WebView
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

#import "AdtraceBridge.h"

@interface UIWebViewController : UINavigationController <UIWebViewDelegate>

@property AdtraceBridge *adtraceBridge;
@property JSContext *jsContext;

@end

