
#import "ADTUrlStrategy.h"
#import "Adtrace.h"
#import "ADTAdtraceFactory.h"

static NSString * const baseUrl = @"https://app.adtrace.io";
static NSString * const gdprUrl = @"https://gdpr.adtrace.io";
static NSString * const subscriptionUrl = @"https://subscription.adtrace.io";
static NSString * const purchaseVerificationUrl = @"https://ssrv.adtrace.io";

static NSString * const baseUrlIR = @"https://app.adtrace.ir";
static NSString * const gdprUrlIR = @"https://gdpr.adtrace.ir";
static NSString * const subscriptionUrlIR = @"https://subscription.adtrace.ir";
static NSString * const purchaseVerificationUrlIR = @"https://ssrv.adtrace.ir";

static NSString * const baseUrlMobi = @"https://app.adtrace.mobi";
static NSString * const gdprUrlMobi = @"https://gdpr.adtrace.mobi";
static NSString * const subscriptionUrlMobi = @"https://subscription.adtrace.mobi";
static NSString * const purchaseVerificationUrlMobi = @"https://ssrv.adtrace.mobi";

@interface ADTUrlStrategy ()

@property (nonatomic, copy) NSArray<NSString *> *baseUrlChoicesArray;
@property (nonatomic, copy) NSArray<NSString *> *gdprUrlChoicesArray;
@property (nonatomic, copy) NSArray<NSString *> *subscriptionUrlChoicesArray;
@property (nonatomic, copy) NSArray<NSString *> *purchaseVerificationUrlChoicesArray;

@property (nonatomic, copy) NSString *overridenBaseUrl;
@property (nonatomic, copy) NSString *overridenGdprUrl;
@property (nonatomic, copy) NSString *overridenSubscriptionUrl;
@property (nonatomic, copy) NSString *overridenPurchaseVerificationUrl;

@property (nonatomic, assign) BOOL wasLastAttemptSuccess;

@property (nonatomic, assign) NSUInteger choiceIndex;
@property (nonatomic, assign) NSUInteger startingChoiceIndex;

@end

@implementation ADTUrlStrategy

- (instancetype)initWithUrlStrategyInfo:(NSString *)urlStrategyInfo
                              extraPath:(NSString *)extraPath {
    self = [super init];

    _extraPath = extraPath ?: @"";

    _baseUrlChoicesArray = [ADTUrlStrategy baseUrlChoicesWithUrlStrategyInfo:urlStrategyInfo];
    _gdprUrlChoicesArray = [ADTUrlStrategy gdprUrlChoicesWithUrlStrategyInfo:urlStrategyInfo];
    _subscriptionUrlChoicesArray = [ADTUrlStrategy
                                    subscriptionUrlChoicesWithUrlStrategyInfo:urlStrategyInfo];
    _purchaseVerificationUrlChoicesArray = [ADTUrlStrategy
                                            purchaseVerificationUrlChoicesWithUrlStrategyInfo:urlStrategyInfo];

    _overridenBaseUrl = [ADTAdtraceFactory baseUrl];
    _overridenGdprUrl = [ADTAdtraceFactory gdprUrl];
    _overridenSubscriptionUrl = [ADTAdtraceFactory subscriptionUrl];
    _overridenPurchaseVerificationUrl = [ADTAdtraceFactory purchaseVerificationUrl];

    _wasLastAttemptSuccess = NO;
    _choiceIndex = 0;
    _startingChoiceIndex = 0;

    return self;
}

+ (NSArray<NSString *> *)baseUrlChoicesWithUrlStrategyInfo:(NSString *)urlStrategyInfo {
    if ([urlStrategyInfo isEqualToString:ADTUrlStrategyIR]) {
        return @[baseUrlIR, baseUrl];
    } else if ([urlStrategyInfo isEqualToString:ADTUrlStrategyMobi]) {
        return @[baseUrlMobi, baseUrl];
    } else if ([urlStrategyInfo isEqualToString:ADTDataResidencyIR]) {
        return @[baseUrl];
    } else {
        return @[baseUrl, baseUrlIR, baseUrlMobi];
    }
}

+ (NSArray<NSString *> *)gdprUrlChoicesWithUrlStrategyInfo:(NSString *)urlStrategyInfo {
    if ([urlStrategyInfo isEqualToString:ADTUrlStrategyIR]) {
        return @[gdprUrlIR, gdprUrl];
    } else if ([urlStrategyInfo isEqualToString:ADTUrlStrategyMobi]) {
        return @[gdprUrlMobi, gdprUrl];
    } else if ([urlStrategyInfo isEqualToString:ADTDataResidencyIR]) {
        return @[gdprUrl];
    } else {
        return @[gdprUrl, gdprUrlIR, gdprUrlMobi];
    }
}

+ (NSArray<NSString *> *)subscriptionUrlChoicesWithUrlStrategyInfo:(NSString *)urlStrategyInfo {
    if ([urlStrategyInfo isEqualToString:ADTUrlStrategyIR]) {
        return @[subscriptionUrlIR, subscriptionUrl];
    } else if ([urlStrategyInfo isEqualToString:ADTUrlStrategyMobi]) {
        return @[subscriptionUrlMobi, subscriptionUrl];
    } else if ([urlStrategyInfo isEqualToString:ADTDataResidencyIR]) {
        return @[subscriptionUrl];
    } else {
        return @[subscriptionUrl, subscriptionUrlIR, subscriptionUrlMobi];
    }
}

+ (NSArray<NSString *> *)purchaseVerificationUrlChoicesWithUrlStrategyInfo:(NSString *)urlStrategyInfo {
    if ([urlStrategyInfo isEqualToString:ADTUrlStrategyIR]) {
        return @[purchaseVerificationUrlIR, purchaseVerificationUrl];
    } else if ([urlStrategyInfo isEqualToString:ADTUrlStrategyMobi]) {
        return @[purchaseVerificationUrlMobi, purchaseVerificationUrl];
    } else if ([urlStrategyInfo isEqualToString:ADTDataResidencyIR]) {
        return @[purchaseVerificationUrl];
    } else {
        return @[purchaseVerificationUrl, purchaseVerificationUrlIR, purchaseVerificationUrlMobi];
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
    } else if (activityKind == ADTActivityKindPurchaseVerification) {
        if (self.overridenPurchaseVerificationUrl != nil) {
            return self.overridenPurchaseVerificationUrl;
        } else {
            return [self.purchaseVerificationUrlChoicesArray objectAtIndex:self.choiceIndex];
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

- (BOOL)shouldRetryAfterFailure:(ADTActivityKind)activityKind {
    self.wasLastAttemptSuccess = NO;

    NSUInteger choiceListSize;
    if (activityKind == ADTActivityKindGdpr) {
        choiceListSize = [_gdprUrlChoicesArray count];
    } else if (activityKind == ADTActivityKindSubscription) {
        choiceListSize = [_subscriptionUrlChoicesArray count];
    } else if (activityKind == ADTActivityKindPurchaseVerification) {
        choiceListSize = [_purchaseVerificationUrlChoicesArray count];
    } else {
        choiceListSize = [_baseUrlChoicesArray count];
    }

    NSUInteger nextChoiceIndex = (self.choiceIndex + 1) % choiceListSize;
    self.choiceIndex = nextChoiceIndex;
    BOOL nextChoiceHasNotReturnedToStartingChoice = self.choiceIndex != self.startingChoiceIndex;

    return nextChoiceHasNotReturnedToStartingChoice;
}

@end
