







#import <Foundation/Foundation.h>

@class AdtraceDelegate;

@interface AdtraceTrackingHelper : NSObject

+ (id)sharedInstance;

- (void)initialize:(NSObject<AdtraceDelegate> *)delegate;

- (void)trackSimpleEvent;
- (void)trackRevenueEvent;
- (void)trackCallbackEvent;
- (void)trackEventValue;

@end
