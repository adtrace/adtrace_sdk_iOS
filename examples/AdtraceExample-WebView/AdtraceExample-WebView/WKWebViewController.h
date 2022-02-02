







#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

#import "AdtraceBridge.h"

@interface WKWebViewController : UINavigationController<WKNavigationDelegate, WKUIDelegate>

@property AdtraceBridge *adtraceBridge;

@end
