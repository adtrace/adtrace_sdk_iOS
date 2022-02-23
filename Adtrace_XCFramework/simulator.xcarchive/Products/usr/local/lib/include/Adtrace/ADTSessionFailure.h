







#import <Foundation/Foundation.h>

@interface ADTSessionFailure : NSObject <NSCopying>


@property (nonatomic, copy, nullable) NSString *message;


@property (nonatomic, copy, nullable) NSString *timeStamp;


@property (nonatomic, copy, nullable) NSString *adid;


@property (nonatomic, assign) BOOL willRetry;


@property (nonatomic, strong, nullable) NSDictionary *jsonResponse;


+ (nullable ADTSessionFailure *)sessionFailureResponseData;

- (nonnull id)copyWithZone:(nullable NSZone *)zone;

@end
