//
//  AdtraceLoggingHelper.h
//  AdtraceExample-iWatch
//
//  Created by Uglješa Erceg on 29/04/15.
//  Copyright (c) 2015 adtrace GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdtraceLoggingHelper : NSObject

+ (id)sharedInstance;

- (void)logText:(NSString *)text;

@end
