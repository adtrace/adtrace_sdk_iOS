







#import <Foundation/Foundation.h>

@interface ADTSessionSuccess : NSObject <NSCopying>


@property (nonatomic, copy, nullable) NSString *message;


@property (nonatomic, copy, nullable) NSString *timeStamp;


@property (nonatomic, copy, nullable) NSString *adid;


@property (nonatomic, strong, nullable) NSDictionary *jsonResponse;


+ (nullable ADTSessionSuccess *)sessionSuccessResponseData;

- (nonnull id)copyWithZone:(nullable NSZone *)zone;

@end
