//
//  AdtraceTrackingHelper.m
//  AdtraceExample-iWatch
//
//  Created by Uglješa Erceg on 29/04/15.
//  Copyright (c) 2015 adtrace GmbH. All rights reserved.
//

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

    // Change the log level.
    [adtraceConfig setLogLevel:ADTLogLevelVerbose];

    // Enable event buffering.
    // [adtraceConfig setEventBufferingEnabled:YES];

    // Disable MAC MD5 tracking.
    // [adtraceConfig setMacMd5TrackingEnabled:NO];

    // Set default tracker.
    // [adtraceConfig setDefaultTracker:@"{TrackerToken}"];

    // Set an attribution delegate.
    [adtraceConfig setDelegate:delegate];

    [Adtrace appDidLaunch:adtraceConfig];

    // Put the SDK in offline mode.
    // [Adtrace setOfflineMode:YES];

    // Disable the SDK.
    // [Adtrace setEnabled:NO];
}

- (void)trackSimpleEvent {
    ADTEvent *event = [ADTEvent eventWithEventToken:@"{YourEventToken}"];

    [Adtrace trackEvent:event];
}

- (void)trackRevenueEvent {
    ADTEvent *event = [ADTEvent eventWithEventToken:@"{YourEventToken}"];

    // Add revenue 15 cent of an euro.
    [event setRevenue:0.015 currency:@"EUR"];

    [Adtrace trackEvent:event];
}

- (void)trackCallbackEvent {
    ADTEvent *event = [ADTEvent eventWithEventToken:@"{YourEventToken}"];

    // Add callback parameters to this parameter.
    [event addCallbackParameter:@"key" value:@"value"];

    [Adtrace trackEvent:event];
}

- (void)trackPartnerEvent {
    ADTEvent *event = [ADTEvent eventWithEventToken:@"{YourEventToken}"];

    // Add partner parameteres to all events and sessions.
    [event addPartnerParameter:@"foo" value:@"bar"];

    [Adtrace trackEvent:event];
}

@end
