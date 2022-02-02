







#import <Foundation/Foundation.h>
#import "WKWebViewJavascriptBridge.h"

@interface AdtraceBridgeRegister : NSObject

+ (NSString *)AdtraceBridge_js;

- (id)initWithWKWebView:(WKWebView*)webView;
- (void)setWKWebViewDelegate:(id<WKNavigationDelegate>)webViewDelegate;
- (void)callHandler:(NSString *)handlerName data:(id)data;
- (void)registerHandler:(NSString *)handlerName handler:(WVJBHandler)handler;
- (void)augmentHybridWebView:(NSString *)fbAppId;

@end
