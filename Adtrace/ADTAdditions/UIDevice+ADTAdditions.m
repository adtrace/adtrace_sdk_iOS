//
//  UIDevice+ADTAdditions.m
//  Adtrace
//
//  Created by Aref on 9/8/20.
//  Copyright © 2020 Adtrace. All rights reserved.
//

#import "UIDevice+ADTAdditions.h"
#import "NSString+ADTAdditions.h"

#import <sys/sysctl.h>

#if !ADTUST_NO_IDFA
#import <AdSupport/ASIdentifierManager.h>
#endif

#if !ADTUST_NO_IAD && !TARGET_OS_TV
#import <iAd/iAd.h>
#endif

#import "ADTUtil.h"
#import "ADTSystemProfile.h"
#import "ADTAdtraceFactory.h"

@implementation UIDevice(ADTAdditions)

- (Class)adSupportManager {
    NSString *className = [NSString adtJoin:@"A", @"S", @"identifier", @"manager", nil];
    Class class = NSClassFromString(className);
    
    return class;
}

- (Class)appTrackingManager {
    NSString *className = [NSString adtJoin:@"A", @"T", @"tracking", @"manager", nil];
    Class class = NSClassFromString(className);
    
    return class;
}

- (int)adtATTStatus {
    Class appTrackingClass = [self appTrackingManager];
    if (appTrackingClass != nil) {
        NSString *keyAuthorization = [NSString adtJoin:@"tracking", @"authorization", @"status", nil];
        SEL selAuthorization = NSSelectorFromString(keyAuthorization);
        if ([appTrackingClass respondsToSelector:selAuthorization]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            return (int)[appTrackingClass performSelector:selAuthorization];
#pragma clang diagnostic pop
        }
    }
    
    return -1;
}

- (void)requestTrackingAuthorizationWithCompletionHandler:(void (^)(NSUInteger status))completion
{
    Class appTrackingClass = [self appTrackingManager];
    if (appTrackingClass == nil) {
        return;
    }
    NSString *requestAuthorization = [NSString adtJoin:
                                      @"request",
                                      @"tracking",
                                      @"authorization",
                                      @"with",
                                      @"completion",
                                      @"handler:", nil];
    SEL selRequestAuthorization = NSSelectorFromString(requestAuthorization);
    if (![appTrackingClass respondsToSelector:selRequestAuthorization]) {
        return;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [appTrackingClass performSelector:selRequestAuthorization withObject:completion];
#pragma clang diagnostic pop
}

- (BOOL)adtTrackingEnabled {
#if ADTUST_NO_IDFA
    return NO;
#else
    
//     return [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
    Class adSupportClass = [self adSupportManager];
    if (adSupportClass == nil) {
        return NO;
    }

    NSString *keyManager = [NSString adtJoin:@"shared", @"manager", nil];
    SEL selManager = NSSelectorFromString(keyManager);
    if (![adSupportClass respondsToSelector:selManager]) {
        return NO;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    id manager = [adSupportClass performSelector:selManager];
    
    NSString *keyEnabled = [NSString adtJoin:@"is", @"advertising", @"tracking", @"enabled", nil];
    SEL selEnabled = NSSelectorFromString(keyEnabled);
    if (![manager respondsToSelector:selEnabled]) {
        return NO;
    }
    BOOL enabled = (BOOL)[manager performSelector:selEnabled];
    return enabled;
#pragma clang diagnostic pop
#endif
}

- (NSString *)adtIdForAdvertisers {
#if ADTUST_NO_IDFA
    return @"";
#else
    // return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    Class adSupportClass = [self adSupportManager];
    if (adSupportClass == nil) {
        return @"";
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

    NSString *keyManager = [NSString adtJoin:@"shared", @"manager", nil];
    SEL selManager = NSSelectorFromString(keyManager);
    if (![adSupportClass respondsToSelector:selManager]) {
        return @"";
    }
    id manager = [adSupportClass performSelector:selManager];

    NSString *keyIdentifier = [NSString adtJoin:@"advertising", @"identifier", nil];
    SEL selIdentifier = NSSelectorFromString(keyIdentifier);
    if (![manager respondsToSelector:selIdentifier]) {
        return @"";
    }
    id identifier = [manager performSelector:selIdentifier];

    NSString *keyString = [NSString adtJoin:@"UUID", @"string", nil];
    SEL selString = NSSelectorFromString(keyString);
    if (![identifier respondsToSelector:selString]) {
        return @"";
    }
    NSString *string = [identifier performSelector:selString];
    return string;

#pragma clang diagnostic pop
#endif
}

- (NSString *)adtFbAnonymousId {
#if TARGET_OS_TV
    return @"";
#else
    // pre FB SDK v6.0.0
    // return [FBSDKAppEventsUtility retrievePersistedAnonymousID];
    // post FB SDK v6.0.0
    // return [FBSDKBasicUtility retrievePersistedAnonymousID];
    Class class = nil;
    SEL selGetId = NSSelectorFromString(@"retrievePersistedAnonymousID");
    class = NSClassFromString(@"FBSDKBasicUtility");
    if (class != nil) {
        if ([class respondsToSelector:selGetId]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            NSString *fbAnonymousId = (NSString *)[class performSelector:selGetId];
            return fbAnonymousId;
#pragma clang diagnostic pop
        }
    }
    class = NSClassFromString(@"FBSDKAppEventsUtility");
    if (class != nil) {
        if ([class respondsToSelector:selGetId]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            NSString *fbAnonymousId = (NSString *)[class performSelector:selGetId];
            return fbAnonymousId;
#pragma clang diagnostic pop
        }
    }
    return @"";
#endif
}

- (NSString *)adtDeviceType {
    NSString *type = [self.model stringByReplacingOccurrencesOfString:@" " withString:@""];
    return type;
}

- (NSString *)adtDeviceName {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *name = malloc(size);
    sysctlbyname("hw.machine", name, &size, NULL, 0);
    NSString *machine = [NSString stringWithUTF8String:name];
    free(name);
    return machine;
}

- (NSString *)adtCreateUuid {
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef stringRef = CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    NSString *uuidString = (__bridge_transfer NSString*)stringRef;
    NSString *lowerUuid = [uuidString lowercaseString];
    CFRelease(newUniqueId);
    return lowerUuid;
}

- (NSString *)adtVendorId {
    if ([UIDevice.currentDevice respondsToSelector:@selector(identifierForVendor)]) {
        return [UIDevice.currentDevice.identifierForVendor UUIDString];
    }
    return @"";
}

- (NSString *)adtDeviceId:(ADTDeviceInfo *)deviceInfo {
    int languageMaxLength = 16;
    NSString *language = deviceInfo.languageCode;
    NSString *binaryLanguage = [ADTUtil stringToBinaryString:language];
    NSString *binaryLanguageFormatted = [ADTUtil enforceParameterLength:binaryLanguage withMaxlength:languageMaxLength];
    
    int hardwareNameMaxLength = 48;
    NSString *hardwareName = deviceInfo.machineModel;
    NSString *binaryHardwareName = [ADTUtil stringToBinaryString:hardwareName];
    NSString *binaryHardwareNameFormatted = [ADTUtil enforceParameterLength:binaryHardwareName withMaxlength:hardwareNameMaxLength];
    
    NSArray *versionParts = [deviceInfo.systemVersion componentsSeparatedByString:@"."];
    int osVersionMajor = [[versionParts objectAtIndex:0] intValue];
    int osVersionMinor = [[versionParts objectAtIndex:1] intValue];
    int osVersionPatch = [versionParts count] == 3 ? [[versionParts objectAtIndex:2] intValue] : 0;

    int osVersionMajorMaxLength = 8;
    NSString *binaryOsVersionMajor = [ADTUtil decimalToBinaryString:osVersionMajor];
    NSString *binaryOsVersionMajorFormatted = [ADTUtil enforceParameterLength:binaryOsVersionMajor withMaxlength:osVersionMajorMaxLength];
    
    int osVersionMinorMaxLength = 8;
    NSString *binaryOsVersionMinor = [ADTUtil decimalToBinaryString:osVersionMinor];
    NSString *binaryOsVersionMinorFormatted = [ADTUtil enforceParameterLength:binaryOsVersionMinor withMaxlength:osVersionMinorMaxLength];
    
    int osVersionPatchMaxLength = 8;
    NSString *binaryOsVersionPatch = [ADTUtil decimalToBinaryString:osVersionPatch];
    NSString *binaryOsVersionPatchFormatted = [ADTUtil enforceParameterLength:binaryOsVersionPatch withMaxlength:osVersionPatchMaxLength];

    int mccMaxLength = 24;
    NSString *mcc = [ADTUtil readMCC];
    NSString *binaryMcc = [ADTUtil stringToBinaryString:mcc];
    NSString *binaryMccFormatted = [ADTUtil enforceParameterLength:binaryMcc withMaxlength:mccMaxLength];

    int mncMaxLength = 24;
    NSString *mnc = [ADTUtil readMNC];
    NSString *binaryMnc = [ADTUtil stringToBinaryString:mnc];
    NSString *binaryMncFormatted = [ADTUtil enforceParameterLength:binaryMnc withMaxlength:mncMaxLength];
    
    int chargingStatusMaxLength = 8;
    NSUInteger chargingStatus = [ADTSystemProfile chargingStatus];
    NSString *binaryChargingStatus = [ADTUtil decimalToBinaryString:chargingStatus];
    NSString *binaryChargingStatusFormatted = [ADTUtil enforceParameterLength:binaryChargingStatus withMaxlength:chargingStatusMaxLength];
    
    int batteryLevelMaxSize = 8;
    NSUInteger batteryLevel = [ADTSystemProfile batteryLevel];
    NSString *binaryBatteryLevel = [ADTUtil decimalToBinaryString:batteryLevel];
    NSString *binaryBatteryLevelFormatted = [ADTUtil enforceParameterLength:binaryBatteryLevel withMaxlength:batteryLevelMaxSize];
    
    int totalSpaceMaxSize = 24;
    NSUInteger totalSpace = [ADTSystemProfile totalDiskSpace];
    NSString *binaryTotalSpace = [ADTUtil decimalToBinaryString:totalSpace];
    NSString *binaryTotalSpaceFormatted = [ADTUtil enforceParameterLength:binaryTotalSpace withMaxlength:totalSpaceMaxSize];
    
    int freeSpaceMaxSize = 24;
    NSUInteger freeSpace = [ADTSystemProfile freeDiskSpace];
    NSString *binaryFreeSpace = [ADTUtil decimalToBinaryString:freeSpace];
    NSString *binaryFreeSpaceFormatted = [ADTUtil enforceParameterLength:binaryFreeSpace withMaxlength:freeSpaceMaxSize];
    
    int systemUptimeMaxSize = 24;
    NSUInteger systemUptime = [ADTSystemProfile systemUptime];
    NSString *binarySystemUptime = [ADTUtil decimalToBinaryString:systemUptime];
    NSString *binarySystemUptimeFormatted = [ADTUtil enforceParameterLength:binarySystemUptime withMaxlength:systemUptimeMaxSize];
    
    int lastBootTimeMaxSize = 32;
    NSUInteger lastBootTime = [ADTSystemProfile lastBootTime];
    NSString *binaryLastBootTime = [ADTUtil decimalToBinaryString:lastBootTime];
    NSString *binaryLastBootTimeFormatted = [ADTUtil enforceParameterLength:binaryLastBootTime withMaxlength:lastBootTimeMaxSize];
    
    NSString *concatenated = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@",
                              binaryLanguageFormatted,
                              binaryHardwareNameFormatted,
                              binaryOsVersionMajorFormatted,
                              binaryOsVersionMinorFormatted,
                              binaryOsVersionPatchFormatted,
                              binaryMccFormatted,
                              binaryMncFormatted,
                              binaryChargingStatusFormatted,
                              binaryBatteryLevelFormatted,
                              binaryTotalSpaceFormatted,
                              binaryFreeSpaceFormatted,
                              binarySystemUptimeFormatted,
                              binaryLastBootTimeFormatted];

    // make sure concatenated string length is multiple of 4
    if (concatenated.length % 4 != 0) {
        int numberOfBits = concatenated.length % 4;
        while (numberOfBits != 4) {
            concatenated = [@"0" stringByAppendingString:concatenated];
            numberOfBits += 1;
        }
    }
    
    NSString *mParameter = @"";
    for (NSUInteger i = 0; i < concatenated.length; i += 4) {
        // get fourplet substring
        NSString *fourplet = [concatenated substringWithRange:NSMakeRange(i, 4)];
        // convert fourplet to decimal number
        long decimalFourplet = strtol([fourplet UTF8String], NULL, 2);
        // append hex value of fourplet to final parameter
        mParameter = [mParameter stringByAppendingString:[NSString stringWithFormat:@"%lX", decimalFourplet]];
    }
    
    return mParameter;
}

- (void)adtCheckForiAd:(ADTActivityHandler *)activityHandler queue:(dispatch_queue_t)queue {
    // if no tries for iad v3 left, stop trying
    id<ADTLogger> logger = [ADTAdtraceFactory logger];

#if ADTUST_NO_IAD || TARGET_OS_TV
    [logger debug:@"ADTUST_NO_IAD or TARGET_OS_TV set"];
    return;
#else
    [logger debug:@"ADTUST_NO_IAD or TARGET_OS_TV not set"];

    // [[ADClient sharedClient] ...]
    Class ADClientClass = NSClassFromString(@"ADClient");
    if (ADClientClass == nil) {
        [logger warn:@"iAd framework not found in user's app (ADClientClass not found)"];
        return;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    SEL sharedClientSelector = NSSelectorFromString(@"sharedClient");
    if (![ADClientClass respondsToSelector:sharedClientSelector]) {
        [logger warn:@"iAd framework not found in user's app (sharedClient method not found)"];
        return;
    }
    id ADClientSharedClientInstance = [ADClientClass performSelector:sharedClientSelector];
    if (ADClientSharedClientInstance == nil) {
        [logger warn:@"iAd framework not found in user's app (ADClientSharedClientInstance is nil)"];
        return;
    }

    [logger debug:@"iAd framework successfully found in user's app"];

    BOOL iAdInformationAvailable = [self setiAdWithDetails:activityHandler
                                   adcClientSharedInstance:ADClientSharedClientInstance
                                    queue:queue];

    if (!iAdInformationAvailable) {
        [logger warn:@"iAd information not available"];
        return;
    }
#pragma clang diagnostic pop
#endif
}

- (BOOL)setiAdWithDetails:(ADTActivityHandler *)activityHandler
  adcClientSharedInstance:(id)ADClientSharedClientInstance
                    queue:(dispatch_queue_t)queue {
    SEL iAdDetailsSelector = NSSelectorFromString(@"requestAttributionDetailsWithBlock:");
    if (![ADClientSharedClientInstance respondsToSelector:iAdDetailsSelector]) {
        return NO;
    }
    
    __block Class lock = [ADTActivityHandler class];
    __block BOOL completed = NO;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [ADClientSharedClientInstance performSelector:iAdDetailsSelector
                                       withObject:^(NSDictionary *attributionDetails, NSError *error) {
        
        @synchronized (lock) {
            if (completed) {
                return;
            } else {
                completed = YES;
            }
        }
        
        [activityHandler setAttributionDetails:attributionDetails
                                         error:error];
    }];
#pragma clang diagnostic pop
    
    // 5 seconds of timeout
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), queue, ^{
        @synchronized (lock) {
            if (completed) {
                return;
            } else {
                completed = YES;
            }
        }
        
        [activityHandler setAttributionDetails:nil
                                         error:[NSError errorWithDomain:@"com.adtrace.sdk.iAd"
                                                                   code:100
                                                               userInfo:@{@"Error reason": @"iAd request timed out"}]];
    });
    
    return YES;
}

@end
