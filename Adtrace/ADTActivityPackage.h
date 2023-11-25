
#import "ADTActivityKind.h"

@interface ADTActivityPackage : NSObject <NSCoding>

// Data

@property (nonatomic, copy) NSString *path;

@property (nonatomic, copy) NSString *clientSdk;

@property (nonatomic, strong) NSMutableDictionary *parameters;

@property (nonatomic, strong) NSDictionary *partnerParameters;

@property (nonatomic, strong) NSDictionary *callbackParameters;

@property (nonatomic, strong) NSDictionary *eventValueParameters;

@property (nonatomic, copy) void (^purchaseVerificationCallback)(id);

// Logs

@property (nonatomic, copy) NSString *suffix;

@property (nonatomic, assign) ADTActivityKind activityKind;

- (NSString *)extendedString;

- (NSString *)successMessage;

- (NSString *)failureMessage;

@end
