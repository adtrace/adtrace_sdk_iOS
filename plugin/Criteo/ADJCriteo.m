//
//  ADJCriteoEvents.m
//
//
//  Created by Pedro Filipe on 06/02/15.
//
//

#import "Adjust.h"
#import "ADJCriteo.h"
#import "ADJAdjustFactory.h"

static const NSUInteger MAX_VIEW_LISTING_PRODUCTS = 3;

@implementation ADJCriteoProduct

- (id)initWithId:(NSString *)productId price:(float)price quantity:(NSUInteger)quantity {
    self = [super init];

    if (self == nil) {
        return nil;
    }

    self.criteoPrice = price;
    self.criteoQuantity = quantity;
    self.criteoProductID = productId;

    return self;
}

+ (ADJCriteoProduct *)productWithId:(NSString *)productId price:(float)price quantity:(NSUInteger)quantity {
    return [[ADJCriteoProduct alloc] initWithId:productId price:price quantity:quantity];
}

@end

@implementation ADJCriteo

static NSString * hashEmailInternal;
static NSString * partnerIdInternal;
static NSString * customerIdInternal;
static NSString * userSegmentInternal;
static NSString * checkInDateInternal;
static NSString * checkOutDateInternal;

+ (id<ADJLogger>)logger {
    return ADJAdjustFactory.logger;
}

+ (void)injectViewSearchIntoEvent:(ADJEvent *)event checkInDate:(NSString *)din checkOutDate:(NSString *)dout {
    [event addPartnerParameter:@"din" value:din];
    [event addPartnerParameter:@"dout" value:dout];

    [ADJCriteo injectOptionalParams:event];
}

+ (void)injectViewListingIntoEvent:(ADJEvent *)event productIds:(NSArray *)productIds {
    NSString *jsonProductsIds = [ADJCriteo createCriteoVLFromProducts:productIds];
    [event addPartnerParameter:@"criteo_p" value:jsonProductsIds];

    [ADJCriteo injectOptionalParams:event];
}

+ (void)injectViewProductIntoEvent:(ADJEvent *)event productId:(NSString *)productId {
    [event addPartnerParameter:@"criteo_p" value:productId];

    [ADJCriteo injectOptionalParams:event];
}

+ (void)injectCartIntoEvent:(ADJEvent *)event products:(NSArray *)products {
    NSString *jsonProducts = [ADJCriteo createCriteoVBFromProducts:products];
    [event addPartnerParameter:@"criteo_p" value:jsonProducts];

    [ADJCriteo injectOptionalParams:event];
}

+ (void)injectTransactionConfirmedIntoEvent:(ADJEvent *)event
                                   products:(NSArray *)products
                              transactionId:(NSString *)transactionId
                                newCustomer:(NSString *)newCustomer {
    [event addPartnerParameter:@"transaction_id" value:transactionId];

    NSString *jsonProducts = [ADJCriteo createCriteoVBFromProducts:products];
    [event addPartnerParameter:@"criteo_p" value:jsonProducts];
    [event addPartnerParameter:@"new_customer" value:newCustomer];

    [ADJCriteo injectOptionalParams:event];
}

+ (void)injectUserLevelIntoEvent:(ADJEvent *)event uiLevel:(NSUInteger)uiLevel {
    NSString *uiLevelString = [NSString stringWithFormat:@"%lu",(unsigned long)uiLevel];
    [event addPartnerParameter:@"ui_level" value:uiLevelString];

    [ADJCriteo injectOptionalParams:event];
}

+ (void)injectUserStatusIntoEvent:(ADJEvent *)event uiStatus:(NSString *)uiStatus {
    [event addPartnerParameter:@"ui_status" value:uiStatus];

    [ADJCriteo injectOptionalParams:event];
}

+ (void)injectAchievementUnlockedIntoEvent:(ADJEvent *)event uiAchievement:(NSString *)uiAchievement {
    [event addPartnerParameter:@"ui_achievmnt" value:uiAchievement];

    [ADJCriteo injectOptionalParams:event];
}

+ (void)injectCustomEventIntoEvent:(ADJEvent *)event uiData:(NSString *)uiData {
    [event addPartnerParameter:@"ui_data" value:uiData];

    [ADJCriteo injectOptionalParams:event];
}

+ (void)injectCustomEvent2IntoEvent:(ADJEvent *)event uiData2:(NSString *)uiData2 uiData3:(NSUInteger)uiData3 {
    [event addPartnerParameter:@"ui_data2" value:uiData2];

    NSString *uiData3String = [NSString stringWithFormat:@"%lu",(unsigned long)uiData3];
    [event addPartnerParameter:@"ui_data3" value:uiData3String];

    [ADJCriteo injectOptionalParams:event];
}

+ (void)injectDeeplinkIntoEvent:(ADJEvent *)event url:(NSURL *)url {
    if (url == nil) {
        return;
    }

    [event addPartnerParameter:@"criteo_deeplink" value:[url absoluteString]];

    [ADJCriteo injectOptionalParams:event];
}

+ (void)injectHashedEmailIntoCriteoEvents:(NSString *)hashEmail {
    hashEmailInternal = hashEmail;
}

+ (void)injectViewSearchDatesIntoCriteoEvents:(NSString *)checkInDate checkOutDate:(NSString *)checkOutDate {
    checkInDateInternal = checkInDate;
    checkOutDateInternal = checkOutDate;
}

+ (void)injectPartnerIdIntoCriteoEvents:(NSString *)partnerId {
    partnerIdInternal = partnerId;
}

+ (void)injectUserSegmentIntoCriteoEvents:(NSString *)userSegment {
    userSegmentInternal = userSegment;
}

+ (void)injectCustomerIdIntoCriteoEvents:(NSString *)customerId {
    customerIdInternal = customerId;
}

+ (void)injectOptionalParams:(ADJEvent *)event {
    [ADJCriteo injectHashEmail:event];
    [ADJCriteo injectSearchDates:event];
    [ADJCriteo injectPartnerId:event];
    [ADJCriteo injectUserSegment:event];
    [ADJCriteo injectCustomerId:event];
}

+ (void)injectHashEmail:(ADJEvent *)event {
    if (hashEmailInternal == nil) {
        return;
    }

    [event addPartnerParameter:@"criteo_email_hash" value:hashEmailInternal];
}

+ (void)injectSearchDates:(ADJEvent *)event {
    if (checkInDateInternal == nil || checkOutDateInternal == nil) {
        return;
    }

    [event addPartnerParameter:@"din" value:checkInDateInternal];
    [event addPartnerParameter:@"dout" value:checkOutDateInternal];
}

+ (void)injectPartnerId:(ADJEvent *)event {
    if (partnerIdInternal == nil) {
        return;
    }

    [event addPartnerParameter:@"criteo_partner_id" value:partnerIdInternal];
}

+ (void)injectUserSegment:(ADJEvent *)event {
    if (userSegmentInternal == nil) {
        return;
    }

    [event addPartnerParameter:@"user_segment" value:userSegmentInternal];
}

+ (void)injectCustomerId:(ADJEvent *)event {
    if (customerIdInternal == nil) {
        return;
    }

    [event addPartnerParameter:@"customer_id" value:customerIdInternal];
}

+ (NSString *)createCriteoVBFromProducts:(NSArray *)products {
    if (products == nil) {
        [self.logger warn:@"Criteo Event product list is nil. It will sent as empty."];
        products = @[];
    }

    NSUInteger productsCount = [products count];
    NSMutableString *criteoVBValue = [NSMutableString stringWithString:@"["];
    
    for (NSUInteger i = 0; i < productsCount;) {
        id productAtIndex = [products objectAtIndex:i];

        if (![productAtIndex isKindOfClass:[ADJCriteoProduct class]]) {
            [self.logger error:@"Criteo Event should contain a list of ADJCriteoProduct"];
            return nil;
        }

        ADJCriteoProduct *product = (ADJCriteoProduct *)productAtIndex;
        NSString *productString = [NSString stringWithFormat:@"{\"i\":\"%@\",\"pr\":%f,\"q\":%lu}",
                                   [product criteoProductID],
                                   [product criteoPrice],
                                   (unsigned long)[product criteoQuantity]];

        [criteoVBValue appendString:productString];

        i++;

        if (i == productsCount) {
            break;
        }

        [criteoVBValue appendString:@","];
    }

    [criteoVBValue appendString:@"]"];

    return [criteoVBValue stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

+ (NSString *)createCriteoVLFromProducts:(NSArray *)productIds {
    if (productIds == nil) {
        [self.logger warn:@"Criteo View Listing product ids list is nil. It will sent as empty."];
        productIds = @[];
    }

    NSUInteger productsIdCount = [productIds count];

    if (productsIdCount > MAX_VIEW_LISTING_PRODUCTS) {
        [self.logger warn:@"Criteo View Listing should only have at most 3 product ids. The rest will be discarded."];
    }

    NSMutableString *criteoVLValue = [NSMutableString stringWithString:@"["];

    for (NSUInteger i = 0; i < productsIdCount;) {
        id productAtIndex = [productIds objectAtIndex:i];
        NSString *productId;
        
        if ([productAtIndex isKindOfClass:[NSString class]]) {
            productId = productAtIndex;
        } else if ([productAtIndex isKindOfClass:[ADJCriteoProduct class]]) {
            ADJCriteoProduct *criteoProduct = (ADJCriteoProduct *)productAtIndex;
            productId = [criteoProduct criteoProductID];
            
            [self.logger warn:@"Criteo View Listing should contain a list of product ids, not of ADJCriteoProduct. Reading the product id of the ADJCriteoProduct."];
        } else {
            return nil;
        }

        NSString *productIdEscaped = [NSString stringWithFormat:@"\"%@\"", productId];

        [criteoVLValue appendString:productIdEscaped];

        i++;

        if (i == productsIdCount || i >= MAX_VIEW_LISTING_PRODUCTS) {
            break;
        }

        [criteoVLValue appendString:@","];
    }

    [criteoVLValue appendString:@"]"];

    return [criteoVLValue stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

@end
