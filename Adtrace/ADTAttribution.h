







#import <Foundation/Foundation.h>


@interface ADTAttribution : NSObject <NSCoding, NSCopying>


@property (nonatomic, copy, nullable) NSString *trackerToken;


@property (nonatomic, copy, nullable) NSString *trackerName;


@property (nonatomic, copy, nullable) NSString *network;


@property (nonatomic, copy, nullable) NSString *campaign;


@property (nonatomic, copy, nullable) NSString *adgroup;


@property (nonatomic, copy, nullable) NSString *creative;


@property (nonatomic, copy, nullable) NSString *clickLabel;


@property (nonatomic, copy, nullable) NSString *adid;


@property (nonatomic, copy, nullable) NSString *costType;


@property (nonatomic, copy, nullable) NSNumber *costAmount;


@property (nonatomic, copy, nullable) NSString *costCurrency;


+ (nullable ADTAttribution *)dataWithJsonDict:(nonnull NSDictionary *)jsonDict adid:(nonnull NSString *)adid;

- (nullable id)initWithJsonDict:(nonnull NSDictionary *)jsonDict adid:(nonnull NSString *)adid;


- (BOOL)isEqualToAttribution:(nonnull ADTAttribution *)attribution;


- (nullable NSDictionary *)dictionary;

@end
