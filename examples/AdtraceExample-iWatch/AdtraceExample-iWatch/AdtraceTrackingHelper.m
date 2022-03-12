







#import <UIKit/UIKit.h>

#import "Adtrace.h"
#import "AdtraceTrackingHelper.h"

@implementation AdtraceTrackingHelper

+ (id)sharedInstance {
    static AdtraceTrackingHelper *sharedHelper = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedHelper = [[self alloc] init];
    });

    return sharedHelper;
}

- (void)initialize:(NSObject<AdtraceDelegate> *)delegate {
    NSString *yourAppToken = @"{YourAppToken}";
    NSString *environment = ADTEnvironmentSandbox;
    ADTConfig *adtraceConfig = [ADTConfig configWithAppToken:yourAppToken environment:environment];

    
    [adtraceConfig setLogLevel:ADTLogLevelVerbose];

    
    

    
    

    
    

    
    [adtraceConfig setDelegate:delegate];

    [Adtrace appDidLaunch:adtraceConfig];

    
    

    
    
}

- (void)trackSimpleEvent {
    ADTEvent *event = [ADTEvent eventWithEventToken:@"{YourEventToken}"];

    [Adtrace trackEvent:event];
}

- (void)trackRevenueEvent {
    ADTEvent *event = [ADTEvent eventWithEventToken:@"{YourEventToken}"];

    
    [event setRevenue:0.015 currency:@"EUR"];

    [Adtrace trackEvent:event];
}

- (void)trackCallbackEvent {
    ADTEvent *event = [ADTEvent eventWithEventToken:@"{YourEventToken}"];

    
    [event addCallbackParameter:@"key" value:@"value"];

    [Adtrace trackEvent:event];
}

- (void)trackEventValue {
    ADTEvent *event = [ADTEvent eventWithEventToken:@"{YourEventToken}"];

    
    [event addEventValueParameter:@"foo" value:@"bar"];

    [Adtrace trackEvent:event];
}

@end
