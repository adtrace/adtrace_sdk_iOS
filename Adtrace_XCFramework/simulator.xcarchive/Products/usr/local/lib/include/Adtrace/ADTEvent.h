







#import <Foundation/Foundation.h>


@interface ADTEvent : NSObject<NSCopying>


@property (nonatomic, copy, readonly, nonnull) NSNumber *revenue;


@property (nonatomic, copy, readonly, nonnull) NSString *eventToken;


@property (nonatomic, copy, readonly, nonnull) NSString *transactionId;


@property (nonatomic, copy, readonly, nonnull) NSString *callbackId;


@property (nonatomic, copy, readonly, nonnull) NSString *currency;


@property (nonatomic, copy, readonly, nonnull) NSData *receipt;


@property (nonatomic, readonly, nonnull) NSDictionary *eventParameters;


@property (nonatomic, readonly, nonnull) NSDictionary *callbackParameters;


@property (nonatomic, assign, readonly) BOOL emptyReceipt;


+ (nullable ADTEvent *)eventWithEventToken:(nonnull NSString *)eventToken;

- (nullable id)initWithEventToken:(nonnull NSString *)eventToken;


- (void)addCallbackParameter:(nonnull NSString *)key value:(nonnull NSString *)value;


- (void)addEventParameter:(nonnull NSString *)key value:(nonnull NSString *)value;


- (void)setRevenue:(double)amount currency:(nonnull NSString *)currency;


- (void)setTransactionId:(nonnull NSString *)transactionId;


- (void)setCallbackId:(nonnull NSString *)callbackId;


- (BOOL)isValid;


- (void)setReceipt:(nonnull NSData *)receipt transactionId:(nonnull NSString *)transactionId;

@end
