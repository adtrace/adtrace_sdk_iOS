//
//  ADTCriteoEvents.m
//
//
//  Created by Pedro Filipe on 06/02/15.
//
//

#import "Adtrace.h"
#import "ADTCriteo.h"
#import "ADTAdtraceFactory.h"

static const NSUInteger MAX_VIEW_LISTING_PRODUCTS = 3;

@implementation ADTCriteoProduct

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

+ (ADTCriteoProduct *)productWithId:(NSString *)productId price:(float)price quantity:(NSUInteger)quantity {
    return [[ADTCriteoProduct alloc] initWithId:productId price:price quantity:quantity];
}

@end

@implementation ADTCriteo

static NSString * hashEmailInternal;
static NSString * partnerIdInternal;
static NSString * customerIdInternal;
static NSString * userSegmentInternal;
static NSString * checkInDateInternal;
static NSString * checkOutDateInternal;

+ (id<ADTLogger>)logger {
    return ADTAdtraceFactory.logger;
}

+ (void)injectViewSearchIntoEvent:(ADTEvent *)event checkInDate:(NSString *)din checkOutDate:(NSString *)dout {
    [event addPartnerParameter:@"din" value:din];
    [event addPartnerParameter:@"dout" value:dout];

    [ADTCriteo injectOptionalParams:event];
}

+ (void)injectViewListingIntoEvent:(ADTEvent *)event productIds:(NSArray *)productIds {
    NSString *jsonProductsIds = [ADTCriteo createCriteoVLFromProducts:productIds];
    [event addPartnerParameter:@"criteo_p" value:jsonProductsIds];

    [ADTCriteo injectOptionalParams:event];
}

+ (void)injectViewProductIntoEvent:(ADTEvent *)event productId:(NSString *)productId {
    [event addPartnerParameter:@"criteo_p" value:productId];

    [ADTCriteo injectOptionalParams:event];
}

+ (void)injectCartIntoEvent:(ADTEvent *)event products:(NSArray *)products {
    NSString *jsonProducts = [ADTCriteo createCriteoVBFromProducts:products];
    [event addPartnerParameter:@"criteo_p" value:jsonProducts];

    [ADTCriteo injectOptionalParams:event];
}

+ (void)injectTransactionConfirmedIntoEvent:(ADTEvent *)event
                                   products:(NSArray *)products
                              transactionId:(NSString *)transactionId
                                newCustomer:(NSString *)newCustomer {
    [event addPartnerParameter:@"transaction_id" value:transactionId];

    NSString *jsonProducts = [ADTCriteo createCriteoVBFromProducts:products];
    [event addPartnerParameter:@"criteo_p" value:jsonProducts];
    [event addPartnerParameter:@"new_customer" value:newCustomer];

    [ADTCriteo injectOptionalParams:event];
}

+ (void)injectUserLevelIntoEvent:(ADTEvent *)event uiLevel:(NSUInteger)uiLevel {
    NSString *uiLevelString = [NSString stringWithFormat:@"%lu",(unsigned long)uiLevel];
    [event addPartnerParameter:@"ui_level" value:uiLevelString];

    [ADTCriteo injectOptionalParams:event];
}

+ (void)injectUserStatusIntoEvent:(ADTEvent *)event uiStatus:(NSString *)uiStatus {
    [event addPartnerParameter:@"ui_status" value:uiStatus];

    [ADTCriteo injectOptionalParams:event];
}

+ (void)injectAchievementUnlockedIntoEvent:(ADTEvent *)event uiAchievement:(NSString *)uiAchievement {
    [event addPartnerParameter:@"ui_achievmnt" value:uiAchievement];

    [ADTCriteo injectOptionalParams:event];
}

+ (void)injectCustomEventIntoEvent:(ADTEvent *)event uiData:(NSString *)uiData {
    [event addPartnerParameter:@"ui_data" value:uiData];

    [ADTCriteo injectOptionalParams:event];
}

+ (void)injectCustomEvent2IntoEvent:(ADTEvent *)event uiData2:(NSString *)uiData2 uiData3:(NSUInteger)uiData3 {
    [event addPartnerParameter:@"ui_data2" value:uiData2];

    NSString *uiData3String = [NSString stringWithFormat:@"%lu",(unsigned long)uiData3];
    [event addPartnerParameter:@"ui_data3" value:uiData3String];

    [ADTCriteo injectOptionalParams:event];
}

+ (void)injectDeeplinkIntoEvent:(ADTEvent *)event url:(NSURL *)url {
    if (url == nil) {
        return;
    }

    [event addPartnerParameter:@"criteo_deeplink" value:[url absoluteString]];

    [ADTCriteo injectOptionalParams:event];
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

+ (void)injectOptionalParams:(ADTEvent *)event {
    [ADTCriteo injectHashEmail:event];
    [ADTCriteo injectSearchDates:event];
    [ADTCriteo injectPartnerId:event];
    [ADTCriteo injectUserSegment:event];
    [ADTCriteo injectCustomerId:event];
}

+ (void)injectHashEmail:(ADTEvent *)event {
    if (hashEmailInternal == nil) {
        return;
    }

    [event addPartnerParameter:@"criteo_email_hash" value:hashEmailInternal];
}

+ (void)injectSearchDates:(ADTEvent *)event {
    if (checkInDateInternal == nil || checkOutDateInternal == nil) {
        return;
    }

    [event addPartnerParameter:@"din" value:checkInDateInternal];
    [event addPartnerParameter:@"dout" value:checkOutDateInternal];
}

+ (void)injectPartnerId:(ADTEvent *)event {
    if (partnerIdInternal == nil) {
        return;
    }

    [event addPartnerParameter:@"criteo_partner_id" value:partnerIdInternal];
}

+ (void)injectUserSegment:(ADTEvent *)event {
    if (userSegmentInternal == nil) {
        return;
    }

    [event addPartnerParameter:@"user_segment" value:userSegmentInternal];
}

+ (void)injectCustomerId:(ADTEvent *)event {
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

        if (![productAtIndex isKindOfClass:[ADTCriteoProduct class]]) {
            [self.logger error:@"Criteo Event should contain a list of ADTCriteoProduct"];
            return nil;
        }

        ADTCriteoProduct *product = (ADTCriteoProduct *)productAtIndex;
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
        } else if ([productAtIndex isKindOfClass:[ADTCriteoProduct class]]) {
            ADTCriteoProduct *criteoProduct = (ADTCriteoProduct *)productAtIndex;
            productId = [criteoProduct criteoProductID];
            
            [self.logger warn:@"Criteo View Listing should contain a list of product ids, not of ADTCriteoProduct. Reading the product id of the ADTCriteoProduct."];
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
