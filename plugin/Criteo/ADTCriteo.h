//
//  ADTCriteoEvents.h
//
//
//  Created by Pedro Filipe on 06/02/15.
//
//

#import <Foundation/Foundation.h>

#import "ADTEvent.h"

@interface ADTCriteoProduct : NSObject

@property (nonatomic, assign) float criteoPrice;

@property (nonatomic, assign) NSUInteger criteoQuantity;

@property (nonatomic, copy, nullable) NSString *criteoProductID;

- (nullable id)initWithId:(nullable NSString *)productId price:(float)price quantity:(NSUInteger)quantity;

+ (nullable ADTCriteoProduct *)productWithId:(nullable NSString *)productId price:(float)price quantity:(NSUInteger)quantity;

@end

@interface ADTCriteo : NSObject

+ (void)injectPartnerIdIntoCriteoEvents:(nullable NSString *)partnerId;

+ (void)injectCustomerIdIntoCriteoEvents:(nullable NSString *)customerId;

+ (void)injectHashedEmailIntoCriteoEvents:(nullable NSString *)hashEmail;

+ (void)injectUserSegmentIntoCriteoEvents:(nullable NSString *)userSegment;

+ (void)injectDeeplinkIntoEvent:(nullable ADTEvent *)event url:(nullable NSURL *)url;

+ (void)injectCartIntoEvent:(nullable ADTEvent *)event products:(nullable NSArray *)products;

+ (void)injectUserLevelIntoEvent:(nullable ADTEvent *)event uiLevel:(NSUInteger)uiLevel;

+ (void)injectCustomEventIntoEvent:(nullable ADTEvent *)event uiData:(nullable NSString *)uiData;

+ (void)injectUserStatusIntoEvent:(nullable ADTEvent *)event uiStatus:(nullable NSString *)uiStatus;

+ (void)injectViewProductIntoEvent:(nullable ADTEvent *)event productId:(nullable NSString *)productId;

+ (void)injectViewListingIntoEvent:(nullable ADTEvent *)event productIds:(nullable NSArray *)productIds;

+ (void)injectAchievementUnlockedIntoEvent:(nullable ADTEvent *)event uiAchievement:(nullable NSString *)uiAchievement;

+ (void)injectViewSearchDatesIntoCriteoEvents:(nullable NSString *)checkInDate checkOutDate:(nullable NSString *)checkOutDate;

+ (void)injectCustomEvent2IntoEvent:(nullable ADTEvent *)event uiData2:(nullable NSString *)uiData2 uiData3:(NSUInteger)uiData3;

+ (void)injectTransactionConfirmedIntoEvent:(nullable ADTEvent *)event
                                   products:(nullable NSArray *)products
                              transactionId:(nullable NSString *)transactionId
                                newCustomer:(nullable NSString *)newCustomer;

@end
