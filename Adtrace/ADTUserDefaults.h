//
//  ADTUserDefaults.h
//  Adtrace
//
//  Created by Aref on 9/8/20.
//  Copyright © 2020 Adtrace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADTUserDefaults : NSObject

+ (void)savePushTokenData:(NSData *)pushToken;

+ (void)savePushTokenString:(NSString *)pushToken;

+ (NSData *)getPushTokenData;

+ (NSString *)getPushTokenString;

+ (void)removePushToken;

+ (void)setInstallTracked;

+ (BOOL)getInstallTracked;

+ (void)setGdprForgetMe;

+ (BOOL)getGdprForgetMe;

+ (void)removeGdprForgetMe;

+ (void)saveDeeplinkUrl:(NSURL *)deeplink
           andClickTime:(NSDate *)clickTime;

+ (NSURL *)getDeeplinkUrl;

+ (NSDate *)getDeeplinkClickTime;

+ (void)removeDeeplink;

+ (void)setDisableThirdPartySharing;

+ (BOOL)getDisableThirdPartySharing;

+ (void)removeDisableThirdPartySharing;

+ (void)clearAdtraceStuff;

+ (void)saveiAdErrorKey:(NSString *)key;
+ (NSDictionary<NSString *, NSNumber *> *)getiAdErrors;
+ (void)cleariAdErrors;

@end
