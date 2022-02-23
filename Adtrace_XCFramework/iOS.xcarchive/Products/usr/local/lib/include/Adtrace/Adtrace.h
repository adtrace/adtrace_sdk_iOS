

#import "ADTEvent.h"
#import "ADTConfig.h"
#import "ADTAttribution.h"
#import "ADTSubscription.h"
#import "ADTThirdPartySharing.h"
#import "ADTAdRevenue.h"
#import "ADTLinkResolution.h"

@interface AdtraceTestOptions : NSObject

@property (nonatomic, copy, nullable) NSString *baseUrl;
@property (nonatomic, copy, nullable) NSString *gdprUrl;
@property (nonatomic, copy, nullable) NSString *subscriptionUrl;
@property (nonatomic, copy, nullable) NSString *extraPath;
@property (nonatomic, copy, nullable) NSNumber *timerIntervalInMilliseconds;
@property (nonatomic, copy, nullable) NSNumber *timerStartInMilliseconds;
@property (nonatomic, copy, nullable) NSNumber *sessionIntervalInMilliseconds;
@property (nonatomic, copy, nullable) NSNumber *subsessionIntervalInMilliseconds;
@property (nonatomic, assign) BOOL teardown;
@property (nonatomic, assign) BOOL deleteState;
@property (nonatomic, assign) BOOL noBackoffWait;
@property (nonatomic, assign) BOOL iAdFrameworkEnabled;
@property (nonatomic, assign) BOOL adServicesFrameworkEnabled;
@property (nonatomic, assign) BOOL enableSigning;
@property (nonatomic, assign) BOOL disableSigning;

@end


extern NSString * __nonnull const ADTEnvironmentSandbox;
extern NSString * __nonnull const ADTEnvironmentProduction;


extern NSString * __nonnull const ADTAdRevenueSourceAppLovinMAX;
extern NSString * __nonnull const ADTAdRevenueSourceMopub;
extern NSString * __nonnull const ADTAdRevenueSourceAdMob;
extern NSString * __nonnull const ADTAdRevenueSourceIronSource;
extern NSString * __nonnull const ADTAdRevenueSourceAdMost;


extern NSString * __nonnull const ADTUrlStrategyIndia;
extern NSString * __nonnull const ADTUrlStrategyChina;
extern NSString * __nonnull const ADTDataResidencyEU;
extern NSString * __nonnull const ADTDataResidencyTR;
extern NSString * __nonnull const ADTDataResidencyUS;


@interface Adtrace : NSObject


+ (void)appDidLaunch:(nullable ADTConfig *)adtraceConfig;


+ (void)trackEvent:(nullable ADTEvent *)event;


+ (void)trackSubsessionStart;


+ (void)trackSubsessionEnd;


+ (void)setEnabled:(BOOL)enabled;


+ (BOOL)isEnabled;


+ (void)appWillOpenUrl:(nonnull NSURL *)url;


+ (void)setDeviceToken:(nonnull NSData *)deviceToken;


+ (void)setPushToken:(nonnull NSString *)pushToken;


+ (void)setOfflineMode:(BOOL)enabled;


+ (nullable NSString *)idfa;


+ (nullable NSString *)adid;


+ (nullable ADTAttribution *)attribution;


+ (nullable NSString *)sdkVersion;


+ (nullable NSURL *)convertUniversalLink:(nonnull NSURL *)url scheme:(nonnull NSString *)scheme;


+ (void)sendFirstPackages;


+ (void)sendAdWordsRequest;


+ (void)addSessionCallbackParameter:(nonnull NSString *)key value:(nonnull NSString *)value;


+ (void)addSessionPartnerParameter:(nonnull NSString *)key value:(nonnull NSString *)value;


+ (void)removeSessionCallbackParameter:(nonnull NSString *)key;


+ (void)removeSessionPartnerParameter:(nonnull NSString *)key;


+ (void)resetSessionCallbackParameters;


+ (void)resetSessionPartnerParameters;


+ (void)gdprForgetMe;


+ (void)trackAdRevenue:(nonnull NSString *)source payload:(nonnull NSData *)payload;


+ (void)disableThirdPartySharing;


+ (void)trackThirdPartySharing:(nonnull ADTThirdPartySharing *)thirdPartySharing;


+ (void)trackMeasurementConsent:(BOOL)enabled;


+ (void)trackAdRevenue:(nonnull ADTAdRevenue *)adRevenue;


+ (void)trackSubscription:(nonnull ADTSubscription *)subscription;


+ (void)requestTrackingAuthorizationWithCompletionHandler:(void (^_Nullable)(NSUInteger status))completion;


+ (int)appTrackingAuthorizationStatus;


+ (void)updateConversionValue:(NSInteger)conversionValue;


+ (void)setTestOptions:(nullable AdtraceTestOptions *)testOptions;


+ (nullable instancetype)getInstance;

- (void)appDidLaunch:(nullable ADTConfig *)adtraceConfig;

- (void)trackEvent:(nullable ADTEvent *)event;

- (void)setEnabled:(BOOL)enabled;

- (void)teardown;

- (void)appWillOpenUrl:(nonnull NSURL *)url;

- (void)setOfflineMode:(BOOL)enabled;

- (void)setDeviceToken:(nonnull NSData *)deviceToken;

- (void)setPushToken:(nonnull NSString *)pushToken;

- (void)sendFirstPackages;

- (void)trackSubsessionEnd;

- (void)trackSubsessionStart;

- (void)resetSessionPartnerParameters;

- (void)resetSessionCallbackParameters;

- (void)removeSessionPartnerParameter:(nonnull NSString *)key;

- (void)removeSessionCallbackParameter:(nonnull NSString *)key;

- (void)addSessionPartnerParameter:(nonnull NSString *)key value:(nonnull NSString *)value;

- (void)addSessionCallbackParameter:(nonnull NSString *)key value:(nonnull NSString *)value;

- (void)gdprForgetMe;

- (void)trackAdRevenue:(nonnull NSString *)source payload:(nonnull NSData *)payload;

- (void)trackSubscription:(nonnull ADTSubscription *)subscription;

- (BOOL)isEnabled;

- (nullable NSString *)adid;

- (nullable NSString *)idfa;

- (nullable NSString *)sdkVersion;

- (nullable ADTAttribution *)attribution;

- (nullable NSURL *)convertUniversalLink:(nonnull NSURL *)url scheme:(nonnull NSString *)scheme;

- (void)requestTrackingAuthorizationWithCompletionHandler:(void (^_Nullable)(NSUInteger status))completion;

- (int)appTrackingAuthorizationStatus;

- (void)updateConversionValue:(NSInteger)conversionValue;

- (void)trackThirdPartySharing:(nonnull ADTThirdPartySharing *)thirdPartySharing;

- (void)trackMeasurementConsent:(BOOL)enabled;

- (void)trackAdRevenue:(nonnull ADTAdRevenue *)adRevenue;

@end
