
#import "Constants.h"
#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Configure adtrace SDK.
    NSString *yourAppToken = kAppToken;
    NSString *environment = ADTEnvironmentSandbox;
    ADTConfig *adtraceConfig = [ADTConfig configWithAppToken:yourAppToken environment:environment];
    
    // Change the log level.
    [adtraceConfig setLogLevel:ADTLogLevelVerbose];
    
    // Enable event buffering.
    // [adtraceConfig setEventBufferingEnabled:YES];
    
    // Set default tracker.
    // [adtraceConfig setDefaultTracker:@"{TrackerToken}"];
    
    // Send in the background.
    [adtraceConfig setSendInBackground:YES];
    
    // Add session callback parameters.
    [Adtrace addSessionCallbackParameter:@"sp_foo" value:@"sp_bar"];
    [Adtrace addSessionCallbackParameter:@"sp_key" value:@"sp_value"];
    
    // Add session partner parameters.
    [Adtrace addSessionPartnerParameter:@"sp_foo" value:@"sp_bar"];
    [Adtrace addSessionPartnerParameter:@"sp_key" value:@"sp_value"];
    
    // Remove session callback parameter.
    [Adtrace removeSessionCallbackParameter:@"sp_key"];
    
    // Remove session partner parameter.
    [Adtrace removeSessionPartnerParameter:@"sp_foo"];
    
    // Remove all session callback parameters.
    // [Adtrace resetSessionCallbackParameters];
    
    // Remove all session partner parameters.
    // [Adtrace resetSessionPartnerParameters];
    
    // Set an attribution delegate.
    [adtraceConfig setDelegate:self];
    
    // Delay the first session of the SDK.
    // [adtraceConfig setDelayStart:7];
    
    // Initialise the SDK.
    [Adtrace appDidLaunch:adtraceConfig];
    
    // Put the SDK in offline mode.
    // [Adtrace setOfflineMode:YES];
    
    // Disable the SDK.
    // [Adtrace setEnabled:NO];
    
    // Interrupt delayed start set with setDelayStart: method.
    // [Adtrace sendFirstPackages];
    
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

// Evaluate deeplink to be launched.
- (BOOL)adtraceDeeplinkResponse:(NSURL *)deeplink {
    NSLog(@"Deferred deep link callback called!");
    NSLog(@"Deferred deep link URL: %@", [deeplink absoluteString]);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
