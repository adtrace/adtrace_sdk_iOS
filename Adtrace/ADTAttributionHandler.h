//
//  ADTAttributionHandler.h
//  Adtrace
//
//  Created by Aref on 9/8/20.
//  Copyright © 2020 Adtrace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADTActivityHandler.h"
#import "ADTActivityPackage.h"
#import "ADTRequestHandler.h"
#import "ADTUrlStrategy.h"

@interface ADTAttributionHandler : NSObject <ADTResponseCallback>

- (id)initWithActivityHandler:(id<ADTActivityHandler>) activityHandler
                startsSending:(BOOL)startsSending
                    userAgent:(NSString *)userAgent
                  urlStrategy:(ADTUrlStrategy *)urlStrategy;

- (void)checkSessionResponse:(ADTSessionResponseData *)sessionResponseData;

- (void)checkSdkClickResponse:(ADTSdkClickResponseData *)sdkClickResponseData;

- (void)checkAttributionResponse:(ADTAttributionResponseData *)attributionResponseData;

- (void)getAttribution;

- (void)pauseSending;

- (void)resumeSending;

- (void)teardown;

@end
