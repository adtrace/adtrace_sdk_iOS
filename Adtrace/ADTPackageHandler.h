//
//  ADTPackageHandler.h
//  Adtrace
//
//  Created by Aref on 9/8/20.
//  Copyright © 2020 Adtrace. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ADTActivityPackage.h"
#import "ADTPackageHandler.h"
#import "ADTActivityHandler.h"
#import "ADTResponseData.h"
#import "ADTSessionParameters.h"
#import "ADTRequestHandler.h"
#import "ADTUrlStrategy.h"

@interface ADTPackageHandler : NSObject <ADTResponseCallback>

- (id)initWithActivityHandler:(id<ADTActivityHandler>)activityHandler
                startsSending:(BOOL)startsSending
                    userAgent:(NSString *)userAgent
                  urlStrategy:(ADTUrlStrategy *)urlStrategy;
                    //extraPath:(NSString *)extraPath;

- (void)addPackage:(ADTActivityPackage *)package;
- (void)sendFirstPackage;
- (void)pauseSending;
- (void)resumeSending;
- (void)updatePackages:(ADTSessionParameters *)sessionParameters;
- (void)flush;

- (void)teardown;
+ (void)deleteState;

@end
