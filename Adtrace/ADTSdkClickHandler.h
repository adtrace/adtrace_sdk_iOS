







#import <Foundation/Foundation.h>
#import "ADTActivityPackage.h"
#import "ADTActivityHandler.h"
#import "ADTRequestHandler.h"
#import "ADTUrlStrategy.h"

@interface ADTSdkClickHandler : NSObject <ADTResponseCallback>

- (id)initWithActivityHandler:(id<ADTActivityHandler>)activityHandler
                startsSending:(BOOL)startsSending
                    userAgent:(NSString *)userAgent
                  urlStrategy:(ADTUrlStrategy *)urlStrategy;
- (void)pauseSending;
- (void)resumeSending;
- (void)sendSdkClick:(ADTActivityPackage *)sdkClickPackage;
- (void)teardown;

@end
