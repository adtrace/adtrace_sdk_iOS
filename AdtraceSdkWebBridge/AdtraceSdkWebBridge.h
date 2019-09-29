//
//  AdtraceSdkWebBridge.h
//  AdtraceSdkWebBridge
//
//  Created by Uglješa Erceg (@uerceg) on 27th July 2018.
//  Copyright © 2018 Adtrace GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for AdtraceSdkWebBridge.
FOUNDATION_EXPORT double AdtraceSdkWebBridgeVersionNumber;

//! Project version string for AdtraceSdkWebBridge.
FOUNDATION_EXPORT const unsigned char AdtraceSdkWebBridgeVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <AdtraceSdkWebBridge/PublicHeader.h>

#import <AdtraceSdkWebBridge/Adtrace.h>
#import <AdtraceSdkWebBridge/AdtraceBridge.h>
#import <AdtraceSdkWebBridge/ADTEvent.h>
#import <AdtraceSdkWebBridge/ADTConfig.h>
#import <AdtraceSdkWebBridge/ADTLogger.h>
#import <AdtraceSdkWebBridge/ADTAttribution.h>
#import <AdtraceSdkWebBridge/ADTEventSuccess.h>
#import <AdtraceSdkWebBridge/ADTEventFailure.h>
#import <AdtraceSdkWebBridge/ADTSessionSuccess.h>
#import <AdtraceSdkWebBridge/ADTSessionFailure.h>

// Exposing entire WebViewJavascriptBridge framework
#import <AdtraceSdkWebBridge/WebViewJavascriptBridge_JS.h>
#import <AdtraceSdkWebBridge/WebViewJavascriptBridgeBase.h>
#import <AdtraceSdkWebBridge/WKWebViewJavascriptBridge.h>
