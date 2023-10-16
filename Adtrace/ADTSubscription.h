







#import <Foundation/Foundation.h>

@interface ADTSubscription : NSObject<NSCopying>

@property (nonatomic, copy, readonly, nonnull) NSDecimalNumber *price;  

@property (nonatomic, copy, readonly, nonnull) NSString *currency;      

@property (nonatomic, copy, readonly, nonnull) NSString *transactionId; 

@property (nonatomic, copy, readonly, nonnull) NSData *receipt;         

@property (nonatomic, copy, readonly, nonnull) NSString *billingStore;  

@property (nonatomic, copy, readonly, nonnull) NSDate *transactionDate; 

@property (nonatomic, copy, readonly, nonnull) NSString *salesRegion;   

@property (nonatomic, copy, readonly, nonnull) NSDictionary *callbackParameters;    

@property (nonatomic, copy, readonly, nonnull) NSDictionary *partnerParameters;     

- (nullable id)initWithPrice:(nonnull NSDecimalNumber *)price
                    currency:(nonnull NSString *)currency
               transactionId:(nonnull NSString *)transactionId
                  andReceipt:(nonnull NSData *)receipt;

- (void)setTransactionDate:(nonnull NSDate *)transactionDate;

- (void)setSalesRegion:(nonnull NSString *)salesRegion;

- (void)addCallbackParameter:(nonnull NSString *)key value:(nonnull NSString *)value;

- (void)addPartnerParameter:(nonnull NSString *)key value:(nonnull NSString *)value;

@end
