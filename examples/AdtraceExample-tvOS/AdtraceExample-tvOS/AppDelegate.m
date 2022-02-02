







#import "Constants.h"
#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    

    
    NSString *yourAppToken = kAppToken;
    NSString *environment = ADTEnvironmentSandbox;
    ADTConfig *adtraceConfig = [ADTConfig configWithAppToken:yourAppToken environment:environment];
    
    
    [adtraceConfig setLogLevel:ADTLogLevelVerbose];
    
    
    
    
    
    
    
    
    [adtraceConfig setSendInBackground:YES];
    
    
    [Adtrace addSessionCallbackParameter:@"sp_foo" value:@"sp_bar"];
    [Adtrace addSessionCallbackParameter:@"sp_key" value:@"sp_value"];
    
    
    [Adtrace addSessionPartnerParameter:@"sp_foo" value:@"sp_bar"];
    [Adtrace addSessionPartnerParameter:@"sp_key" value:@"sp_value"];
    
    
    [Adtrace removeSessionCallbackParameter:@"sp_key"];
    
    
    [Adtrace removeSessionPartnerParameter:@"sp_foo"];
    
    
    
    
    
    
    
    
    [adtraceConfig setDelegate:self];
    
    
    
    
    
    [Adtrace appDidLaunch:adtraceConfig];
    
    
    
    
    
    
    
    
    

    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    [Adtrace appWillOpenUrl:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> *restorableObjects))restorationHandler {
    if ([[userActivity activityType] isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        NSLog(@"continueUserActivity method called with URL: %@", [userActivity webpageURL]);
        [Adtrace convertUniversalLink:[userActivity webpageURL] scheme:@"adtraceExample"];
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
