







#import <Foundation/Foundation.h>

@interface AdtraceLoggingHelper : NSObject

+ (id)sharedInstance;

- (void)logText:(NSString *)text;

@end
