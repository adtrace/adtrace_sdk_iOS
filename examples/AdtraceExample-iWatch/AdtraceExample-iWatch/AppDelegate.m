//
//  AppDelegate.m
//  AdtraceExample-iWatch
//
//  Created by Uglješa Erceg (@uerceg) on 6th April 2016
//  Copyright © 2016-Present Adtrace GmbH. All rights reserved.
//

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

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
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
        
        [[AdtraceTrackingHelper sharedInstance] trackPartnerEvent];
        
        NSDictionary *response = @{@"response" : @"ack"};
        replyHandler(response);
        
        [[AdtraceLoggingHelper sharedInstance] logText:@"Partner event tracked!"];
    }
}

// watchOS 1.x
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
