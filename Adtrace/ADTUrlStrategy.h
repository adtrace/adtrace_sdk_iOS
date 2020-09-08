//
//  ADTUrlStrategy.h
//  Adtrace
//
//  Created by Aref on 9/8/20.
//  Copyright © 2020 Adtrace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADTActivityKind.h"

@interface ADTUrlStrategy : NSObject

@property (nonatomic, readonly, copy) NSString *extraPath;

- (instancetype)initWithUrlStrategyInfo:(NSString *)urlStrategyInfo
                              extraPath:(NSString *)extraPath;

- (NSString *)getUrlHostStringByPackageKind:(ADTActivityKind)activityKind;

- (void)resetAfterSuccess;
- (BOOL)shouldRetryAfterFailure;

@end
