//
//  AdtraceTrackingHelper.h
//  AdtraceExample-iWatch
//
//  Created by Uglješa Erceg on 29/04/15.
//  Copyright (c) 2015 adtrace GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AdtraceDelegate;

@interface AdtraceTrackingHelper : NSObject

+ (id)sharedInstance;

- (void)initialize:(NSObject<AdtraceDelegate> *)delegate;

- (void)trackSimpleEvent;
- (void)trackRevenueEvent;
- (void)trackCallbackEvent;
- (void)trackPartnerEvent;

@end
