//
//  ADTKeychain.h
//  Adtrace
//
//  Created by Aref on 9/8/20.
//  Copyright © 2020 Adtrace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADTKeychain : NSObject

+ (NSString *)valueForKeychainKey:(NSString *)key service:(NSString *)service;
+ (BOOL)setValue:(NSString *)value forKeychainKey:(NSString *)key inService:(NSString *)service;

@end
