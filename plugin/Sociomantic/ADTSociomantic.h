/**
 * ADTSociomantic.m
 * Adtrace
 *
 * Created by Nicolas Brugneaux on 17/02/15.
 * Copyright (c) 2015 Sociomantic Labs. All rights reserved.
 */

#import <Foundation/Foundation.h>

#import "Adtrace.h"

///----------------------------
/// @name Sociomantic Aliases
///----------------------------

extern NSString * __nonnull const SCMCategory;
extern NSString * __nonnull const SCMProductName;
extern NSString * __nonnull const SCMSalePrice;
extern NSString * __nonnull const SCMAmount;
extern NSString * __nonnull const SCMCurrency;
extern NSString * __nonnull const SCMProductURL;
extern NSString * __nonnull const SCMProductImageURL;
extern NSString * __nonnull const SCMBrand;
extern NSString * __nonnull const SCMDescription;
extern NSString * __nonnull const SCMTimestamp;
extern NSString * __nonnull const SCMValidityTimestamp;
extern NSString * __nonnull const SCMQuantity;
extern NSString * __nonnull const SCMScore;
extern NSString * __nonnull const SCMProductID;
extern NSString * __nonnull const SCMAmount;
extern NSString * __nonnull const SCMCurrency;
extern NSString * __nonnull const SCMQuantity;
extern NSString * __nonnull const SCMAmount;
extern NSString * __nonnull const SCMCurrency;
extern NSString * __nonnull const SCMActionConfirmed;
extern NSString * __nonnull const SCMActionConfirmed;
extern NSString * __nonnull const SCMCustomerAgeGroup;
extern NSString * __nonnull const SCMCustomerEducation;
extern NSString * __nonnull const SCMCustomerGender;
extern NSString * __nonnull const SCMCustomerID;
extern NSString * __nonnull const SCMCustomerMHash;
extern NSString * __nonnull const SCMCustomerSegment;
extern NSString * __nonnull const SCMCustomerTargeting;

///--------------------------------
/// @name Adtrace Sociomantic Events
///--------------------------------

/**
 * Object exposing the different methods of the Sociomantic plugin for Adtrace.
 */
@interface ADTSociomantic : NSObject

/**
 * Methods uses the given string, stores it into a singleton, it'll be injected into every
 * further sociomantic event.
 *
 * @param   adpanId           `NSString`
 *
 */
+ (void)injectPartnerIdIntoSociomanticEvents:(nullable NSString *)adpanId;

/**
 * Methods uses the given dictionary, filters it and injects it into the event.
 *
 * @param   event           `ADTEvent`
 * @param   data            `NSDictionary`
 *
 */
+ (void)injectCustomerDataIntoEvent:(nullable ADTEvent *)event
                           withData:(nullable NSDictionary *)data;


/**
 * Method makes sure the event has the adpanId into the event.
 *
 * @param   event           `ADTEvent`
 *
 */
+ (void)addPartnerParameter:(nullable ADTEvent *)event;


/**
 * Method makes sure the event has the adpanId into the event and injects the json 
 * value into the partner parameter.
 *
 * @param   event           `ADTEvent`
 *
 */
+ (void)addPartnerParameter:(nullable ADTEvent *)event
                  parameter:(nullable NSString *)parameterName
                      value:(nullable NSString *)jsonValue;

/**
 * Method injects a home page view into an Adtrace event.
 *
 * @param   event           `ADTEvent`
 *
 */
+ (void)injectHomePageIntoEvent:(nullable ADTEvent *)event;


/**
 * Method injects a category page view into an Adtrace event.
 *
 * Note: the category array will be filtered to only contain strings.
 *
 * @param   event           `ADTEvent`
 * @param   categories      `NSArray`
 *
 */
+ (void)injectViewListingIntoEvent:(nullable ADTEvent *)event
                    withCategories:(nullable NSArray *)categories;

/**
 * Method injects a category page view into an Adtrace event.
 *
 * Note: the category array will be filtered to only contain strings.
 *
 * @param   event           `ADTEvent`
 * @param   categories      `NSArray`
 * @param   date            `NSString`
 *
 */
+ (void)injectViewListingIntoEvent:(nullable ADTEvent *)event
                    withCategories:(nullable NSArray *)categories
                          withDate:(nullable NSString *)date;

/**
 * Method injects a product page view into an Adtrace event.
 *
 * @param   event           `ADTEvent`
 * @param   productId       `NSString`
 *
 */
+ (void)injectViewProductIntoEvent:(nullable ADTEvent *)event
                         productId:(nullable NSString *)productId;

/**
 * Method injects a product page view into an Adtrace event.
 * Parameters dictionary will be filtered by keys and only keep the key-value
 * pairs where the key can be found in the
 * `SCMSingleton.properties[@"product"]` dictionary. These keys can be also
 * found in the file `SCMAliases.h`.
 *
 * @param   event           `ADTEvent`
 * @param   productId       `NSString`
 * @param   parameters      `NSDictionary`
 *
 */
+ (void)injectViewProductIntoEvent:(nullable ADTEvent *)event
                         productId:(nullable NSString *)productId
                    withParameters:(nullable NSDictionary *)parameters;

/**
 * Method injects a basket page view. The basket into an Adtrace event.
 * used to create the request is the given array of products.
 * The array will be filtered according to the keys of
 * `SCMSingleton.properties[@"basket"]`.
 *
 * @param   event           `ADTEvent`
 * @param   products        `NSArray`
 *
 */
+ (void)injectCartIntoEvent:(nullable ADTEvent *)event
                       cart:(nullable NSArray *)products;


/**
 * Method injects a confirmed sale page view into an Adtrace event.
 * The array will be filtered according to the keys of
 * `SCMSingleton.properties[@"basket"]`.
 *
 * @param   event           `ADTEvent`
 * @param   transactionID   `NSString`
 * @param   products        `NSArray`
 *
 */
+ (void)injectConfirmedTransactionIntoEvent:(nullable ADTEvent *)event
                              transactionId:(nullable NSString *)transactionID
                               withProducts:(nullable NSArray *)products;

/**
 * Method injects a confirmed sale page view into an Adtrace event.
 * The array will be filtered according to the keys of
 * `SCMSingleton.properties[@"basket"]`.
 * The same thing for the transaction option parameters, they are filtered
 * according to SCMSingleton.properties[@"sale"]`
 *
 * @param   event           `ADTEvent`
 * @param   transactionID   `NSString`
 * @param   products        `NSArray`
 * @param   parameters      `NSDictionary`
 *
 */
+ (void)injectConfirmedTransactionIntoEvent:(nullable ADTEvent *)event
                              transactionId:(nullable NSString *)transactionID
                               withProducts:(nullable NSArray *)products
                             withParameters:(nullable NSDictionary *)parameters;

/**
 * Method injects a non-confirmed sale page view into an Adtrace event.
 * The array will be filtered according to the keys of
 * `SCMSingleton.properties[@"basket"]`.
 * The same thing for the transaction option parameters, they are filtered
 * according to SCMSingleton.properties[@"sale"]`
 *
 * @param   event           `ADTEvent`
 * @param   transactionID   `NSString`
 * @param   products        `NSArray`
 *
 */
+ (void)injectTransactionIntoEvent:(nullable ADTEvent *)event
                     transactionId:(nullable NSString *)transactionID
                      withProducts:(nullable NSArray *)products;
/**
 * Method injects a sale page view into an Adtrace event.
 * The array will be filtered according to the keys of
 * `SCMSingleton.properties[@"basket"]`.
 * The same thing for the transaction option parameters, they are filtered
 * according to SCMSingleton.properties[@"sale"]`
 *
 * @param   event           `ADTEvent`
 * @param   transactionID   `NSString`
 * @param   products        `NSArray`
 * @param   parameters      `NSDictionary`
 *
 */
+ (void)injectTransactionIntoEvent:(nullable ADTEvent *)event
                     transactionId:(nullable NSString *)transactionID
                      withProducts:(nullable NSArray *)products
                    withParameters:(nullable NSDictionary *)parameters;

/**
 * Method injects a lead page into an Adtrace event.
 *
 * @param   event           `ADTEvent`
 * @param   transactionID   `NSString`
 *
 */
+ (void)injectLeadIntoEvent:(nullable ADTEvent *)event
                     leadID:(nullable NSString *)transactionID;

/**
 * Method injects a lead page into an Adtrace event.
 * It can be confirmed or not.
 *
 * @param   event           `ADTEvent`
 * @param   transactionID   `NSString`
 *
 */
+ (void)injectLeadIntoEvent:(nullable ADTEvent *)event
                     leadID:(nullable NSString *)transactionID
               andConfirmed:(BOOL)confirmed;

@end
