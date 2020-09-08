//
//  ADTActivityPackage.h
//  Adtrace
//
//  Created by Aref on 9/8/20.
//  Copyright © 2020 Adtrace. All rights reserved.
//

#import "ADTActivityKind.h"

@interface ADTActivityPackage : NSObject <NSCoding>

// Data

@property (nonatomic, copy) NSString *path;

@property (nonatomic, copy) NSString *clientSdk;

@property (nonatomic, strong) NSMutableDictionary *parameters;

@property (nonatomic, strong) NSDictionary *partnerParameters;

@property (nonatomic, strong) NSDictionary *callbackParameters;

// Logs

@property (nonatomic, copy) NSString *suffix;

@property (nonatomic, assign) ADTActivityKind activityKind;

- (NSString *)extendedString;

- (NSString *)successMessage;

- (NSString *)failureMessage;

@end
