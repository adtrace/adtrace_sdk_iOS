//
//  ADTPackageBuilder.h
//  Adtrace
//
//  Created by Aref on 9/8/20.
//  Copyright © 2020 Adtrace. All rights reserved.
//

#import "ADTEvent.h"
#import "ADTConfig.h"
#import "ADTDeviceInfo.h"
#import "ADTActivityState.h"
#import "ADTActivityPackage.h"
#import "ADTSessionParameters.h"
#import <Foundation/Foundation.h>
#import "ADTActivityHandler.h"

@interface ADTPackageBuilder : NSObject

@property (nonatomic, copy) NSString *deeplink;

@property (nonatomic, copy) NSDate *clickTime;

@property (nonatomic, copy) NSDate *purchaseTime;

@property (nonatomic, strong) NSDictionary *attributionDetails;

@property (nonatomic, strong) NSDictionary *deeplinkParameters;

@property (nonatomic, copy) ADTAttribution *attribution;

- (id)initWithDeviceInfo:(ADTDeviceInfo *)deviceInfo
           activityState:(ADTActivityState *)activityState
                  config:(ADTConfig *)adtraceConfig
       sessionParameters:(ADTSessionParameters *)sessionParameters
   trackingStatusManager:(ADTTrackingStatusManager *)trackingStatusManager
               createdAt:(double)createdAt;

- (ADTActivityPackage *)buildSessionPackage:(BOOL)isInDelay;

- (ADTActivityPackage *)buildEventPackage:(ADTEvent *)event
                                isInDelay:(BOOL)isInDelay;

- (ADTActivityPackage *)buildInfoPackage:(NSString *)infoSource;

- (ADTActivityPackage *)buildAdRevenuePackage:(NSString *)source payload:(NSData *)payload;

- (ADTActivityPackage *)buildClickPackage:(NSString *)clickSource;

- (ADTActivityPackage *)buildAttributionPackage:(NSString *)initiatedBy;

- (ADTActivityPackage *)buildGdprPackage;

- (ADTActivityPackage *)buildDisableThirdPartySharingPackage;

- (ADTActivityPackage *)buildSubscriptionPackage:(ADTSubscription *)subscription
                                       isInDelay:(BOOL)isInDelay;

+ (void)parameters:(NSMutableDictionary *)parameters
     setDictionary:(NSDictionary *)dictionary
            forKey:(NSString *)key;

+ (void)parameters:(NSMutableDictionary *)parameters
         setString:(NSString *)value
            forKey:(NSString *)key;

+ (void)parameters:(NSMutableDictionary *)parameters
            setInt:(int)value
            forKey:(NSString *)key;

@end
