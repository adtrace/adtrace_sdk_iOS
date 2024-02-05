
#import "Constants.h"
#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Configure Adtrace SDK.
    NSString *appToken = kAppToken;
    NSString *environment = ADTEnvironmentSandbox;
    ADTConfig *adtraceConfig = [ADTConfig configWithAppToken:appToken environment:environment];
    
    // Change the log level.
    [adtraceConfig setLogLevel:ADTLogLevelVerbose];
    
    // Enable event buffering.
    // [adtraceConfig setEventBufferingEnabled:YES];
    
    // Set default tracker.
    // [adtraceConfig setDefaultTracker:@"{TrackerToken}"];
    
    // Send in the background.
    // [adtraceConfig setSendInBackground:YES];
    
    // Enable COPPA compliance.
    // [adtraceConfig setCoppaCompliantEnabled:YES];
    
    // Enable LinkMe feature.
    // [adtraceConfig setLinkMeEnabled:YES];
    
    // Set an attribution delegate.
    [adtraceConfig setDelegate:self];
    
    // Delay the first session of the SDK.
    // [adtraceConfig setDelayStart:7];
    
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

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSLog(@"Scheme based deep link opened an app: %@", url);
    // Pass deep link to Adtrace in order to potentially reattribute user.
    [Adtrace appWillOpenUrl:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> *restorableObjects))restorationHandler {
    if ([[userActivity activityType] isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        NSLog(@"Universal link opened an app: %@", [userActivity webpageURL]);
        // Pass deep link to Adtrace in order to potentially reattribute user.
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
    
    // Allow Adtrace SDK to open received deferred deep link.
    // If you don't want it to open it, return NO; instead.
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
    // Show ATT dialog.
    if (@available(iOS 14, *)) {
        [Adtrace requestTrackingAuthorizationWithCompletionHandler:^(NSUInteger status) {
            // Process user's response.
        }];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
