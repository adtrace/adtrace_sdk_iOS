//
//  AdtraceTrackingHelper.h
//  AdtraceExample-iWatch
//
//  Created by Uglješa Erceg (@uerceg) on 6th April 2016
//  Copyright © 2016-Present Adtrace GmbH. All rights reserved.
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
