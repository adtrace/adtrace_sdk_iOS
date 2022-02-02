






#import <Foundation/Foundation.h>

typedef enum {
    ADTLogLevelVerbose  = 1,
    ADTLogLevelDebug    = 2,
    ADTLogLevelInfo     = 3,
    ADTLogLevelWarn     = 4,
    ADTLogLevelError    = 5,
    ADTLogLevelAssert   = 6,
    ADTLogLevelSuppress = 7
} ADTLogLevel;


@protocol ADTLogger


- (void)setLogLevel:(ADTLogLevel)logLevel isProductionEnvironment:(BOOL)isProductionEnvironment;


- (void)lockLogLevel;


- (void)verbose:(nonnull NSString *)message, ...;


- (void)debug:(nonnull NSString *)message, ...;


- (void)info:(nonnull NSString *)message, ...;


- (void)warn:(nonnull NSString *)message, ...;
- (void)warnInProduction:(nonnull NSString *)message, ...;


- (void)error:(nonnull NSString *)message, ...;


- (void)assert:(nonnull NSString *)message, ...;

@end


@interface ADTLogger : NSObject<ADTLogger>


+ (ADTLogLevel)logLevelFromString:(nonnull NSString *)logLevelString;

@end
