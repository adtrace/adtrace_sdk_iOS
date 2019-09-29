//
//  AdtraceBridge.h
//  Adtrace SDK
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <Foundation/Foundation.h>
#import "AdtraceBridgeRegister.h"

@interface AdtraceBridge : NSObject

@property (nonatomic, strong, readonly) AdtraceBridgeRegister *bridgeRegister;

- (void)loadWKWebViewBridge:(WKWebView *)wkWebView;
- (void)loadWKWebViewBridge:(WKWebView *)wkWebView wkWebViewDelegate:(id<WKNavigationDelegate>)wkWebViewDelegate;
- (void)augmentHybridWebView;

@end
