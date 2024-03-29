
#import "ADTActivityKind.h"
#import "ADTActivityPackage.h"

@implementation ADTActivityPackage

#pragma mark - Public methods

- (NSString *)extendedString {
    NSMutableString *builder = [NSMutableString string];
    NSArray *excludedKeys = @[
        @"secret_id",
        @"app_secret",
        @"signature",
        @"headers_id",
        @"native_version",
        @"adt_signing_id"];

    [builder appendFormat:@"Path:      %@\n", self.path];
    [builder appendFormat:@"ClientSdk: %@\n", self.clientSdk];

    if (self.parameters != nil) {
        NSArray *sortedKeys = [[self.parameters allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
        NSUInteger keyCount = [sortedKeys count];

        [builder appendFormat:@"Parameters:"];
        
        for (NSUInteger i = 0; i < keyCount; i++) {
            NSString *key = (NSString *)[sortedKeys objectAtIndex:i];

            if ([excludedKeys containsObject:key]) {
                continue;
            }

            NSString *value = [self.parameters objectForKey:key];
            
            [builder appendFormat:@"\n\t\t%-22s %@", [key UTF8String], value];
        }
    }

    return builder;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@%@", [ADTActivityKindUtil activityKindToString:self.activityKind], self.suffix];
}

- (NSString *)successMessage {
    return [NSString stringWithFormat:@"Tracked %@%@", [ADTActivityKindUtil activityKindToString:self.activityKind], self.suffix];
}

- (NSString *)failureMessage {
    return [NSString stringWithFormat:@"Failed to track %@%@", [ADTActivityKindUtil activityKindToString:self.activityKind], self.suffix];
}

#pragma mark - NSCoding protocol methods

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];

    if (self == nil) {
        return self;
    }

    self.path = [decoder decodeObjectForKey:@"path"];
    self.suffix = [decoder decodeObjectForKey:@"suffix"];
    self.clientSdk = [decoder decodeObjectForKey:@"clientSdk"];
    self.parameters = [decoder decodeObjectForKey:@"parameters"];
    self.partnerParameters = [decoder decodeObjectForKey:@"partnerParameters"];
    self.callbackParameters = [decoder decodeObjectForKey:@"callbackParameters"];
    self.eventValueParameters = [decoder decodeObjectForKey:@"eventValueParameters"];

    NSString *kindString = [decoder decodeObjectForKey:@"kind"];
    self.activityKind = [ADTActivityKindUtil activityKindFromString:kindString];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    NSString *kindString = [ADTActivityKindUtil activityKindToString:self.activityKind];

    [encoder encodeObject:self.path forKey:@"path"];
    [encoder encodeObject:kindString forKey:@"kind"];
    [encoder encodeObject:self.suffix forKey:@"suffix"];
    [encoder encodeObject:self.clientSdk forKey:@"clientSdk"];
    [encoder encodeObject:self.parameters forKey:@"parameters"];
    [encoder encodeObject:self.partnerParameters forKey:@"partnerParameters"];
    [encoder encodeObject:self.callbackParameters forKey:@"callbackParameters"];
    [encoder encodeObject:self.eventValueParameters forKey:@"eventValueParameters"];
}

@end
