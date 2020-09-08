//
//  ADTActivityState.m
//  Adtrace
//
//  Created by Aref on 9/8/20.
//  Copyright © 2020 Adtrace. All rights reserved.
//

#import "ADTKeychain.h"
#import "ADTAdtraceFactory.h"
#import "ADTActivityState.h"
#import "UIDevice+ADTAdditions.h"
#import "NSString+ADTAdditions.h"

static const int kTransactionIdCount = 10;
static NSString *appToken = nil;

@implementation ADTActivityState

#pragma mark - Object lifecycle methods

- (id)init {
    self = [super init];
    if (self == nil) {
        return nil;
    }

    [self assignUuid:[UIDevice.currentDevice adtCreateUuid]];

    self.eventCount = 0;
    self.sessionCount = 0;
    self.subsessionCount = -1;   // -1 means unknown
    self.sessionLength = -1;
    self.timeSpent = -1;
    self.lastActivity = -1;
    self.lastInterval = -1;
    self.enabled = YES;
    self.isGdprForgotten = NO;
    self.askingAttribution = NO;
    self.isThirdPartySharingDisabled = NO;
    self.deviceToken = nil;
    self.transactionIds = [NSMutableArray arrayWithCapacity:kTransactionIdCount];
    self.updatePackages = NO;
    self.trackingManagerAuthorizationStatus = -1;

    return self;
}

#pragma mark - Public methods

+ (void)saveAppToken:(NSString *)appTokenToSave {
    @synchronized (self) {
        appToken = appTokenToSave;
    }
}

- (void)resetSessionAttributes:(double)now {
    self.subsessionCount = 1;
    self.sessionLength = 0;
    self.timeSpent = 0;
    self.lastInterval = -1;
    self.lastActivity = now;
}

- (void)addTransactionId:(NSString *)transactionId {
    // Create array.
    if (self.transactionIds == nil) {
        self.transactionIds = [NSMutableArray arrayWithCapacity:kTransactionIdCount];
    }

    // Make space.
    if (self.transactionIds.count == kTransactionIdCount) {
        [self.transactionIds removeObjectAtIndex:0];
    }

    // Add the new ID.
    [self.transactionIds addObject:transactionId];
}

- (BOOL)findTransactionId:(NSString *)transactionId {
    return [self.transactionIds containsObject:transactionId];
}

#pragma mark - Private & helper methods

- (void)assignUuid:(NSString *)uuid {
    NSString *persistedUuid = [ADTKeychain valueForKeychainKey:@"adtrace_uuid" service:@"deviceInfo"];

    // Check if value exists in Keychain.
    if (persistedUuid != nil) {
        // Check if value has UUID format.
        if ((bool)[[NSUUID alloc] initWithUUIDString:persistedUuid]) {
            [[ADTAdtraceFactory logger] verbose:@"Value read from the keychain"];

            // Value written in keychain seems to have UUID format.
            self.uuid = persistedUuid;
            self.isPersisted = YES;
            return;
        }
    }

    // At this point, UUID was not persisted in Keychain or if persisted, didn't have proper UUID format.
    // Since we don't have anything in the keychain, we'll use the passed UUID value.
    // Try to save that value to the keychain.
    self.uuid = uuid;
    self.isPersisted = [ADTKeychain setValue:self.uuid forKeychainKey:@"adtrace_uuid" inService:@"deviceInfo"];
}

- (NSString *)generateUniqueKey {
    if (appToken == nil) {
        return nil;
    }

    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    if (bundleIdentifier == nil) {
        return nil;
    }

    NSString *joinedKey = [NSString stringWithFormat:@"%@%@", bundleIdentifier, appToken];
    return [joinedKey adtSha1];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"ec:%d sc:%d ssc:%d ask:%d sl:%.1f ts:%.1f la:%.1f dt:%@ gdprf:%d dtps:%d att:%d",
            self.eventCount, self.sessionCount,
            self.subsessionCount, self.askingAttribution, self.sessionLength,
            self.timeSpent, self.lastActivity, self.deviceToken,
            self.isGdprForgotten, self.isThirdPartySharingDisabled, self.trackingManagerAuthorizationStatus];
}

#pragma mark - NSCoding protocol methods

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self == nil) {
        return nil;
    }

    self.eventCount = [decoder decodeIntForKey:@"eventCount"];
    self.sessionCount = [decoder decodeIntForKey:@"sessionCount"];
    self.subsessionCount = [decoder decodeIntForKey:@"subsessionCount"];
    self.sessionLength = [decoder decodeDoubleForKey:@"sessionLength"];
    self.timeSpent = [decoder decodeDoubleForKey:@"timeSpent"];
    self.lastActivity = [decoder decodeDoubleForKey:@"lastActivity"];
    
    // Default values for migrating devices.
    if ([decoder containsValueForKey:@"uuid"]) {
        [self assignUuid:[decoder decodeObjectForKey:@"uuid"]];
    }
    if (self.uuid == nil) {
        [self assignUuid:[UIDevice.currentDevice adtCreateUuid]];
    }

    if ([decoder containsValueForKey:@"transactionIds"]) {
        self.transactionIds = [decoder decodeObjectForKey:@"transactionIds"];
    }
    if (self.transactionIds == nil) {
        self.transactionIds = [NSMutableArray arrayWithCapacity:kTransactionIdCount];
    }

    if ([decoder containsValueForKey:@"enabled"]) {
        self.enabled = [decoder decodeBoolForKey:@"enabled"];
    } else {
        self.enabled = YES;
    }

    if ([decoder containsValueForKey:@"isGdprForgotten"]) {
        self.isGdprForgotten = [decoder decodeBoolForKey:@"isGdprForgotten"];
    } else {
        self.isGdprForgotten = NO;
    }

    if ([decoder containsValueForKey:@"askingAttribution"]) {
        self.askingAttribution = [decoder decodeBoolForKey:@"askingAttribution"];
    } else {
        self.askingAttribution = NO;
    }

    if ([decoder containsValueForKey:@"isThirdPartySharingDisabled"]) {
        self.isThirdPartySharingDisabled = [decoder decodeBoolForKey:@"isThirdPartySharingDisabled"];
    } else {
        self.isThirdPartySharingDisabled = NO;
    }

    if ([decoder containsValueForKey:@"deviceToken"]) {
        self.deviceToken = [decoder decodeObjectForKey:@"deviceToken"];
    }

    if ([decoder containsValueForKey:@"updatePackages"]) {
        self.updatePackages = [decoder decodeBoolForKey:@"updatePackages"];
    } else {
        self.updatePackages = NO;
    }

    if ([decoder containsValueForKey:@"adid"]) {
        self.adid = [decoder decodeObjectForKey:@"adid"];
    }

    if ([decoder containsValueForKey:@"attributionDetails"]) {
        self.attributionDetails = [decoder decodeObjectForKey:@"attributionDetails"];
    }

    if ([decoder containsValueForKey:@"trackingManagerAuthorizationStatus"]) {
        self.trackingManagerAuthorizationStatus =
            [decoder decodeIntForKey:@"trackingManagerAuthorizationStatus"];
    } else {
        self.trackingManagerAuthorizationStatus = -1;
    }

    self.lastInterval = -1;

    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt:self.eventCount forKey:@"eventCount"];
    [encoder encodeInt:self.sessionCount forKey:@"sessionCount"];
    [encoder encodeInt:self.subsessionCount forKey:@"subsessionCount"];
    [encoder encodeDouble:self.sessionLength forKey:@"sessionLength"];
    [encoder encodeDouble:self.timeSpent forKey:@"timeSpent"];
    [encoder encodeDouble:self.lastActivity forKey:@"lastActivity"];
    [encoder encodeObject:self.uuid forKey:@"uuid"];
    [encoder encodeObject:self.transactionIds forKey:@"transactionIds"];
    [encoder encodeBool:self.enabled forKey:@"enabled"];
    [encoder encodeBool:self.isGdprForgotten forKey:@"isGdprForgotten"];
    [encoder encodeBool:self.askingAttribution forKey:@"askingAttribution"];
    [encoder encodeBool:self.isThirdPartySharingDisabled forKey:@"isThirdPartySharingDisabled"];
    [encoder encodeObject:self.deviceToken forKey:@"deviceToken"];
    [encoder encodeBool:self.updatePackages forKey:@"updatePackages"];
    [encoder encodeObject:self.adid forKey:@"adid"];
    [encoder encodeObject:self.attributionDetails forKey:@"attributionDetails"];
    [encoder encodeInt:self.trackingManagerAuthorizationStatus
                   forKey:@"trackingManagerAuthorizationStatus"];
}

#pragma mark - NSCopying protocol methods

- (id)copyWithZone:(NSZone *)zone {
    ADTActivityState *copy = [[[self class] allocWithZone:zone] init];

    // Copy only values used by package builder.
    if (copy) {
        copy.sessionCount = self.sessionCount;
        copy.subsessionCount = self.subsessionCount;
        copy.sessionLength = self.sessionLength;
        copy.timeSpent = self.timeSpent;
        copy.uuid = [self.uuid copyWithZone:zone];
        copy.lastInterval = self.lastInterval;
        copy.eventCount = self.eventCount;
        copy.enabled = self.enabled;
        copy.isGdprForgotten = self.isGdprForgotten;
        copy.lastActivity = self.lastActivity;
        copy.askingAttribution = self.askingAttribution;
        copy.isThirdPartySharingDisabled = self.isThirdPartySharingDisabled;
        copy.deviceToken = [self.deviceToken copyWithZone:zone];
        copy.updatePackages = self.updatePackages;
        copy.trackingManagerAuthorizationStatus = self.trackingManagerAuthorizationStatus;
    }
    
    return copy;
}

@end
