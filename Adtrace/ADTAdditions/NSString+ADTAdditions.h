//
//  NSString+ADTAdditions.h
//  Adtrace
//
//  Created by Aref on 9/8/20.
//  Copyright © 2020 Adtrace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(ADTAdditions)

- (NSString *)adtMd5;
- (NSString *)adtSha1;
- (NSString *)adtSha256;
- (NSString *)adtTrim;
- (NSString *)adtUrlEncode;
- (NSString *)adtUrlDecode;
- (NSString *)adtRemoveColons;

+ (NSString *)adtJoin:(NSString *)strings, ...;
+ (BOOL) adtIsEqual:(NSString *)first toString:(NSString *)second;

@end
