//
//  ADTPackageBuilder.h
//  Adtrace SDK
//
//  Created by Christian Wellenbrock (@wellle) on 3rd July 2013.
//  Copyright (c) 2013-2018 Adtrace GmbH. All rights reserved.
//

#import "ADTEvent.h"
#import "ADTConfig.h"
#import "ADTDeviceInfo.h"
#import "ADTActivityState.h"
#import "ADTActivityPackage.h"
#import "ADTSessionParameters.h"
#import <Foundation/Foundation.h>

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
               createdAt:(double)createdAt;

- (ADTActivityPackage *)buildSessionPackage:(BOOL)isInDelay;

- (ADTActivityPackage *)buildEventPackage:(ADTEvent *)event
                                isInDelay:(BOOL)isInDelay;

- (ADTActivityPackage *)buildInfoPackage:(NSString *)infoSource;

- (ADTActivityPackage *)buildAdRevenuePackage:(NSString *)source payload:(NSData *)payload;

- (ADTActivityPackage *)buildClickPackage:(NSString *)clickSource;

- (ADTActivityPackage *)buildAttributionPackage:(NSString *)initiatedBy;

- (ADTActivityPackage *)buildGdprPackage;

+ (void)parameters:(NSMutableDictionary *)parameters
     setDictionary:(NSDictionary *)dictionary
            forKey:(NSString *)key;

+ (void)parameters:(NSMutableDictionary *)parameters
         setString:(NSString *)value
            forKey:(NSString *)key;

@end
