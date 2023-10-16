







#import "Constants.h"
#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSString *appToken = kAppToken;
    NSString *environment = ADTEnvironmentSandbox;
    ADTConfig *adtraceConfig = [ADTConfig configWithAppToken:appToken environment:environment];

    
    [adtraceConfig setLogLevel:ADTLogLevelVerbose];

    
    

    
    

    
    

    
    [adtraceConfig setDelegate:self];

    
    

    
    [Adtrace addSessionCallbackParameter:@"sp_foo" value:@"sp_bar"];
    [Adtrace addSessionCallbackParameter:@"sp_key" value:@"sp_value"];

    
    [Adtrace addSessionPartnerParameter:@"sp_foo" value:@"sp_bar"];
    [Adtrace addSessionPartnerParameter:@"sp_key" value:@"sp_value"];

    
    [Adtrace removeSessionCallbackParameter:@"sp_key"];

    
    [Adtrace removeSessionPartnerParameter:@"sp_foo"];

    
    

    
    

    
    [Adtrace appDidLaunch:adtraceConfig];

    
    

    
    

    
    
    
    
    if (@available(iOS 14, *)) {
        [Adtrace requestTrackingAuthorizationWithCompletionHandler:^(NSUInteger status) {
            
        }];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"Scheme based deep link opened an app: %@", url);
    
    [Adtrace appWillOpenUrl:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> *restorableObjects))restorationHandler {
    if ([[userActivity activityType] isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        NSLog(@"Universal link opened an app: %@", [userActivity webpageURL]);
        
        [Adtrace appWillOpenUrl:[userActivity webpageURL]];
    }
    return YES;
}

- (void)adtraceAttributionChanged:(ADTAttribution *)attribution {
    NSLog(@"Attribution callback called!");
    NSLog(@"Attribution: %@", attribution);
}

- (void)adtraceEventTrackingSucceeded:(ADTEventSuccess *)eventSuccessResponseData {
    NSLog(@"Event success callback called!");
    NSLog(@"Event success data: %@", eventSuccessResponseData);
}

- (void)adtraceEventTrackingFailed:(ADTEventFailure *)eventFailureResponseData {
    NSLog(@"Event failure callback called!");
    NSLog(@"Event failure data: %@", eventFailureResponseData);
}

- (void)adtraceSessionTrackingSucceeded:(ADTSessionSuccess *)sessionSuccessResponseData {
    NSLog(@"Session success callback called!");
    NSLog(@"Session success data: %@", sessionSuccessResponseData);
}

- (void)adtraceSessionTrackingFailed:(ADTSessionFailure *)sessionFailureResponseData {
    NSLog(@"Session failure callback called!");
    NSLog(@"Session failure data: %@", sessionFailureResponseData);
}

- (BOOL)adtraceDeeplinkResponse:(NSURL *)deeplink {
    NSLog(@"Deferred deep link callback called!");
    NSLog(@"Deferred deep link URL: %@", [deeplink absoluteString]);
    
    
    
    return YES;
}

- (void)adtraceConversionValueUpdated:(NSNumber *)conversionValue {
    NSLog(@"Conversion value updated callback called!");
    NSLog(@"Conversion value: %@", conversionValue);
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
