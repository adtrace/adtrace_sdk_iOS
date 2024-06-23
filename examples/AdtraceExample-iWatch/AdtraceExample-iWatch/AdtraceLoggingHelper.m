//
//  AdtraceLoggingHelper.m
//  AdtraceExample-iWatch
//
//  Created by Uglješa Erceg (@uerceg) on 6th April 2016
//  Copyright © 2016-Present Adtrace GmbH. All rights reserved.
//

#import "AdtraceLoggingHelper.h"

@implementation AdtraceLoggingHelper

+ (id)sharedInstance {
    static AdtraceLoggingHelper *sharedLogger = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedLogger = [[self alloc] init];
    });
    
    return sharedLogger;
}

- (void)logText:(NSString *)text {
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *logPath = [[NSString alloc] initWithFormat:@"%@",[documentsDir stringByAppendingPathComponent:@"AdtraceLog.txt"]];
    NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:logPath];
    
    if (fileHandler == nil) {
        [[NSFileManager defaultManager] createFileAtPath:logPath contents:nil attributes:nil];
        fileHandler = [NSFileHandle fileHandleForWritingAtPath:logPath];
    }
    
    NSDateFormatter *formatter;
    NSString *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    
    dateString = [NSString stringWithFormat:@"\n[%@] ", [formatter stringFromDate:[NSDate date]]];
    
    [fileHandler seekToEndOfFile];
    [fileHandler writeData:[dateString dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandler writeData:[text dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandler closeFile];
}

@end
