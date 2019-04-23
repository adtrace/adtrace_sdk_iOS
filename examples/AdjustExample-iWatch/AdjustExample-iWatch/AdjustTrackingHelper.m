//
//  AdjustTrackingHelper.m
//  AdjustExample-iWatch
//
//  Created by Uglješa Erceg on 29/04/15.
//  Copyright (c) 2015 adjust GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Adtrace.h"
#import "AdjustTrackingHelper.h"

@implementation AdjustTrackingHelper

+ (id)sharedInstance {
    static AdjustTrackingHelper *sharedHelper = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedHelper = [[self alloc] init];
    });

    return sharedHelper;
}

- (void)initialize:(NSObject<AdjustDelegate> *)delegate {
    NSString *yourAppToken = @"{YourAppToken}";
    NSString *environment = ADJEnvironmentSandbox;
    ADJConfig *adjustConfig = [ADJConfig configWithAppToken:yourAppToken environment:environment];

    // Change the log level.
    [adjustConfig setLogLevel:ADJLogLevelVerbose];

    // Enable event buffering.
    // [adjustConfig setEventBufferingEnabled:YES];

    // Disable MAC MD5 tracking.
    // [adjustConfig setMacMd5TrackingEnabled:NO];

    // Set default tracker.
    // [adjustConfig setDefaultTracker:@"{TrackerToken}"];

    // Set an attribution delegate.
    [adjustConfig setDelegate:delegate];

    [Adtrace appDidLaunch:adjustConfig];

    // Put the SDK in offline mode.
    // [Adjust setOfflineMode:YES];

    // Disable the SDK.
    // [Adjust setEnabled:NO];
}

- (void)trackSimpleEvent {
    ADJEvent *event = [ADJEvent eventWithEventToken:@"{YourEventToken}"];

    [Adtrace trackEvent:event];
}

- (void)trackRevenueEvent {
    ADJEvent *event = [ADJEvent eventWithEventToken:@"{YourEventToken}"];

    // Add revenue 15 cent of an euro.
    [event setRevenue:0.015 currency:@"EUR"];

    [Adtrace trackEvent:event];
}

- (void)trackCallbackEvent {
    ADJEvent *event = [ADJEvent eventWithEventToken:@"{YourEventToken}"];

    // Add callback parameters to this parameter.
    [event addCallbackParameter:@"key" value:@"value"];

    [Adtrace trackEvent:event];
}

- (void)trackPartnerEvent {
    ADJEvent *event = [ADJEvent eventWithEventToken:@"{YourEventToken}"];

    // Add partner parameteres to all events and sessions.
    [event addPartnerParameter:@"foo" value:@"bar"];

    [Adtrace trackEvent:event];
}

@end
