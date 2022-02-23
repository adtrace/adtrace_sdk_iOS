







#import <Foundation/Foundation.h>


@interface ADTAdRevenue : NSObject<NSCopying>


@property (nonatomic, copy, readonly, nonnull) NSString *source;


@property (nonatomic, copy, readonly, nonnull) NSNumber *revenue;


@property (nonatomic, copy, readonly, nonnull) NSString *currency;


@property (nonatomic, copy, readonly, nonnull) NSNumber *adImpressionsCount;


@property (nonatomic, copy, readonly, nonnull) NSString *adRevenueNetwork;


@property (nonatomic, copy, readonly, nonnull) NSString *adRevenueUnit;


@property (nonatomic, copy, readonly, nonnull) NSString *adRevenuePlacement;


@property (nonatomic, copy, readonly, nonnull) NSDictionary *partnerParameters;


@property (nonatomic, copy, readonly, nonnull) NSDictionary *callbackParameters;


- (nullable id)initWithSource:(nonnull NSString *)source;

- (void)setRevenue:(double)amount currency:(nonnull NSString *)currency;

- (void)setAdImpressionsCount:(int)adImpressionsCount;

- (void)setAdRevenueNetwork:(nonnull NSString *)adRevenueNetwork;

- (void)setAdRevenueUnit:(nonnull NSString *)adRevenueUnit;

- (void)setAdRevenuePlacement:(nonnull NSString *)adRevenuePlacement;

- (void)addCallbackParameter:(nonnull NSString *)key value:(nonnull NSString *)value;

- (void)addPartnerParameter:(nonnull NSString *)key value:(nonnull NSString *)value;

- (BOOL)isValid;

@end
