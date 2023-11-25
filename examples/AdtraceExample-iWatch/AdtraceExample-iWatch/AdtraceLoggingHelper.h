//
//  AdtraceLoggingHelper.h
//  AdtraceExample-iWatch
//
//  Created by Uglješa Erceg (@uerceg) on 6th April 2016
//  Copyright © 2016-Present Adtrace GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdtraceLoggingHelper : NSObject

+ (id)sharedInstance;

- (void)logText:(NSString *)text;

@end
