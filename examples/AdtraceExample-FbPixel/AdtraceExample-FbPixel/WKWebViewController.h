
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

#import "AdtraceBridge.h"

@interface WKWebViewController : UIViewController

@property AdtraceBridge *adtraceBridge;
@property JSContext *jsContext;

@end
