//
//  NSData+ADTAdditions.h
//  Adtrace
//
//  Created by Aref on 9/8/20.
//  Copyright © 2020 Adtrace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ADTActivityHandler.h"

@interface UIDevice(ADTAdditions)

- (int)adtATTStatus;
- (BOOL)adtTrackingEnabled;
- (NSString *)adtIdForAdvertisers;
- (NSString *)adtFbAnonymousId;
- (NSString *)adtDeviceType;
- (NSString *)adtDeviceName;
- (NSString *)adtCreateUuid;
- (NSString *)adtVendorId;
- (NSString *)adtDeviceId:(ADTDeviceInfo *)deviceInfo;
- (void)adtCheckForiAd:(ADTActivityHandler *)activityHandler queue:(dispatch_queue_t)queue;

- (void)requestTrackingAuthorizationWithCompletionHandler:(void (^)(NSUInteger status))completion;

@end
