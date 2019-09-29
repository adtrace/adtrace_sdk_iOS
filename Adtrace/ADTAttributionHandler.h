//
//  ADTAttributionHandler.h
//  adtrace
//
//  Created by Pedro Filipe on 29/10/14.
//  Copyright (c) 2014 adtrace GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADTActivityHandler.h"
#import "ADTActivityPackage.h"

@protocol ADTAttributionHandler

- (id)initWithActivityHandler:(id<ADTActivityHandler>) activityHandler
                startsSending:(BOOL)startsSending;

- (void)checkSessionResponse:(ADTSessionResponseData *)sessionResponseData;

- (void)checkSdkClickResponse:(ADTSdkClickResponseData *)sdkClickResponseData;

- (void)checkAttributionResponse:(ADTAttributionResponseData *)attributionResponseData;

- (void)getAttribution;

- (void)pauseSending;

- (void)resumeSending;

- (void)teardown;

@end

@interface ADTAttributionHandler : NSObject <ADTAttributionHandler>

+ (id<ADTAttributionHandler>)handlerWithActivityHandler:(id<ADTActivityHandler>)activityHandler
                                          startsSending:(BOOL)startsSending;

@end
