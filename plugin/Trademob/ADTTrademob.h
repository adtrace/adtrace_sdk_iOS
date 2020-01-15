 //
//  ADTTrademob.h
//  Adtrace
//
//  Created by Davit Ohanyan on 9/14/15.
//  Copyright © 2015 adjust GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ADTEvent.h"

@interface ADTTrademobItem : NSObject

@property (nonatomic, assign) float price;

@property (nonatomic, assign) NSUInteger quantity;

@property (nonatomic, copy, nullable) NSString *itemId;

- (nullable instancetype)initWithId:(nullable NSString *)itemId price:(float)price quantity:(NSUInteger)quantity;

@end

@interface ADTTrademob : NSObject

+ (void)injectViewListingIntoEvent:(nullable ADTEvent *)event
                           itemIds:(nullable NSArray *)itemIds
                          metadata:(nullable NSDictionary *)metadata;

+ (void)injectViewItemIntoEvent:(nullable ADTEvent *)event
                         itemId:(nullable NSString *)itemId
                       metadata:(nullable NSDictionary *)metadata;


+ (void)injectAddToBasketIntoEvent:(nullable ADTEvent *)event
                             items:(nullable NSArray *)items
                          metadata:(nullable NSDictionary *)metadata;

+ (void)injectCheckoutIntoEvent:(nullable ADTEvent *)event
                          items:(nullable NSArray *)items
                       metadata:(nullable NSDictionary *)metadata;

@end
