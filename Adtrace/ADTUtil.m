//
//  ADTUtil.m
//  Adtrace
//
//  Created by Aref on 9/8/20.
//  Copyright © 2020 Adtrace. All rights reserved.
//

#include <math.h>
#include <stdlib.h>
#include <sys/xattr.h>
#import <objc/message.h>

#import "ADTUtil.h"
#import "ADTLogger.h"
#import "ADTReachability.h"
#import "ADTResponseData.h"
#import "ADTAdtraceFactory.h"
#import "UIDevice+ADTAdditions.h"
#import "NSString+ADTAdditions.h"

#if !TARGET_OS_TV && !TARGET_OS_MACCATALYST
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#endif

static NSString *userAgent = nil;
static ADTReachability *reachability = nil;
static NSRegularExpression *universalLinkRegex = nil;
static NSNumberFormatter *secondsNumberFormatter = nil;
static NSRegularExpression *optionalRedirectRegex = nil;
static NSRegularExpression *shortUniversalLinkRegex = nil;
static NSRegularExpression *excludedDeeplinkRegex = nil;

#if !TARGET_OS_TV && !TARGET_OS_MACCATALYST
static CTCarrier *carrier = nil;
static CTTelephonyNetworkInfo *networkInfo = nil;
#endif

static NSString * const kClientSdk                  = @"ios1.1.0";
static NSString * const kDeeplinkParam              = @"deep_link=";
static NSString * const kSchemeDelimiter            = @"://";
static NSString * const kDefaultScheme              = @"AdtraceUniversalScheme";
static NSString * const kUniversalLinkPattern       = @"https://[^.]*\\.ulink\\.adtrace\\.com/ulink/?(.*)";
static NSString * const kOptionalRedirectPattern    = @"adtrace_redirect=[^&#]*";
static NSString * const kShortUniversalLinkPattern  = @"http[s]?://[a-z0-9]{4}\\.adt\\.st/?(.*)";
static NSString * const kExcludedDeeplinksPattern   = @"^(fb|vk)[0-9]{5,}[^:]*://authorize.*access_token=.*";
static NSString * const kDateFormat                 = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'Z";

@implementation ADTUtil

+ (void)initialize {
    if (self != [ADTUtil class]) {
        return;
    }

    [self initializeUniversalLinkRegex];
    [self initializeSecondsNumberFormatter];
    [self initializeShortUniversalLinkRegex];
    [self initializeOptionalRedirectRegex];
    [self initializeExcludedDeeplinkRegex];
    [self initializeReachability];
#if !TARGET_OS_TV && !TARGET_OS_MACCATALYST
    [self initializeNetworkInfoAndCarrier];
#endif
}

+ (void)teardown {
    reachability = nil;
    universalLinkRegex = nil;
    secondsNumberFormatter = nil;
    optionalRedirectRegex = nil;
    shortUniversalLinkRegex = nil;
#if !TARGET_OS_TV && !TARGET_OS_MACCATALYST
    networkInfo = nil;
    carrier = nil;
#endif

}

+ (void)initializeUniversalLinkRegex {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kUniversalLinkPattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if ([ADTUtil isNotNull:error]) {
        [ADTAdtraceFactory.logger error:@"Universal link regex rule error (%@)", [error description]];
        return;
    }
    universalLinkRegex = regex;
}

+ (void)initializeShortUniversalLinkRegex {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kShortUniversalLinkPattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if ([ADTUtil isNotNull:error]) {
        [ADTAdtraceFactory.logger error:@"Short Universal link regex rule error (%@)", [error description]];
        return;
    }
    shortUniversalLinkRegex = regex;
}

+ (void)initializeOptionalRedirectRegex {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kOptionalRedirectPattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if ([ADTUtil isNotNull:error]) {
        [ADTAdtraceFactory.logger error:@"Optional redirect regex rule error (%@)", [error description]];
        return;
    }
    optionalRedirectRegex = regex;
}

+ (void)initializeExcludedDeeplinkRegex {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kExcludedDeeplinksPattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if ([ADTUtil isNotNull:error]) {
        [ADTAdtraceFactory.logger error:@"Excluded deep link regex rule error (%@)", [error description]];
        return;
    }
    excludedDeeplinkRegex = regex;
}

+ (void)initializeSecondsNumberFormatter {
    secondsNumberFormatter = [[NSNumberFormatter alloc] init];
    [secondsNumberFormatter setPositiveFormat:@"0.0"];
}

#if !TARGET_OS_TV && !TARGET_OS_MACCATALYST
+ (void)initializeNetworkInfoAndCarrier {
    networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    carrier = [networkInfo subscriberCellularProvider];
}
#endif

+ (void)initializeReachability {
    reachability = [ADTReachability reachabilityForInternetConnection];
    [reachability startNotifier];
}

+ (void)updateUrlSessionConfiguration:(ADTConfig *)config {
    userAgent = config.userAgent;
}

+ (NSString *)clientSdk {
    return kClientSdk;
}

+ (NSDateFormatter *)getDateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if ([NSCalendar instancesRespondToSelector:@selector(calendarWithIdentifier:)]) {
        // http://stackoverflow.com/a/3339787
        NSString *calendarIdentifier;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wtautological-pointer-compare"
        if (&NSCalendarIdentifierGregorian != NULL) {
#pragma clang diagnostic pop
            calendarIdentifier = NSCalendarIdentifierGregorian;
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunreachable-code"
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            calendarIdentifier = NSGregorianCalendar;
#pragma clang diagnostic pop
        }
        dateFormatter.calendar = [NSCalendar calendarWithIdentifier:calendarIdentifier];
    }
    dateFormatter.locale = [NSLocale systemLocale];
    [dateFormatter setDateFormat:kDateFormat];

    return dateFormatter;
}

// Inspired by https://gist.github.com/kevinbarrett/2002382
+ (void)excludeFromBackup:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    const char* filePath = [[url path] fileSystemRepresentation];
    const char* attrName = "com.apple.MobileBackup";
    id<ADTLogger> logger = ADTAdtraceFactory.logger;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunreachable-code"
#pragma clang diagnostic ignored "-Wtautological-pointer-compare"
    if (&NSURLIsExcludedFromBackupKey == nil) {
        u_int8_t attrValue = 1;
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        if (result != 0) {
            [logger debug:@"Failed to exclude '%@' from backup", url.lastPathComponent];
        }
    } else { // iOS 5.0 and higher
        // First try and remove the extended attribute if it is present
        ssize_t result = getxattr(filePath, attrName, NULL, sizeof(u_int8_t), 0, 0);
        if (result != -1) {
            // The attribute exists, we need to remove it
            int removeResult = removexattr(filePath, attrName, 0);
            if (removeResult == 0) {
                [logger debug:@"Removed extended attribute on file '%@'", url];
            }
        }

        // Set the new key
        NSError *error = nil;
        BOOL success = [url setResourceValue:[NSNumber numberWithBool:YES]
                                      forKey:NSURLIsExcludedFromBackupKey
                                       error:&error];
        if (!success || error != nil) {
            [logger debug:@"Failed to exclude '%@' from backup (%@)", url.lastPathComponent, error.localizedDescription];
        }
    }
#pragma clang diagnostic pop
}

+ (NSString *)formatSeconds1970:(double)value {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:value];
    return [self formatDate:date];
}

+ (NSString *)formatDate:(NSDate *)value {
    NSDateFormatter *dateFormatter = [ADTUtil getDateFormatter];
    if (dateFormatter == nil) {
        return nil;
    }
    return [dateFormatter stringFromDate:value];
}

+ (id)readObject:(NSString *)fileName
      objectName:(NSString *)objectName
           class:(Class)classToRead
      syncObject:(id)syncObject
{
    @synchronized(syncObject) {
        NSString *documentsFilePath = [ADTUtil getFilePathInDocumentsDir:fileName];
        NSString *appSupportFilePath = [ADTUtil getFilePathInAppSupportDir:fileName];

        // Try to read from Application Support directory first.
        @try {
            id appSupportObject;
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")) {
                NSData *data = [NSData dataWithContentsOfFile:appSupportFilePath];
                NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
                [unarchiver setRequiresSecureCoding:NO];
                appSupportObject = [unarchiver decodeObjectOfClass:classToRead forKey:NSKeyedArchiveRootObjectKey];
            } else {
                appSupportObject = [NSKeyedUnarchiver unarchiveObjectWithFile:appSupportFilePath];
            }

            if (appSupportObject != nil) {
                if ([appSupportObject isKindOfClass:classToRead]) {
                    // Successfully read object from Application Support folder, return it.
                    if ([appSupportObject isKindOfClass:[NSArray class]]) {
                        [[ADTAdtraceFactory logger] debug:@"Package handler read %d packages", [appSupportObject count]];
                    } else {
                        [[ADTAdtraceFactory logger] debug:@"Read %@: %@", objectName, appSupportObject];
                    }

                    // Just in case check if old file exists in Documents folder and if yes, remove it.
                    [ADTUtil deleteFileInPath:documentsFilePath];

                    return appSupportObject;
                }
            } else {
                // [[ADTAdtraceFactory logger] error:@"Failed to read %@ file", appSupportFilePath];
                [[ADTAdtraceFactory logger] debug:@"File %@ not found in \"Application Support/Adtrace\" folder", fileName];
            }
        } @catch (NSException *ex) {
            // [[ADTAdtraceFactory logger] error:@"Failed to read %@ file  (%@)", appSupportFilePath, ex];
            [[ADTAdtraceFactory logger] error:@"Failed to read %@ file from \"Application Support/Adtrace\" folder (%@)", fileName, ex];
        }

        // If in here, for some reason, reading of file from Application Support folder failed.
        // Let's check the Documents folder.
        @try {
            id documentsObject;
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")) {
                NSData *data = [NSData dataWithContentsOfFile:documentsFilePath];
                NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
                [unarchiver setRequiresSecureCoding:NO];
                documentsObject = [unarchiver decodeObjectOfClass:classToRead forKey:NSKeyedArchiveRootObjectKey];
            } else {
                documentsObject = [NSKeyedUnarchiver unarchiveObjectWithFile:documentsFilePath];
            }

            if (documentsObject != nil) {
                // Successfully read object from Documents folder.
                if ([documentsObject isKindOfClass:[NSArray class]]) {
                    [[ADTAdtraceFactory logger] debug:@"Package handler read %d packages", [documentsObject count]];
                } else {
                    [[ADTAdtraceFactory logger] debug:@"Read %@: %@", objectName, documentsObject];
                }

                // Do the file migration.
                [[ADTAdtraceFactory logger] verbose:@"Migrating %@ file from Documents to \"Application Support/Adtrace\" folder", fileName];
                [ADTUtil migrateFileFromPath:documentsFilePath toPath:appSupportFilePath];

                return documentsObject;
            } else {
                // [[ADTAdtraceFactory logger] error:@"Failed to read %@ file", documentsFilePath];
                [[ADTAdtraceFactory logger] debug:@"File %@ not found in Documents folder", fileName];
            }
        } @catch (NSException *ex) {
            // [[ADTAdtraceFactory logger] error:@"Failed to read %@ file (%@)", documentsFilePath, ex];
            [[ADTAdtraceFactory logger] error:@"Failed to read %@ file from Documents folder (%@)", fileName, ex];
        }

        return nil;
    }
}

+ (void)writeObject:(id)object
           fileName:(NSString *)fileName
         objectName:(NSString *)objectName
         syncObject:(id)syncObject {
    @synchronized(syncObject) {
        @try {
            BOOL result;
            NSString *filePath = [ADTUtil getFilePathInAppSupportDir:fileName];
            if (!filePath) {
                [[ADTAdtraceFactory logger] error:@"Cannot get filepath from filename: %@, to write %@ file", fileName, objectName];
                return;
            }

            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")) {
                NSError *errorArchiving = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object requiringSecureCoding:NO error:&errorArchiving];
#pragma clang diagnostic pop
                if (data && errorArchiving == nil) {
                    NSError *errorWriting = nil;
                    result = [data writeToFile:filePath options:NSDataWritingAtomic error:&errorWriting];
                    result = result && (errorWriting == nil);
                } else {
                    result = NO;
                }
            } else {
                result = [NSKeyedArchiver archiveRootObject:object toFile:filePath];
            }
            if (result == YES) {
                [ADTUtil excludeFromBackup:filePath];
                if ([object isKindOfClass:[NSArray class]]) {
                    [[ADTAdtraceFactory logger] debug:@"Package handler wrote %d packages", [object count]];
                } else {
                    [[ADTAdtraceFactory logger] debug:@"Wrote %@: %@", objectName, object];
                }
            } else {
                [[ADTAdtraceFactory logger] error:@"Failed to write %@ file", objectName];
            }
        } @catch (NSException *exception) {
            [[ADTAdtraceFactory logger] error:@"Failed to write %@ file (%@)", objectName, exception];
        }
    }
}

+ (BOOL)migrateFileFromPath:(NSString *)oldPath toPath:(NSString *)newPath {
    NSError *errorCopy;
    [[NSFileManager defaultManager] copyItemAtPath:oldPath toPath:newPath error:&errorCopy];
    if (errorCopy != nil) {
        [[ADTAdtraceFactory logger] error:@"Error while copying from %@ to %@", oldPath, newPath];
        [[ADTAdtraceFactory logger] error:[errorCopy description]];
        return NO;
    }
    // Migration successful.
    return YES;
}

+ (NSString *)getFilePathInDocumentsDir:(NSString *)fileName {
    // Documents directory exists by default inside app bundle, no need to check for it's presence.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *filePath = [documentsDir stringByAppendingPathComponent:fileName];
    return filePath;
}

+ (NSString *)getFilePathInAppSupportDir:(NSString *)fileName {
    // Application Support directory doesn't exist by default inside app bundle.
    // All Adtrace files are going to be stored in Adtrace sub-directory inside Application Support directory.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *appSupportDir = [paths firstObject];
    NSString *adtraceDirName = @"Adtrace";
    if (![ADTUtil checkForDirectoryPresenceInPath:appSupportDir forFolder:[appSupportDir lastPathComponent]]) {
        return nil;
    }
    NSString *adtraceDir = [appSupportDir stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", adtraceDirName]];
    if (![ADTUtil checkForDirectoryPresenceInPath:adtraceDir forFolder:adtraceDirName]) {
        return nil;
    }
    NSString *filePath = [adtraceDir stringByAppendingPathComponent:fileName];
    return filePath;
}

+ (BOOL)checkForDirectoryPresenceInPath:(NSString *)path forFolder:(NSString *)folderName {
    // Check for presence of directory first.
    // If it doesn't exist, make one.
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[ADTAdtraceFactory logger] debug:@"%@ directory not present and will be created", folderName];
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error];
        if (error != nil) {
            [[ADTAdtraceFactory logger] error:@"Error while creating % directory", path];
            [[ADTAdtraceFactory logger] error:[error description]];
            return NO;
        }
    }
    return YES;
}

+ (NSString *)queryString:(NSDictionary *)parameters {
    return [ADTUtil queryString:parameters queueSize:0];
}

+ (NSString *)queryString:(NSDictionary *)parameters
                queueSize:(NSUInteger)queueSize {
    NSMutableArray *pairs = [NSMutableArray array];
    for (NSString *key in parameters) {
        NSString *value = [parameters objectForKey:key];
        NSString *escapedValue = [value adtUrlEncode];
        NSString *escapedKey = [key adtUrlEncode];
        NSString *pair = [NSString stringWithFormat:@"%@=%@", escapedKey, escapedValue];
        [pairs addObject:pair];
    }

    double now = [NSDate.date timeIntervalSince1970];
    NSString *dateString = [ADTUtil formatSeconds1970:now];
    NSString *escapedDate = [dateString adtUrlEncode];
    NSString *sentAtPair = [NSString stringWithFormat:@"%@=%@", @"sent_at", escapedDate];
    [pairs addObject:sentAtPair];

    if (queueSize > 0) {
        unsigned long queueSizeNative = (unsigned long)queueSize;
        NSString *queueSizeString = [NSString stringWithFormat:@"%lu", queueSizeNative];
        NSString *escapedQueueSize = [queueSizeString adtUrlEncode];
        NSString *queueSizePair = [NSString stringWithFormat:@"%@=%@", @"queue_size", escapedQueueSize];
        [pairs addObject:queueSizePair];
    }

    NSString *queryString = [pairs componentsJoinedByString:@"&"];
    return queryString;
}

+ (BOOL)isNull:(id)value {
    return value == nil || value == (id)[NSNull null];
}

+ (BOOL)isNotNull:(id)value {
    return value != nil && value != (id)[NSNull null];
}
















// Convert all values to strings, if value is dictionary -> recursive call
+ (NSDictionary *)convertDictionaryValues:(NSDictionary *)dictionary {
    NSMutableDictionary *convertedDictionary = [[NSMutableDictionary alloc] initWithCapacity:dictionary.count];
    for (NSString *key in dictionary) {
        id value = [dictionary objectForKey:key];
        if ([value isKindOfClass:[NSDictionary class]]) {
            // Dictionary value, recursive call
            NSDictionary *dictionaryValue = [ADTUtil convertDictionaryValues:(NSDictionary *)value];
            [convertedDictionary setObject:dictionaryValue forKey:key];
        } else if ([value isKindOfClass:[NSDate class]]) {
            // Format date to our custom format
            NSString *dateStingValue = [ADTUtil formatDate:value];
            if (dateStingValue != nil) {
                [convertedDictionary setObject:dateStingValue forKey:key];
            }
        } else {
            // Convert all other objects directly to string
            NSString *stringValue = [NSString stringWithFormat:@"%@", value];
            [convertedDictionary setObject:stringValue forKey:key];
        }
    }
    return convertedDictionary;
}

+ (NSString *)idfa {
    return [[UIDevice currentDevice] adtIdForAdvertisers];
}

+ (NSString *)getUpdateTime {
    NSDate *updateTime = nil;
    id<ADTLogger> logger = ADTAdtraceFactory.logger;
    @try {
        __autoreleasing NSError *error;
        NSString *infoPlistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        updateTime = [[[NSFileManager defaultManager] attributesOfItemAtPath:infoPlistPath error:&error] objectForKey:NSFileModificationDate];
    } @catch (NSException *exception) {
        [logger error:@"Error while trying to check update date. Exception: %@", exception];
    }
    return [ADTUtil formatDate:updateTime];
}

+ (NSString *)getInstallTime {
    id<ADTLogger> logger = ADTAdtraceFactory.logger;
    NSDate *installTime = nil;
    NSString *pathToCheck = nil;
    NSSearchPathDirectory folderToCheck = NSDocumentDirectory;
#if TARGET_OS_TV
    folderToCheck = NSCachesDirectory;
#endif
    @try {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(folderToCheck, NSUserDomainMask, YES);
        if (paths.count > 0) {
            pathToCheck = [paths objectAtIndex:0];
        } else {
            // There's no NSDocumentDirectory (or NSCachesDirectory).
            // Check app's bundle creation date instead.
            pathToCheck = [[NSBundle mainBundle] bundlePath];
        }
        installTime = [[NSFileManager defaultManager] attributesOfItemAtPath:pathToCheck error:nil][NSFileCreationDate];
    } @catch (NSException *exception) {
        [logger error:@"Error while trying to check install date. Exception: %@", exception];
    }
    return [ADTUtil formatDate:installTime];
}

+ (NSURL *)convertUniversalLink:(NSURL *)url scheme:(NSString *)scheme {
    id<ADTLogger> logger = ADTAdtraceFactory.logger;

    if ([ADTUtil isNull:url]) {
        [logger error:@"Received universal link is nil"];
        return nil;
    }
    if ([ADTUtil isNull:scheme] || [scheme length] == 0) {
        [logger warn:@"Non-empty scheme required, using the scheme \"AdtraceUniversalScheme\""];
        scheme = kDefaultScheme;
    }
    NSString *urlString = [url absoluteString];
    if ([ADTUtil isNull:urlString]) {
        [logger error:@"Parsed universal link is nil"];
        return nil;
    }
    if (universalLinkRegex == nil) {
        [logger error:@"Universal link regex not correctly configured"];
        return nil;
    }
    if (shortUniversalLinkRegex == nil) {
        [logger error:@"Short Universal link regex not correctly configured"];
        return nil;
    }

    NSArray<NSTextCheckingResult *> *matches = [universalLinkRegex matchesInString:urlString options:0 range:NSMakeRange(0, [urlString length])];
    if ([matches count] == 0) {
        matches = [shortUniversalLinkRegex matchesInString:urlString options:0 range:NSMakeRange(0, [urlString length])];
        if ([matches count] == 0) {
            [logger error:@"Url doesn't match as universal link or short version"];
            return nil;
        }
    }
    if ([matches count] > 1) {
        [logger error:@"Url match as universal link multiple times"];
        return nil;
    }

    NSTextCheckingResult *match = matches[0];
    if ([match numberOfRanges] != 2) {
        [logger error:@"Wrong number of ranges matched"];
        return nil;
    }

    NSString *tailSubString = [urlString substringWithRange:[match rangeAtIndex:1]];
    NSString *finalTailSubString = [ADTUtil removeOptionalRedirect:tailSubString];
    NSString *extractedUrlString = [NSString stringWithFormat:@"%@://%@", scheme, finalTailSubString];
    [logger info:@"Converted deeplink from universal link %@", extractedUrlString];
    NSURL *extractedUrl = [NSURL URLWithString:extractedUrlString];
    if ([ADTUtil isNull:extractedUrl]) {
        [logger error:@"Unable to parse converted deeplink from universal link %@", extractedUrlString];
        return nil;
    }
    return extractedUrl;
}

+ (NSString *)removeOptionalRedirect:(NSString *)tailSubString {
    id<ADTLogger> logger = ADTAdtraceFactory.logger;

    if (optionalRedirectRegex == nil) {
        [ADTAdtraceFactory.logger error:@"Remove Optional Redirect regex not correctly configured"];
        return tailSubString;
    }
    NSArray<NSTextCheckingResult *> *optionalRedirectmatches = [optionalRedirectRegex matchesInString:tailSubString
                                                                                              options:0
                                                                                                range:NSMakeRange(0, [tailSubString length])];
    if ([optionalRedirectmatches count] == 0) {
        [logger debug:@"Universal link does not contain option adtrace_redirect parameter"];
        return tailSubString;
    }
    if ([optionalRedirectmatches count] > 1) {
        [logger error:@"Universal link contains multiple option adtrace_redirect parameters"];
        return tailSubString;
    }

    NSTextCheckingResult *redirectMatch = optionalRedirectmatches[0];
    NSRange redirectRange = [redirectMatch rangeAtIndex:0];
    NSString *beforeRedirect = [tailSubString substringToIndex:redirectRange.location];
    NSString *afterRedirect = [tailSubString substringFromIndex:(redirectRange.location + redirectRange.length)];
    if (beforeRedirect.length > 0 && afterRedirect.length > 0) {
        NSString *lastCharacterBeforeRedirect = [beforeRedirect substringFromIndex:beforeRedirect.length - 1];
        NSString *firstCharacterAfterRedirect = [afterRedirect substringToIndex:1];
        if ([@"&" isEqualToString:lastCharacterBeforeRedirect] &&
            [@"&" isEqualToString:firstCharacterAfterRedirect]) {
            beforeRedirect = [beforeRedirect substringToIndex:beforeRedirect.length - 1];
        }
        if ([@"&" isEqualToString:lastCharacterBeforeRedirect] &&
            [@"#" isEqualToString:firstCharacterAfterRedirect]) {
            beforeRedirect = [beforeRedirect substringToIndex:beforeRedirect.length - 1];
        }
        if ([@"?" isEqualToString:lastCharacterBeforeRedirect] &&
            [@"#" isEqualToString:firstCharacterAfterRedirect]) {
            beforeRedirect = [beforeRedirect substringToIndex:beforeRedirect.length - 1];
        }
        if ([@"?" isEqualToString:lastCharacterBeforeRedirect] &&
            [@"&" isEqualToString:firstCharacterAfterRedirect]) {
            afterRedirect = [afterRedirect substringFromIndex:1];
        }
    }
    
    NSString *removedRedirect = [NSString stringWithFormat:@"%@%@", beforeRedirect, afterRedirect];
    return removedRedirect;
}

+ (NSString *)secondsNumberFormat:(double)seconds {
    // Normalize negative zero
    if (seconds < 0) {
        seconds = seconds * -1;
    }
    if (secondsNumberFormatter == nil) {
        return nil;
    }
    return [secondsNumberFormatter stringFromNumber:[NSNumber numberWithDouble:seconds]];
}

+ (double)randomInRange:(double)minRange maxRange:(double)maxRange {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        srand48(arc4random());
    });
    double random = drand48();
    double range = maxRange - minRange;
    double scaled = random  * range;
    double shifted = scaled + minRange;
    return shifted;
}

+ (NSTimeInterval)waitingTime:(NSInteger)retries
              backoffStrategy:(ADTBackoffStrategy *)backoffStrategy {
    if (retries < backoffStrategy.minRetries) {
        return 0;
    }

    // Start with base 0
    NSInteger base = retries - backoffStrategy.minRetries;
    // Get the exponential Time from the base: 1, 2, 4, 8, 16, ... * times the multiplier
    NSTimeInterval exponentialTime = pow(2.0, base) * backoffStrategy.secondMultiplier;
    // Limit the maximum allowed time to wait
    NSTimeInterval ceilingTime = MIN(exponentialTime, backoffStrategy.maxWait);
    // Add 1 to allow maximum value
    double randomRange = [ADTUtil randomInRange:backoffStrategy.minRange maxRange:backoffStrategy.maxRange];
    // Apply jitter factor
    NSTimeInterval waitingTime =  ceilingTime * randomRange;
    return waitingTime;
}

+ (void)launchInMainThread:(NSObject *)receiver
                  selector:(SEL)selector
                withObject:(id)object {
    if (ADTAdtraceFactory.testing) {
        [ADTAdtraceFactory.logger debug:@"Launching in the background for testing"];
        [receiver performSelectorInBackground:selector withObject:object];
    } else {
        [receiver performSelectorOnMainThread:selector
                                   withObject:object
                                waitUntilDone:NO];  // non-blocking
    }
}

+ (void)launchInMainThread:(dispatch_block_t)block {
    if (ADTAdtraceFactory.testing) {
        [ADTAdtraceFactory.logger debug:@"Launching in the background for testing"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block);
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

+ (BOOL)isMainThread {
    return [[NSThread currentThread] isMainThread];
}

+ (BOOL)isInactive {
#if ADTUST_IM
    // Assume iMessage extension app can't be started from background.
    return NO;
#else
    return [[UIApplication sharedApplication] applicationState] != UIApplicationStateActive;
#endif
}

+ (void)launchInMainThreadWithInactive:(isInactiveInjected)isInactiveblock {
    dispatch_block_t block = ^void(void) {
        __block BOOL isInactive = [ADTUtil isInactive];
        isInactiveblock(isInactive);
    };
    if ([ADTUtil isMainThread]) {
        block();
        return;
    }
    if (ADTAdtraceFactory.testing) {
        [ADTAdtraceFactory.logger debug:@"Launching in the background for testing"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block);
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

+ (BOOL)isValidParameter:(NSString *)attribute
           attributeType:(NSString *)attributeType
           parameterName:(NSString *)parameterName {
    if ([ADTUtil isNull:attribute]) {
        [ADTAdtraceFactory.logger error:@"%@ parameter %@ is missing", parameterName, attributeType];
        return NO;
    }
    if ([attribute isEqualToString:@""]) {
        [ADTAdtraceFactory.logger error:@"%@ parameter %@ is empty", parameterName, attributeType];
        return NO;
    }
    return YES;
}

+ (NSDictionary *)mergeParameters:(NSDictionary *)target
                           source:(NSDictionary *)source
                    parameterName:(NSString *)parameterName {
    if (target == nil) {
        return source;
    }
    if (source == nil) {
        return target;
    }

    NSMutableDictionary *mergedParameters = [NSMutableDictionary dictionaryWithDictionary:target];
    [source enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        NSString *oldValue = [mergedParameters objectForKey:key];
        if (oldValue != nil) {
            [ADTAdtraceFactory.logger warn:@"Key %@ with value %@ from %@ parameter was replaced by value %@",
             key, oldValue, parameterName, obj];
        }
        [mergedParameters setObject:obj forKey:key];
    }];
    return (NSDictionary *)mergedParameters;
}

+ (void)launchInQueue:(dispatch_queue_t)queue
           selfInject:(id)selfInject
                block:(selfInjectedBlock)block {
    if (queue == nil) {
        return;
    }
    __weak __typeof__(selfInject) weakSelf = selfInject;
    dispatch_async(queue, ^{
        __typeof__(selfInject) strongSelf = weakSelf;
        if (strongSelf == nil) {
            return;
        }
        block(strongSelf);
    });
}

+ (void)launchSynchronisedWithObject:(id)synchronisationObject
                               block:(synchronisedBlock)block {
    @synchronized (synchronisationObject) {
        block();
    }
}

+ (BOOL)deleteFileWithName:(NSString *)fileName {
    NSString *documentsFilePath = [ADTUtil getFilePathInDocumentsDir:fileName];
    NSString *appSupportFilePath = [ADTUtil getFilePathInAppSupportDir:fileName];
    BOOL deletedDocumentsFilePath = [ADTUtil deleteFileInPath:documentsFilePath];
    BOOL deletedAppSupportFilePath = [ADTUtil deleteFileInPath:appSupportFilePath];
    return deletedDocumentsFilePath || deletedAppSupportFilePath;
}

+ (BOOL)deleteFileInPath:(NSString *)filePath {
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        // [[ADTAdtraceFactory logger] verbose:@"File does not exist at path %@", filePath];
        return YES;
    }

    BOOL deleted = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    if (!deleted) {
        [[ADTAdtraceFactory logger] verbose:@"Unable to delete file at path %@", filePath];
    }
    if (error) {
        [[ADTAdtraceFactory logger] error:@"Error while deleting file at path %@", filePath];
    }
    return deleted;
}

+ (void)launchDeepLinkMain:(NSURL *)deepLinkUrl {
#if ADTUST_IM
    // No deep linking in iMessage extension apps.
    return;
#else
    UIApplication *sharedUIApplication = [UIApplication sharedApplication];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    SEL openUrlSelector = @selector(openURL:options:completionHandler:);
#pragma clang diagnostic pop
    if ([sharedUIApplication respondsToSelector:openUrlSelector]) {
        /*
         [sharedUIApplication openURL:deepLinkUrl options:@{} completionHandler:^(BOOL success) {
         if (!success) {
         [ADTAdtraceFactory.logger error:@"Unable to open deep link (%@)", deepLinkUrl];
         }
         }];
         */
        NSMethodSignature *methSig = [sharedUIApplication methodSignatureForSelector:openUrlSelector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methSig];
        [invocation setSelector: openUrlSelector];
        [invocation setTarget: sharedUIApplication];
        NSDictionary *emptyDictionary = @{};
        void (^completion)(BOOL) = ^(BOOL success) {
            if (!success) {
                [ADTAdtraceFactory.logger error:@"Unable to open deep link (%@)", deepLinkUrl];
            }
        };
        [invocation setArgument:&deepLinkUrl atIndex: 2];
        [invocation setArgument:&emptyDictionary atIndex: 3];
        [invocation setArgument:&completion atIndex: 4];
        [invocation invoke];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        BOOL success = [sharedUIApplication openURL:deepLinkUrl];
#pragma clang diagnostic pop
        if (!success) {
            [ADTAdtraceFactory.logger error:@"Unable to open deep link without completionHandler (%@)", deepLinkUrl];
        }
    }
#endif
}

// adapted from https://stackoverflow.com/a/9084784
+ (NSString *)convertDeviceToken:(NSData *)deviceToken {
    NSUInteger dataLength  = [deviceToken length];

    if (dataLength == 0) {
        return nil;
    }

    const unsigned char *dataBuffer = (const unsigned char *)[deviceToken bytes];

    if (!dataBuffer) {
        return nil;
    }

    NSMutableString *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];

    for (NSUInteger i = 0; i < dataLength; ++i) {
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    }

    return [hexString copy];
}

+ (BOOL)checkAttributionDetails:(NSDictionary *)attributionDetails {
    if ([ADTUtil isNull:attributionDetails]) {
        return NO;
    }

    NSDictionary *details = [attributionDetails objectForKey:@"Version3.1"];
    if ([ADTUtil isNull:details]) {
        return YES;
    }

    // Common fields for both iAd3 and Apple Search Ads
    if (![ADTUtil contains:details key:@"iad-org-name" value:@"OrgName"] ||
        ![ADTUtil contains:details key:@"iad-campaign-id" value:@"1234567890"] ||
        ![ADTUtil contains:details key:@"iad-campaign-name" value:@"CampaignName"] ||
        ![ADTUtil contains:details key:@"iad-lineitem-id" value:@"1234567890"] ||
        ![ADTUtil contains:details key:@"iad-lineitem-name" value:@"LineName"]) {
        [ADTAdtraceFactory.logger debug:@"iAd attribution details has dummy common fields for both iAd3 and Apple Search Ads"];
        return YES;
    }
    // Apple Search Ads fields
    if ([ADTUtil contains:details key:@"iad-adgroup-id" value:@"1234567890"] &&
        [ADTUtil contains:details key:@"iad-adgroup-name" value:@"AdgroupName"] &&
        [ADTUtil contains:details key:@"iad-keyword" value:@"Keyword"]) {
        [ADTAdtraceFactory.logger debug:@"iAd attribution details has dummy Apple Search Ads fields"];
        return NO;
    }
    // iAd3 fields
    if ([ADTUtil contains:details key:@"iad-adgroup-id" value:@"1234567890"] &&
        [ADTUtil contains:details key:@"iad-creative-name" value:@"CreativeName"]) {
        [ADTAdtraceFactory.logger debug:@"iAd attribution details has dummy iAd3 fields"];
        return NO;
    }

    return YES;
}

+ (BOOL)contains:(NSDictionary *)dictionary
        key:(NSString *)key
        value:(NSString *)value {
    id readValue = [dictionary objectForKey:key];
    if ([ADTUtil isNull:readValue]) {
        return NO;
    }
    return [value isEqualToString:[readValue description]];
}

+ (NSNumber *)readReachabilityFlags {
    if (reachability == nil) {
        return nil;
    }
    return [reachability currentReachabilityFlags];
}

+ (BOOL)isDeeplinkValid:(NSURL *)url {
    if (url == nil) {
        return NO;
    }
    if ([[url absoluteString] length] == 0) {
        return NO;
    }
    if (excludedDeeplinkRegex == nil) {
        [ADTAdtraceFactory.logger error:@"Excluded deep link regex not correctly configured"];
        return NO;
    }

    NSString *urlString = [url absoluteString];
    NSArray<NSTextCheckingResult *> *matches = [excludedDeeplinkRegex matchesInString:urlString
                                                                              options:0
                                                                                range:NSMakeRange(0, [urlString length])];
    if ([matches count] > 0) {
        [ADTAdtraceFactory.logger debug:@"Deep link (%@) processing skipped", urlString];
        return NO;
    }

    return YES;
}

+ (NSString *)sdkVersion {
    return kClientSdk;
}

+ (NSString *)readMCC {
#if TARGET_OS_TV || TARGET_OS_MACCATALYST
    return nil;
#else
    if (carrier == nil) {
        return nil;
    }
    return [carrier mobileCountryCode];
#endif
}

+ (NSString *)readMNC {
#if TARGET_OS_TV || TARGET_OS_MACCATALYST
    return nil;
#else
    if (carrier == nil) {
        return nil;
    }
    return [carrier mobileNetworkCode];
#endif
}

+ (NSString *)readCurrentRadioAccessTechnology {
#if TARGET_OS_TV || TARGET_OS_MACCATALYST
    return nil;
#else
    if (networkInfo == nil) {
        return nil;
    }
    SEL radioTechSelector = NSSelectorFromString(@"currentRadioAccessTechnology");
    if (![networkInfo respondsToSelector:radioTechSelector]) {
        return nil;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    id radioTech = [networkInfo performSelector:radioTechSelector];
#pragma clang diagnostic pop
    return radioTech;
#endif
}

+ (NSString *)stringToBinaryString:(NSString *)str {
    if (str == nil) {
        return nil;
    }
    NSMutableString *binStr = [[NSMutableString alloc] init];
    const char *cstr = [str UTF8String];
    size_t len = strlen(cstr);
    for (size_t i = 0; i < len; i++) {
        uint8_t c = cstr[i];
        for (int j = 0; j < 8; j++) {
            [binStr appendString:((c & 0x80) ? @"1" : @"0")];
            c <<= 1;
        }
    }
    return binStr;
}

+ (NSString *)decimalToBinaryString:(NSUInteger)decInt {
    if (decInt == 0) {
        return @"0";
    }
    NSString *string = @"" ;
    NSUInteger x = decInt;
    while (x > 0) {
        string = [[NSString stringWithFormat: @"%lu", x&1] stringByAppendingString:string];
        x = x >> 1;
    }
    return string;
}

+ (NSString *)enforceParameterLength:(NSString *)parameter
                       withMaxlength:(int)maxLength {
    if (parameter == nil) {
        // failed to read parameter
        // fill in with zeros
        NSString *failed = @"";
        for (int i = 0; i < maxLength; i += 1) {
            failed = [failed stringByAppendingString:@"0"];
        }
        return failed;
    }
    if (parameter.length == maxLength) {
        // all dandy
        return parameter;
    }
    if (parameter.length > maxLength) {
        // overflow
        // in overflow case, fill parameter with all ones
        NSString *stringOverflow = @"";
        for (int i = 0; i < maxLength; i += 1) {
            stringOverflow = [stringOverflow stringByAppendingString:@"1"];
        }
        return stringOverflow;
    }
    // parameter too short
    // expand it with prepended zeros to fit the protocol
    NSString *expandedParameter = [NSString stringWithString:parameter];
    for (int i = 0; i < maxLength - parameter.length; i += 1) {
        expandedParameter = [@"0" stringByAppendingString:expandedParameter];
    }
    return expandedParameter;
}

@end
