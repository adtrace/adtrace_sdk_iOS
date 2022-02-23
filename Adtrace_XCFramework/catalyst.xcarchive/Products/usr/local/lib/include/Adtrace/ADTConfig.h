







#import <Foundation/Foundation.h>

#import "ADTLogger.h"
#import "ADTAttribution.h"
#import "ADTEventSuccess.h"
#import "ADTEventFailure.h"
#import "ADTSessionSuccess.h"
#import "ADTSessionFailure.h"


@protocol AdtraceDelegate

@optional


- (void)adtraceAttributionChanged:(nullable ADTAttribution *)attribution;


- (void)adtraceEventTrackingSucceeded:(nullable ADTEventSuccess *)eventSuccessResponseData;


- (void)adtraceEventTrackingFailed:(nullable ADTEventFailure *)eventFailureResponseData;


- (void)adtraceSessionTrackingSucceeded:(nullable ADTSessionSuccess *)sessionSuccessResponseData;


- (void)adtraceSessionTrackingFailed:(nullable ADTSessionFailure *)sessionFailureResponseData;


- (BOOL)adtraceDeeplinkResponse:(nullable NSURL *)deeplink;


- (void)adtraceConversionValueUpdated:(nullable NSNumber *)conversionValue;

@end


@interface ADTConfig : NSObject<NSCopying>


@property (nonatomic, copy, nullable) NSString *sdkPrefix;


@property (nonatomic, copy, nullable) NSString *defaultTracker;

@property (nonatomic, copy, nullable) NSString *externalDeviceId;


@property (nonatomic, copy, readonly, nonnull) NSString *appToken;


@property (nonatomic, copy, readonly, nonnull) NSString *environment;


@property (nonatomic, assign) ADTLogLevel logLevel;


@property (nonatomic, assign) BOOL eventBufferingEnabled;


@property (nonatomic, weak, nullable) NSObject<AdtraceDelegate> *delegate;


@property (nonatomic, assign) BOOL sendInBackground;


@property (nonatomic, assign) BOOL allowiAdInfoReading;


@property (nonatomic, assign) BOOL allowAdServicesInfoReading;


@property (nonatomic, assign) BOOL allowIdfaReading;


@property (nonatomic, assign) double delayStart;


@property (nonatomic, copy, nullable) NSString *userAgent;


@property (nonatomic, assign) BOOL isDeviceKnown;


@property (nonatomic, assign) BOOL needsCost;


@property (nonatomic, copy, readonly, nullable) NSString *secretId;


@property (nonatomic, copy, readonly, nullable) NSString *appSecret;


- (void)setAppSecret:(NSUInteger)secretId
               info1:(NSUInteger)info1
               info2:(NSUInteger)info2
               info3:(NSUInteger)info3
               info4:(NSUInteger)info4;


@property (nonatomic, assign, readonly) BOOL isSKAdNetworkHandlingActive;

- (void)deactivateSKAdNetworkHandling;


@property (nonatomic, copy, readwrite, nullable) NSString *urlStrategy;


+ (nullable ADTConfig *)configWithAppToken:(nonnull NSString *)appToken
                               environment:(nonnull NSString *)environment;

- (nullable id)initWithAppToken:(nonnull NSString *)appToken
                    environment:(nonnull NSString *)environment;


+ (nullable ADTConfig *)configWithAppToken:(nonnull NSString *)appToken
                               environment:(nonnull NSString *)environment
                     allowSuppressLogLevel:(BOOL)allowSuppressLogLevel;

- (nullable id)initWithAppToken:(nonnull NSString *)appToken
                    environment:(nonnull NSString *)environment
          allowSuppressLogLevel:(BOOL)allowSuppressLogLevel;


- (BOOL)isValid;

@end
