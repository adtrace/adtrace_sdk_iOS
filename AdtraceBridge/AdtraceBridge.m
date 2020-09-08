//
//  AdtraceBridge.m
//  Adtrace SDK
//

#import "Adtrace.h"
// In case of erroneous import statement try with:
// #import <AdtraceSdk/Adtrace.h>
// (depends how you import the Adtrace SDK to your app)

#import "AdtraceBridge.h"
#import "ADTAdtraceFactory.h"
#import "WKWebViewJavascriptBridge.h"

@interface AdtraceBridge() <AdtraceDelegate>

@property BOOL openDeferredDeeplink;
@property (nonatomic, copy) NSString *fbPixelDefaultEventToken;
@property (nonatomic, copy) NSString *attributionCallbackName;
@property (nonatomic, copy) NSString *eventSuccessCallbackName;
@property (nonatomic, copy) NSString *eventFailureCallbackName;
@property (nonatomic, copy) NSString *sessionSuccessCallbackName;
@property (nonatomic, copy) NSString *sessionFailureCallbackName;
@property (nonatomic, copy) NSString *deferredDeeplinkCallbackName;
@property (nonatomic, strong) NSMutableDictionary *fbPixelMapping;

@end

@implementation AdtraceBridge

#pragma mark - Object lifecycle

- (id)init {
    self = [super init];
    if (self == nil) {
        return nil;
    }

    _bridgeRegister = nil;
    [self resetAdtraceBridge];
    return self;
}

- (void)resetAdtraceBridge {
    self.attributionCallbackName = nil;
    self.eventSuccessCallbackName = nil;
    self.eventFailureCallbackName = nil;
    self.sessionSuccessCallbackName = nil;
    self.sessionFailureCallbackName = nil;
    self.deferredDeeplinkCallbackName = nil;
}

#pragma mark - AdtraceDelegate methods

- (void)adtraceAttributionChanged:(ADTAttribution *)attribution {
    if (self.attributionCallbackName == nil) {
        return;
    }
    [self.bridgeRegister callHandler:self.attributionCallbackName data:[attribution dictionary]];
}

- (void)adtraceEventTrackingSucceeded:(ADTEventSuccess *)eventSuccessResponseData {
    if (self.eventSuccessCallbackName == nil) {
        return;
    }

    NSMutableDictionary *eventSuccessResponseDataDictionary = [NSMutableDictionary dictionary];
    [eventSuccessResponseDataDictionary setValue:eventSuccessResponseData.message forKey:@"message"];
    [eventSuccessResponseDataDictionary setValue:eventSuccessResponseData.timeStamp forKey:@"timestamp"];
    [eventSuccessResponseDataDictionary setValue:eventSuccessResponseData.adid forKey:@"adid"];
    [eventSuccessResponseDataDictionary setValue:eventSuccessResponseData.eventToken forKey:@"eventToken"];
    [eventSuccessResponseDataDictionary setValue:eventSuccessResponseData.callbackId forKey:@"callbackId"];

    NSString *jsonResponse = [self convertJsonDictionaryToNSString:eventSuccessResponseData.jsonResponse];
    if (jsonResponse == nil) {
        jsonResponse = @"{}";
    }
    [eventSuccessResponseDataDictionary setValue:jsonResponse forKey:@"jsonResponse"];

    [self.bridgeRegister callHandler:self.eventSuccessCallbackName data:eventSuccessResponseDataDictionary];
}

- (void)adtraceEventTrackingFailed:(ADTEventFailure *)eventFailureResponseData {
    if (self.eventFailureCallbackName == nil) {
        return;
    }

    NSMutableDictionary *eventFailureResponseDataDictionary = [NSMutableDictionary dictionary];
    [eventFailureResponseDataDictionary setValue:eventFailureResponseData.message forKey:@"message"];
    [eventFailureResponseDataDictionary setValue:eventFailureResponseData.timeStamp forKey:@"timestamp"];
    [eventFailureResponseDataDictionary setValue:eventFailureResponseData.adid forKey:@"adid"];
    [eventFailureResponseDataDictionary setValue:eventFailureResponseData.eventToken forKey:@"eventToken"];
    [eventFailureResponseDataDictionary setValue:eventFailureResponseData.callbackId forKey:@"callbackId"];
    [eventFailureResponseDataDictionary setValue:[NSNumber numberWithBool:eventFailureResponseData.willRetry] forKey:@"willRetry"];

    NSString *jsonResponse = [self convertJsonDictionaryToNSString:eventFailureResponseData.jsonResponse];
    if (jsonResponse == nil) {
        jsonResponse = @"{}";
    }
    [eventFailureResponseDataDictionary setValue:jsonResponse forKey:@"jsonResponse"];

    [self.bridgeRegister callHandler:self.eventFailureCallbackName data:eventFailureResponseDataDictionary];
}

- (void)adtraceSessionTrackingSucceeded:(ADTSessionSuccess *)sessionSuccessResponseData {
    if (self.sessionSuccessCallbackName == nil) {
        return;
    }

    NSMutableDictionary *sessionSuccessResponseDataDictionary = [NSMutableDictionary dictionary];
    [sessionSuccessResponseDataDictionary setValue:sessionSuccessResponseData.message forKey:@"message"];
    [sessionSuccessResponseDataDictionary setValue:sessionSuccessResponseData.timeStamp forKey:@"timestamp"];
    [sessionSuccessResponseDataDictionary setValue:sessionSuccessResponseData.adid forKey:@"adid"];

    NSString *jsonResponse = [self convertJsonDictionaryToNSString:sessionSuccessResponseData.jsonResponse];
    if (jsonResponse == nil) {
        jsonResponse = @"{}";
    }
    [sessionSuccessResponseDataDictionary setValue:jsonResponse forKey:@"jsonResponse"];

    [self.bridgeRegister callHandler:self.sessionSuccessCallbackName data:sessionSuccessResponseDataDictionary];
}

- (void)adtraceSessionTrackingFailed:(ADTSessionFailure *)sessionFailureResponseData {
    if (self.sessionFailureCallbackName == nil) {
        return;
    }

    NSMutableDictionary *sessionFailureResponseDataDictionary = [NSMutableDictionary dictionary];
    [sessionFailureResponseDataDictionary setValue:sessionFailureResponseData.message forKey:@"message"];
    [sessionFailureResponseDataDictionary setValue:sessionFailureResponseData.timeStamp forKey:@"timestamp"];
    [sessionFailureResponseDataDictionary setValue:sessionFailureResponseData.adid forKey:@"adid"];
    [sessionFailureResponseDataDictionary setValue:[NSNumber numberWithBool:sessionFailureResponseData.willRetry] forKey:@"willRetry"];

    NSString *jsonResponse = [self convertJsonDictionaryToNSString:sessionFailureResponseData.jsonResponse];
    if (jsonResponse == nil) {
        jsonResponse = @"{}";
    }
    [sessionFailureResponseDataDictionary setValue:jsonResponse forKey:@"jsonResponse"];

    [self.bridgeRegister callHandler:self.sessionFailureCallbackName data:sessionFailureResponseDataDictionary];
}

- (BOOL)adtraceDeeplinkResponse:(NSURL *)deeplink {
    if (self.deferredDeeplinkCallbackName) {
        [self.bridgeRegister callHandler:self.deferredDeeplinkCallbackName data:[deeplink absoluteString]];
    }
    return self.openDeferredDeeplink;
}

#pragma mark - Public methods

- (void)augmentHybridWebView {
    NSString *fbAppId = [self getFbAppId];

    if (fbAppId == nil) {
        [[ADTAdtraceFactory logger] error:@"FacebookAppID is not correctly configured in the pList"];
        return;
    }
    [_bridgeRegister augmentHybridWebView:fbAppId];
    [self registerAugmentedView];
}

- (void)loadWKWebViewBridge:(WKWebView *)wkWebView {
    [self loadWKWebViewBridge:wkWebView wkWebViewDelegate:nil];
}

- (void)loadWKWebViewBridge:(WKWebView *)wkWebView
          wkWebViewDelegate:(id<WKNavigationDelegate>)wkWebViewDelegate {
    if (self.bridgeRegister != nil) {
        // WebViewBridge already loaded.
        return;
    }

    _bridgeRegister = [[AdtraceBridgeRegister alloc] initWithWKWebView:wkWebView];
    [self.bridgeRegister setWKWebViewDelegate:wkWebViewDelegate];

    [self.bridgeRegister registerHandler:@"adtrace_appDidLaunch" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *appToken = [data objectForKey:@"appToken"];
        NSString *environment = [data objectForKey:@"environment"];
        NSString *allowSuppressLogLevel = [data objectForKey:@"allowSuppressLogLevel"];
        NSString *sdkPrefix = [data objectForKey:@"sdkPrefix"];
        NSString *defaultTracker = [data objectForKey:@"defaultTracker"];
        NSString *externalDeviceId = [data objectForKey:@"externalDeviceId"];
        NSString *logLevel = [data objectForKey:@"logLevel"];
        NSNumber *eventBufferingEnabled = [data objectForKey:@"eventBufferingEnabled"];
        NSNumber *sendInBackground = [data objectForKey:@"sendInBackground"];
        NSNumber *delayStart = [data objectForKey:@"delayStart"];
        NSString *userAgent = [data objectForKey:@"userAgent"];
        NSNumber *isDeviceKnown = [data objectForKey:@"isDeviceKnown"];
        NSNumber *allowiAdInfoReading = [data objectForKey:@"allowiAdInfoReading"];
        NSNumber *allowIdfaReading = [data objectForKey:@"allowIdfaReading"];
        NSNumber *secretId = [data objectForKey:@"secretId"];
        NSString *info1 = [data objectForKey:@"info1"];
        NSString *info2 = [data objectForKey:@"info2"];
        NSString *info3 = [data objectForKey:@"info3"];
        NSString *info4 = [data objectForKey:@"info4"];
        NSNumber *openDeferredDeeplink = [data objectForKey:@"openDeferredDeeplink"];
        NSString *fbPixelDefaultEventToken = [data objectForKey:@"fbPixelDefaultEventToken"];
        id fbPixelMapping = [data objectForKey:@"fbPixelMapping"];
        NSString *attributionCallback = [data objectForKey:@"attributionCallback"];
        NSString *eventSuccessCallback = [data objectForKey:@"eventSuccessCallback"];
        NSString *eventFailureCallback = [data objectForKey:@"eventFailureCallback"];
        NSString *sessionSuccessCallback = [data objectForKey:@"sessionSuccessCallback"];
        NSString *sessionFailureCallback = [data objectForKey:@"sessionFailureCallback"];
        NSString *deferredDeeplinkCallback = [data objectForKey:@"deferredDeeplinkCallback"];
        NSString *urlStrategy = [data objectForKey:@"urlStrategy"];

        ADTConfig *adtraceConfig;
        if ([self isFieldValid:allowSuppressLogLevel]) {
            adtraceConfig = [ADTConfig configWithAppToken:appToken environment:environment allowSuppressLogLevel:[allowSuppressLogLevel boolValue]];
        } else {
            adtraceConfig = [ADTConfig configWithAppToken:appToken environment:environment];
        }

        // No need to continue if adtrace config is not valid.
        if (![adtraceConfig isValid]) {
            return;
        }

        if ([self isFieldValid:sdkPrefix]) {
            [adtraceConfig setSdkPrefix:sdkPrefix];
        }
        if ([self isFieldValid:defaultTracker]) {
            [adtraceConfig setDefaultTracker:defaultTracker];
        }
        if ([self isFieldValid:externalDeviceId]) {
            [adtraceConfig setExternalDeviceId:externalDeviceId];
        }
        if ([self isFieldValid:logLevel]) {
            [adtraceConfig setLogLevel:[ADTLogger logLevelFromString:[logLevel lowercaseString]]];
        }
        if ([self isFieldValid:eventBufferingEnabled]) {
            [adtraceConfig setEventBufferingEnabled:[eventBufferingEnabled boolValue]];
        }
        if ([self isFieldValid:sendInBackground]) {
            [adtraceConfig setSendInBackground:[sendInBackground boolValue]];
        }
        if ([self isFieldValid:delayStart]) {
            [adtraceConfig setDelayStart:[delayStart doubleValue]];
        }
        if ([self isFieldValid:userAgent]) {
            [adtraceConfig setUserAgent:userAgent];
        }
        if ([self isFieldValid:isDeviceKnown]) {
            [adtraceConfig setIsDeviceKnown:[isDeviceKnown boolValue]];
        }
        if ([self isFieldValid:allowiAdInfoReading]) {
            [adtraceConfig setAllowiAdInfoReading:[allowiAdInfoReading boolValue]];
        }
        if ([self isFieldValid:allowIdfaReading]) {
            [adtraceConfig setAllowIdfaReading:[allowIdfaReading boolValue]];
        }
        BOOL isAppSecretDefined = [self isFieldValid:secretId]
        && [self isFieldValid:info1]
        && [self isFieldValid:info2]
        && [self isFieldValid:info3]
        && [self isFieldValid:info4];
        if (isAppSecretDefined) {
            [adtraceConfig setAppSecret:[[self fieldToNSNumber:secretId] unsignedIntegerValue]
                                 info1:[[self fieldToNSNumber:info1] unsignedIntegerValue]
                                 info2:[[self fieldToNSNumber:info2] unsignedIntegerValue]
                                 info3:[[self fieldToNSNumber:info3] unsignedIntegerValue]
                                 info4:[[self fieldToNSNumber:info4] unsignedIntegerValue]];
        }
        if ([self isFieldValid:openDeferredDeeplink]) {
            self.openDeferredDeeplink = [openDeferredDeeplink boolValue];
        }
        if ([self isFieldValid:fbPixelDefaultEventToken]) {
            self.fbPixelDefaultEventToken = fbPixelDefaultEventToken;
        }
        if ([fbPixelMapping count] > 0) {
            self.fbPixelMapping = [[NSMutableDictionary alloc] initWithCapacity:[fbPixelMapping count] / 2];
        }
        for (int i = 0; i < [fbPixelMapping count]; i += 2) {
            NSString *key = [[fbPixelMapping objectAtIndex:i] description];
            NSString *value = [[fbPixelMapping objectAtIndex:(i + 1)] description];
            [self.fbPixelMapping setObject:value forKey:key];
        }
        if ([self isFieldValid:attributionCallback]) {
            self.attributionCallbackName = attributionCallback;
        }
        if ([self isFieldValid:eventSuccessCallback]) {
            self.eventSuccessCallbackName = eventSuccessCallback;
        }
        if ([self isFieldValid:eventFailureCallback]) {
            self.eventFailureCallbackName = eventFailureCallback;
        }
        if ([self isFieldValid:sessionSuccessCallback]) {
            self.sessionSuccessCallbackName = sessionSuccessCallback;
        }
        if ([self isFieldValid:sessionFailureCallback]) {
            self.sessionFailureCallbackName = sessionFailureCallback;
        }
        if ([self isFieldValid:deferredDeeplinkCallback]) {
            self.deferredDeeplinkCallbackName = deferredDeeplinkCallback;
        }

        // Set self as delegate if any callback is configured.
        // Change to swizzle the methods in the future.
        if (self.attributionCallbackName != nil
            || self.eventSuccessCallbackName != nil
            || self.eventFailureCallbackName != nil
            || self.sessionSuccessCallbackName != nil
            || self.sessionFailureCallbackName != nil
            || self.deferredDeeplinkCallbackName != nil) {
            [adtraceConfig setDelegate:self];
        }
        if ([self isFieldValid:urlStrategy]) {
            [adtraceConfig setUrlStrategy:urlStrategy];
        }

        [Adtrace appDidLaunch:adtraceConfig];
        [Adtrace trackSubsessionStart];
    }];

    [self.bridgeRegister registerHandler:@"adtrace_trackEvent" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *eventToken = [data objectForKey:@"eventToken"];
        NSString *revenue = [data objectForKey:@"revenue"];
        NSString *currency = [data objectForKey:@"currency"];
        NSString *transactionId = [data objectForKey:@"transactionId"];
        id callbackParameters = [data objectForKey:@"callbackParameters"];
        id partnerParameters = [data objectForKey:@"partnerParameters"];
        NSString *callbackId = [data objectForKey:@"callbackId"];

        ADTEvent *adtraceEvent = [ADTEvent eventWithEventToken:eventToken];
        // No need to continue if adtrace event is not valid
        if (![adtraceEvent isValid]) {
            return;
        }

        if ([self isFieldValid:revenue] && [self isFieldValid:currency]) {
            double revenueValue = [revenue doubleValue];
            [adtraceEvent setRevenue:revenueValue currency:currency];
        }
        if ([self isFieldValid:transactionId]) {
            [adtraceEvent setTransactionId:transactionId];
        }
        for (int i = 0; i < [callbackParameters count]; i += 2) {
            NSString *key = [[callbackParameters objectAtIndex:i] description];
            NSString *value = [[callbackParameters objectAtIndex:(i + 1)] description];
            [adtraceEvent addCallbackParameter:key value:value];
        }
        for (int i = 0; i < [partnerParameters count]; i += 2) {
            NSString *key = [[partnerParameters objectAtIndex:i] description];
            NSString *value = [[partnerParameters objectAtIndex:(i + 1)] description];
            [adtraceEvent addPartnerParameter:key value:value];
        }
        if ([self isFieldValid:callbackId]) {
            [adtraceEvent setCallbackId:callbackId];
        }

        [Adtrace trackEvent:adtraceEvent];
    }];

    [self.bridgeRegister registerHandler:@"adtrace_trackSubsessionStart" handler:^(id data, WVJBResponseCallback responseCallback) {
        [Adtrace trackSubsessionStart];
    }];

    [self.bridgeRegister registerHandler:@"adtrace_trackSubsessionEnd" handler:^(id data, WVJBResponseCallback responseCallback) {
        [Adtrace trackSubsessionEnd];
    }];

    [self.bridgeRegister registerHandler:@"adtrace_setEnabled" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (![data isKindOfClass:[NSNumber class]]) {
            return;
        }
        [Adtrace setEnabled:[(NSNumber *)data boolValue]];
    }];

    [self.bridgeRegister registerHandler:@"adtrace_isEnabled" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (responseCallback == nil) {
            return;
        }
        responseCallback([NSNumber numberWithBool:[Adtrace isEnabled]]);
    }];

    [self.bridgeRegister registerHandler:@"adtrace_appWillOpenUrl" handler:^(id data, WVJBResponseCallback responseCallback) {
        [Adtrace appWillOpenUrl:[NSURL URLWithString:data]];
    }];

    [self.bridgeRegister registerHandler:@"adtrace_setDeviceToken" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (![data isKindOfClass:[NSString class]]) {
            return;
        }
        [Adtrace setPushToken:(NSString *)data];
    }];

    [self.bridgeRegister registerHandler:@"adtrace_setOfflineMode" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (![data isKindOfClass:[NSNumber class]]) {
            return;
        }
        [Adtrace setOfflineMode:[(NSNumber *)data boolValue]];
    }];

    [self.bridgeRegister registerHandler:@"adtrace_sdkVersion" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (responseCallback == nil) {
            return;
        }

        NSString *sdkPrefix = (NSString *)data;
        NSString *sdkVersion = [NSString stringWithFormat:@"%@@%@", sdkPrefix, [Adtrace sdkVersion]];
        responseCallback(sdkVersion);
    }];

    [self.bridgeRegister registerHandler:@"adtrace_idfa" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (responseCallback == nil) {
            return;
        }
        responseCallback([Adtrace idfa]);
    }];

    [self.bridgeRegister registerHandler:@"adtrace_adid" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (responseCallback == nil) {
            return;
        }
        responseCallback([Adtrace adid]);
    }];

    [self.bridgeRegister registerHandler:@"adtrace_attribution" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (responseCallback == nil) {
            return;
        }

        ADTAttribution *attribution = [Adtrace attribution];
        NSDictionary *attributionDictionary = nil;
        if (attribution != nil) {
            attributionDictionary = [attribution dictionary];
        }

        responseCallback(attributionDictionary);
    }];

    [self.bridgeRegister registerHandler:@"adtrace_sendFirstPackages" handler:^(id data, WVJBResponseCallback responseCallback) {
        [Adtrace sendFirstPackages];
    }];

    [self.bridgeRegister registerHandler:@"adtrace_addSessionCallbackParameter" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *key = [data objectForKey:@"key"];
        NSString *value = [data objectForKey:@"value"];
        [Adtrace addSessionCallbackParameter:key value:value];
    }];

    [self.bridgeRegister registerHandler:@"adtrace_addSessionPartnerParameter" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *key = [data objectForKey:@"key"];
        NSString *value = [data objectForKey:@"value"];
        [Adtrace addSessionPartnerParameter:key value:value];
    }];

    [self.bridgeRegister registerHandler:@"adtrace_removeSessionCallbackParameter" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (![data isKindOfClass:[NSString class]]) {
            return;
        }
        [Adtrace removeSessionCallbackParameter:(NSString *)data];
    }];

    [self.bridgeRegister registerHandler:@"adtrace_removeSessionPartnerParameter" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (![data isKindOfClass:[NSString class]]) {
            return;
        }
        [Adtrace removeSessionPartnerParameter:(NSString *)data];
    }];

    [self.bridgeRegister registerHandler:@"adtrace_resetSessionCallbackParameters" handler:^(id data, WVJBResponseCallback responseCallback) {
        [Adtrace resetSessionCallbackParameters];
    }];

    [self.bridgeRegister registerHandler:@"adtrace_resetSessionPartnerParameters" handler:^(id data, WVJBResponseCallback responseCallback) {
        [Adtrace resetSessionPartnerParameters];
    }];

    [self.bridgeRegister registerHandler:@"adtrace_gdprForgetMe" handler:^(id data, WVJBResponseCallback responseCallback) {
        [Adtrace gdprForgetMe];
    }];
    
    [self.bridgeRegister registerHandler:@"adtrace_trackAdRevenue" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *source = [data objectForKey:@"source"];
        NSString *payload = [data objectForKey:@"payload"];
        NSData *dataPayload = [payload dataUsingEncoding:NSUTF8StringEncoding];
        [Adtrace trackAdRevenue:source payload:dataPayload];
    }];
    
    [self.bridgeRegister registerHandler:@"adtrace_disableThirdPartySharing" handler:^(id data, WVJBResponseCallback responseCallback) {
        [Adtrace disableThirdPartySharing];
    }];

    [self.bridgeRegister registerHandler:@"adtrace_setTestOptions" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *baseUrl = [data objectForKey:@"baseUrl"];
        NSString *gdprUrl = [data objectForKey:@"gdprUrl"];
        NSString *extraPath = [data objectForKey:@"extraPath"];
        NSNumber *timerIntervalInMilliseconds = [data objectForKey:@"timerIntervalInMilliseconds"];
        NSNumber *timerStartInMilliseconds = [data objectForKey:@"timerStartInMilliseconds"];
        NSNumber *sessionIntervalInMilliseconds = [data objectForKey:@"sessionIntervalInMilliseconds"];
        NSNumber *subsessionIntervalInMilliseconds = [data objectForKey:@"subsessionIntervalInMilliseconds"];
        NSNumber *teardown = [data objectForKey:@"teardown"];
        NSNumber *deleteState = [data objectForKey:@"deleteState"];
        NSNumber *noBackoffWait = [data objectForKey:@"noBackoffWait"];
        NSNumber *iAdFrameworkEnabled = [data objectForKey:@"iAdFrameworkEnabled"];

        AdtraceTestOptions *testOptions = [[AdtraceTestOptions alloc] init];

        if ([self isFieldValid:baseUrl]) {
            testOptions.baseUrl = baseUrl;
        }
        if ([self isFieldValid:gdprUrl]) {
            testOptions.gdprUrl = gdprUrl;
        }
        if ([self isFieldValid:extraPath]) {
            testOptions.extraPath = extraPath;
        }
        if ([self isFieldValid:timerIntervalInMilliseconds]) {
            testOptions.timerIntervalInMilliseconds = timerIntervalInMilliseconds;
        }
        if ([self isFieldValid:timerStartInMilliseconds]) {
            testOptions.timerStartInMilliseconds = timerStartInMilliseconds;
        }
        if ([self isFieldValid:sessionIntervalInMilliseconds]) {
            testOptions.sessionIntervalInMilliseconds = sessionIntervalInMilliseconds;
        }
        if ([self isFieldValid:subsessionIntervalInMilliseconds]) {
            testOptions.subsessionIntervalInMilliseconds = subsessionIntervalInMilliseconds;
        }
        if ([self isFieldValid:teardown]) {
            testOptions.teardown = [teardown boolValue];
            if (testOptions.teardown) {
                [self resetAdtraceBridge];
            }
        }
        if ([self isFieldValid:deleteState]) {
            testOptions.deleteState = [deleteState boolValue];
        }
        if ([self isFieldValid:noBackoffWait]) {
            testOptions.noBackoffWait = [noBackoffWait boolValue];
        }
        if ([self isFieldValid:iAdFrameworkEnabled]) {
            testOptions.iAdFrameworkEnabled = [iAdFrameworkEnabled boolValue];
        }

        [Adtrace setTestOptions:testOptions];
    }];

}

- (void)registerAugmentedView {
    [self.bridgeRegister registerHandler:@"adtrace_fbPixelEvent" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *pixelID = [data objectForKey:@"pixelID"];
        if (pixelID == nil) {
            [[ADTAdtraceFactory logger] error:@"Can't bridge an event without a referral Pixel ID. Check your webview Pixel configuration"];
            return;
        }
        NSString *evtName = [data objectForKey:@"evtName"];
        NSString *eventToken = [self getEventTokenFromFbPixelEventName:evtName];
        if (eventToken == nil) {
            [[ADTAdtraceFactory logger] debug:@"No mapping found for the fb pixel event %@, trying to fall back to the default event token", evtName];
            eventToken = self.fbPixelDefaultEventToken;
        }
        if (eventToken == nil) {
            [[ADTAdtraceFactory logger] debug:@"There is not a default event token configured or a mapping found for event named: '%@'. It won't be tracked as an adtrace event", evtName];
            return;
        }

        ADTEvent *fbPixelEvent = [ADTEvent eventWithEventToken:eventToken];
        if (![fbPixelEvent isValid]) {
            return;
        }

        id customData = [data objectForKey:@"customData"];
        [fbPixelEvent addPartnerParameter:@"_fb_pixel_referral_id" value:pixelID];
        // [fbPixelEvent addPartnerParameter:@"_eventName" value:evtName];
        if ([customData isKindOfClass:[NSString class]]) {
            NSError *jsonParseError = nil;
            NSDictionary *params = [NSJSONSerialization JSONObjectWithData:[customData dataUsingEncoding:NSUTF8StringEncoding]
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:&jsonParseError];
            [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                NSString *keyS = [key description];
                NSString *valueS = [obj description];
                [fbPixelEvent addPartnerParameter:keyS value:valueS];
            }];
        }
        [Adtrace trackEvent:fbPixelEvent];
    }];
}

#pragma mark - Private & helper methods

- (BOOL)isFieldValid:(NSObject *)field {
    if (field == nil) {
        return NO;
    }
    if ([field isKindOfClass:[NSNull class]]) {
        return NO;
    }
    if ([[field description] length] == 0) {
        return NO;
    }
    return !!field;
}

- (NSString *)getFbAppId {
    NSString *facebookLoggingOverrideAppID = [self getValueFromBundleByKey:@"FacebookLoggingOverrideAppID"];
    if (facebookLoggingOverrideAppID != nil) {
        return facebookLoggingOverrideAppID;
    }

    return [self getValueFromBundleByKey:@"FacebookAppID"];
}

- (NSString *)getValueFromBundleByKey:(NSString *)key {
    return [[[NSBundle mainBundle] objectForInfoDictionaryKey:key] copy];
}

- (NSString *)getEventTokenFromFbPixelEventName:(NSString *)fbPixelEventName {
    if (self.fbPixelMapping == nil) {
        return nil;
    }

    return [self.fbPixelMapping objectForKey:fbPixelEventName];
}

- (NSString *)convertJsonDictionaryToNSString:(NSDictionary *)jsonDictionary {
    if (jsonDictionary == nil) {
        return nil;
    }

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Unable to conver NSDictionary with JSON response to JSON string: %@", error);
        return nil;
    }

    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

- (NSNumber *)fieldToNSNumber:(NSObject *)field {
    if (![self isFieldValid:field]) {
        return nil;
    }
    NSNumberFormatter *formatString = [[NSNumberFormatter alloc] init];
    return [formatString numberFromString:[field description]];
}

@end
