







#import "AppDelegate.h"
#import "AdtraceLoggingHelper.h"
#import "AdtraceTrackingHelper.h"
#import <WatchConnectivity/WatchConnectivity.h>

@interface AppDelegate () <WCSessionDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[AdtraceTrackingHelper sharedInstance] initialize:self];
    [[AdtraceLoggingHelper sharedInstance] logText:@"Method ""didFinishLaunchingWithOptions"" finished!"];

    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [Adtrace appWillOpenUrl:url];

    return YES;
}

- (void)adtraceAttributionChanged:(ADTAttribution *)attribution {
    NSLog(@"adtrace attribution %@", attribution);
}

- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler {
    if ([[message objectForKey:@"request"] isEqualToString:@"event_simple"]) {
        NSLog(@"Received request from Apple Watch to track simple event.");

        [[AdtraceTrackingHelper sharedInstance] trackSimpleEvent];

        NSDictionary *response = @{@"response" : @"ack"};
        replyHandler(response);

        [[AdtraceLoggingHelper sharedInstance] logText:@"Simple event tracked!"];
    } else if ([[message objectForKey:@"request"] isEqualToString:@"event_revenue"]) {
        NSLog(@"Received request from Apple Watch to track revenue event.");

        [[AdtraceTrackingHelper sharedInstance] trackRevenueEvent];

        NSDictionary *response = @{@"response" : @"ack"};
        replyHandler(response);

        [[AdtraceLoggingHelper sharedInstance] logText:@"Revenue event tracked!"];
    } else if ([[message objectForKey:@"request"] isEqualToString:@"event_callback"]) {
        NSLog(@"Received request from Apple Watch to track simple event.");

        [[AdtraceTrackingHelper sharedInstance] trackCallbackEvent];

        NSDictionary *response = @{@"response" : @"ack"};
        replyHandler(response);

        [[AdtraceLoggingHelper sharedInstance] logText:@"Callback event tracked!"];
    } else if ([[message objectForKey:@"request"] isEqualToString:@"event_partner"]) {
        NSLog(@"Received request from Apple Watch to track simple event.");

        [[AdtraceTrackingHelper sharedInstance] trackEventValue];

        NSDictionary *response = @{@"response" : @"ack"};
        replyHandler(response);

        [[AdtraceLoggingHelper sharedInstance] logText:@"Event value tracked!"];
    }
}


/*
- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void (^)(NSDictionary *))reply {
    if ([[userInfo objectForKey:@"request"] isEqualToString:@"event_simple"]) {
        NSLog(@"Received request from Apple Watch to track simple event.");

        [[AdtraceTrackingHelper sharedInstance] trackSimpleEvent];

        NSDictionary *response = @{@"response" : @"ack"};
        reply(response);

        [[AdtraceLoggingHelper sharedInstance] logText:@"Simple event tracked!"];
    } else if ([[userInfo objectForKey:@"request"] isEqualToString:@"event_revenue"]) {
        NSLog(@"Received request from Apple Watch to track revenue event.");

        [[AdtraceTrackingHelper sharedInstance] trackRevenueEvent];

        NSDictionary *response = @{@"response" : @"ack"};
        reply(response);

        [[AdtraceLoggingHelper sharedInstance] logText:@"Revenue event tracked!"];
    } else if ([[userInfo objectForKey:@"request"] isEqualToString:@"event_callback"]) {
        NSLog(@"Received request from Apple Watch to track simple event.");

        [[AdtraceTrackingHelper sharedInstance] trackCallbackEvent];

        NSDictionary *response = @{@"response" : @"ack"};
        reply(response);

        [[AdtraceLoggingHelper sharedInstance] logText:@"Callback event tracked!"];
    } else if ([[userInfo objectForKey:@"request"] isEqualToString:@"event_partner"]) {
        NSLog(@"Received request from Apple Watch to track simple event.");

        [[AdtraceTrackingHelper sharedInstance] trackPartnerEvent];

        NSDictionary *response = @{@"response" : @"ack"};
        reply(response);
        
        [[AdtraceLoggingHelper sharedInstance] logText:@"Partner event tracked!"];
    }
}
 */

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
