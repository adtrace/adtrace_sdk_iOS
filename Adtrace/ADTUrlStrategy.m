







#import "ADTUrlStrategy.h"
#import "Adtrace.h"
#import "ADTAdtraceFactory.h"
// todo: base url
static NSString * const baseUrl = @"https://app.adtrace.io";
static NSString * const gdprUrl = @"https://gdpr.adtrace.io";
static NSString * const subscriptionUrl = @"https://subscription.adtrace.io";

static NSString * const baseUrlIndia = @"https://app.in.adtrace.io";
static NSString * const gdprUrlIndia = @"https://gdpr.in.adtrace.io";
static NSString * const subscritionUrlIndia = @"https://subscription.in.adtrace.io";

static NSString * const baseUrlUAE = @"https://app.ua.adtrace.io";
static NSString * const gdprUrlUAE = @"https://gdpr.ua.adtrace.io";
static NSString * const subscritionUrlUAE = @"https://subscription.ua.adtrace.io";

static NSString * const baseUrlFailOverIR = @"https://app.foir.adtrace.io";
static NSString * const gdprUrlFailOverIR = @"https://gdpr.foir.adtrace.io";
static NSString * const subscriptionUrlFailOverIR = @"https://subscription.foir.adtrace.io";

static NSString * const baseUrlTR = @"https://app.tr.adtrace.io";
static NSString * const gdprUrlTR = @"https://gdpr.tr.adtrace.io";
static NSString * const subscriptionUrlTR = @"https://subscription.tr.adtrace.io";

static NSString * const baseUrlQatar = @"https://app.qa.adtrace.io";
static NSString * const gdprUrlQatar = @"https://gdpr.qa.adtrace.io";
static NSString * const subscriptionUrlQatar = @"https://subscription.qa.adtrace.io";

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

+ (NSArray<NSString *> *)baseUrlChoicesWithWithUrlStrategyInfo:(NSString *)urlStrategyInfo {
    if ([urlStrategyInfo isEqualToString:ADTUrlStrategyIndia]) {
        return @[baseUrlIndia, baseUrl];
    } else if ([urlStrategyInfo isEqualToString:ADTUrlStrategyChina]) {
        return @[baseUrlUAE, baseUrl];
    } else if ([urlStrategyInfo isEqualToString:ADTDataResidencyEU]) {
        return @[baseUrlFailOverIR];
    } else if ([urlStrategyInfo isEqualToString:ADTDataResidencyTR]) {
        return @[baseUrlTR];
    } else if ([urlStrategyInfo isEqualToString:ADTDataResidencyUS]) {
        return @[baseUrlQatar];
    } else {
        return @[baseUrl, baseUrlIndia, baseUrlUAE];
    }
}

+ (NSArray<NSString *> *)gdprUrlChoicesWithWithUrlStrategyInfo:(NSString *)urlStrategyInfo {
    if ([urlStrategyInfo isEqualToString:ADTUrlStrategyIndia]) {
        return @[gdprUrlIndia, gdprUrl];
    } else if ([urlStrategyInfo isEqualToString:ADTUrlStrategyChina]) {
        return @[gdprUrlUAE, gdprUrl];
    } else if ([urlStrategyInfo isEqualToString:ADTDataResidencyEU]) {
        return @[gdprUrlFailOverIR];
    } else if ([urlStrategyInfo isEqualToString:ADTDataResidencyTR]) {
        return @[gdprUrlTR];
    } else if ([urlStrategyInfo isEqualToString:ADTDataResidencyUS]) {
        return @[gdprUrlQatar];
    } else {
        return @[gdprUrl, gdprUrlIndia, gdprUrlUAE];
    }
}

+ (NSArray<NSString *> *)subscriptionUrlChoicesWithWithUrlStrategyInfo:(NSString *)urlStrategyInfo {
    if ([urlStrategyInfo isEqualToString:ADTUrlStrategyIndia]) {
        return @[subscritionUrlIndia, subscriptionUrl];
    } else if ([urlStrategyInfo isEqualToString:ADTUrlStrategyChina]) {
        return @[subscritionUrlUAE, subscriptionUrl];
    } else if ([urlStrategyInfo isEqualToString:ADTDataResidencyEU]) {
        return @[subscriptionUrlFailOverIR];
    } else if ([urlStrategyInfo isEqualToString:ADTDataResidencyTR]) {
        return @[subscriptionUrlTR];
    } else if ([urlStrategyInfo isEqualToString:ADTDataResidencyUS]) {
        return @[subscriptionUrlQatar];
    } else {
        return @[subscriptionUrl, subscritionUrlIndia, subscritionUrlUAE];
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

- (BOOL)shouldRetryAfterFailure:(ADTActivityKind)activityKind {
    self.wasLastAttemptSuccess = NO;

    NSUInteger choiceListSize;
    if (activityKind == ADTActivityKindGdpr) {
        choiceListSize = [_gdprUrlChoicesArray count];
    } else if (activityKind == ADTActivityKindSubscription) {
        choiceListSize = [_subscriptionUrlChoicesArray count];
    } else {
        choiceListSize = [_baseUrlChoicesArray count];
    }

    NSUInteger nextChoiceIndex = (self.choiceIndex + 1) % choiceListSize;
    self.choiceIndex = nextChoiceIndex;

    BOOL nextChoiceHasNotReturnedToStartingChoice = self.choiceIndex != self.startingChoiceIndex;
    return nextChoiceHasNotReturnedToStartingChoice;
}

@end
