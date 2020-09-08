//
//  ADTUrlStrategy.m
//  Adtrace
//
//  Created by Aref on 9/8/20.
//  Copyright © 2020 Adtrace. All rights reserved.
//

#import "ADTUrlStrategy.h"
#import "Adtrace.h"
#import "ADTAdtraceFactory.h"

static NSString * const baseUrl = @"https://app.adtrace.io";
static NSString * const gdprUrl = @"https://gdpr.adtrace.io";
static NSString * const subscriptionUrl = @"https://subscription.adtrace.io";

static NSString * const baseUrlIndia = @"https://app.adtrace.net.in";
static NSString * const gdprUrlIndia = @"https://gdpr.adtrace.net.in";
static NSString * const subscritionUrlIndia = @"https://subscription.adtrace.net.in";

static NSString * const baseUrlChina = @"https://app.adtrace.world";
static NSString * const gdprUrlChina = @"https://gdpr.adtrace.world";
static NSString * const subscritionUrlChina = @"https://subscription.adtrace.world";

@interface ADTUrlStrategy ()

@property (nonatomic, copy) NSArray<NSString *> *baseUrlChoicesArray;
@property (nonatomic, copy) NSArray<NSString *> *gdprUrlChoicesArray;
@property (nonatomic, copy) NSArray<NSString *> *subscriptionUrlChoicesArray;

@property (nonatomic, copy) NSString *overridenBaseUrl;
@property (nonatomic, copy) NSString *overridenGdprUrl;
@property (nonatomic, copy) NSString *overridenSubscriptionUrl;

@property (nonatomic, assign) BOOL wasLastAttemptSuccess;

@property (nonatomic, assign) NSUInteger choiceIndex;
@property (nonatomic, assign) NSUInteger startingChoiceIndex;

@end

@implementation ADTUrlStrategy

- (instancetype)initWithUrlStrategyInfo:(NSString *)urlStrategyInfo
                              extraPath:(NSString *)extraPath
{
    self = [super init];

    _extraPath = extraPath ?: @"";

    _baseUrlChoicesArray = [ADTUrlStrategy baseUrlChoicesWithWithUrlStrategyInfo:urlStrategyInfo];
    _gdprUrlChoicesArray = [ADTUrlStrategy gdprUrlChoicesWithWithUrlStrategyInfo:urlStrategyInfo];
    _subscriptionUrlChoicesArray = [ADTUrlStrategy
                                    subscriptionUrlChoicesWithWithUrlStrategyInfo:urlStrategyInfo];

    _overridenBaseUrl = [ADTAdtraceFactory baseUrl];
    _overridenGdprUrl = [ADTAdtraceFactory gdprUrl];
    _overridenSubscriptionUrl = [ADTAdtraceFactory subscriptionUrl];

    _wasLastAttemptSuccess = NO;

    _choiceIndex = 0;
    _startingChoiceIndex = 0;

    return self;
}

+ (NSArray<NSString *> *)baseUrlChoicesWithWithUrlStrategyInfo:(NSString *)urlStrategyInfo
{
    if ([urlStrategyInfo isEqualToString:ADTUrlStrategyIndia]) {
        return @[baseUrlIndia, baseUrl];
    } else if ([urlStrategyInfo isEqualToString:ADTUrlStrategyChina]) {
        return @[baseUrlChina, baseUrl];
    } else {
        return @[baseUrl, baseUrlIndia, baseUrlChina];
    }
}

+ (NSArray<NSString *> *)gdprUrlChoicesWithWithUrlStrategyInfo:(NSString *)urlStrategyInfo
{
    if ([urlStrategyInfo isEqualToString:ADTUrlStrategyIndia]) {
        return @[gdprUrlIndia, gdprUrl];
    } else if ([urlStrategyInfo isEqualToString:ADTUrlStrategyChina]) {
        return @[gdprUrlChina, gdprUrl];
    } else {
        return @[gdprUrl, gdprUrlIndia, gdprUrlChina];
    }
}

+ (NSArray<NSString *> *)subscriptionUrlChoicesWithWithUrlStrategyInfo:(NSString *)urlStrategyInfo
{
    if ([urlStrategyInfo isEqualToString:ADTUrlStrategyIndia]) {
        return @[subscritionUrlIndia, subscriptionUrl];
    } else if ([urlStrategyInfo isEqualToString:ADTUrlStrategyChina]) {
        return @[subscritionUrlChina, subscriptionUrl];
    } else {
        return @[subscriptionUrl, subscritionUrlIndia, subscritionUrlChina];
    }
}

- (NSString *)getUrlHostStringByPackageKind:(ADTActivityKind)activityKind {
    if (activityKind == ADTActivityKindGdpr) {
        if (self.overridenGdprUrl != nil) {
            return self.overridenGdprUrl;
        } else {
            return [self.gdprUrlChoicesArray objectAtIndex:self.choiceIndex];
        }
    } else if (activityKind == ADTActivityKindSubscription) {
        if (self.overridenSubscriptionUrl != nil) {
            return self.overridenSubscriptionUrl;
        } else {
            return [self.subscriptionUrlChoicesArray objectAtIndex:self.choiceIndex];
        }
    } else {
        if (self.overridenBaseUrl != nil) {
            return self.overridenBaseUrl;
        } else {
            return [self.baseUrlChoicesArray objectAtIndex:self.choiceIndex];
        }
    }
}

- (void)resetAfterSuccess {
    self.startingChoiceIndex = self.choiceIndex;
    self.wasLastAttemptSuccess = YES;
}

- (BOOL)shouldRetryAfterFailure {
    NSUInteger nextChoiceIndex = (self.choiceIndex + 1) % self.baseUrlChoicesArray.count;
    self.choiceIndex = nextChoiceIndex;

    self.wasLastAttemptSuccess = NO;

    BOOL nextChoiceHasNotReturnedToStartingChoice = self.choiceIndex != self.startingChoiceIndex;
    return nextChoiceHasNotReturnedToStartingChoice;
}

@end

