//
//  WKWebViewController.h
//  AdtraceExample-WebView
//
//  Created by Uglješa Erceg on 31/05/16.
//  Copyright © 2016 adtrace GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

#import "AdtraceBridge.h"

@interface WKWebViewController : UINavigationController<WKNavigationDelegate>

@property AdtraceBridge *adtraceBridge;

@end
