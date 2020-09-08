//
//  ADTSdkClickHandler.m
//  Adtrace
//
//  Created by Aref on 9/8/20.
//  Copyright © 2020 Adtrace. All rights reserved.
//

#import "ADTUtil.h"
#import "ADTLogger.h"
#import "ADTAdtraceFactory.h"
#import "ADTSdkClickHandler.h"
#import "ADTBackoffStrategy.h"
#import "ADTUserDefaults.h"

static const char * const kInternalQueueName = "com.adtrace.SdkClickQueue";

@interface ADTSdkClickHandler()

@property (nonatomic, strong) NSMutableArray *packageQueue;
@property (nonatomic, strong) dispatch_queue_t internalQueue;
@property (nonatomic, strong) ADTRequestHandler *requestHandler;

@property (nonatomic, assign) BOOL paused;
@property (nonatomic, strong) ADTBackoffStrategy *backoffStrategy;

@property (nonatomic, weak) id<ADTLogger> logger;
@property (nonatomic, weak) id<ADTActivityHandler> activityHandler;

@property (nonatomic, assign) NSInteger lastPackageRetriesCount;

@end

@implementation ADTSdkClickHandler

#pragma mark - Public instance methods

- (id)initWithActivityHandler:(id<ADTActivityHandler>)activityHandler
                startsSending:(BOOL)startsSending
                    userAgent:(NSString *)userAgent
                  urlStrategy:(ADTUrlStrategy *)urlStrategy
{
    self = [super init];
    if (self == nil) {
        return nil;
    }

    self.internalQueue = dispatch_queue_create(kInternalQueueName, DISPATCH_QUEUE_SERIAL);
    self.logger = ADTAdtraceFactory.logger;
    self.lastPackageRetriesCount = 0;

    self.requestHandler = [[ADTRequestHandler alloc]
                           initWithResponseCallback:self
                           urlStrategy:urlStrategy
                           userAgent:userAgent
                           requestTimeout:[ADTAdtraceFactory requestTimeout]];

    [ADTUtil launchInQueue:self.internalQueue
                selfInject:self
                     block:^(ADTSdkClickHandler *selfI) {
                         [selfI initI:selfI
                      activityHandler:activityHandler
                        startsSending:startsSending];
                     }];
    return self;
}

- (void)pauseSending {
    self.paused = YES;
}

- (void)resumeSending {
    self.paused = NO;
    [self sendNextSdkClick];
}

- (void)sendSdkClick:(ADTActivityPackage *)sdkClickPackage {
    [ADTUtil launchInQueue:self.internalQueue
                selfInject:self
                     block:^(ADTSdkClickHandler *selfI) {
                         [selfI sendSdkClickI:selfI sdkClickPackage:sdkClickPackage];
                     }];
}

- (void)sendNextSdkClick {
    [ADTUtil launchInQueue:self.internalQueue
                selfInject:self
                     block:^(ADTSdkClickHandler *selfI) {
                         [selfI sendNextSdkClickI:selfI];
                     }];
}

- (void)teardown {
    [ADTAdtraceFactory.logger verbose:@"ADTSdkClickHandler teardown"];

    if (self.packageQueue != nil) {
        [self.packageQueue removeAllObjects];
    }

    self.internalQueue = nil;
    self.logger = nil;
    self.backoffStrategy = nil;
    self.packageQueue = nil;
    self.activityHandler = nil;
}

#pragma mark - Private & helper methods

-   (void)initI:(ADTSdkClickHandler *)selfI
activityHandler:(id<ADTActivityHandler>)activityHandler
  startsSending:(BOOL)startsSending {
    selfI.activityHandler = activityHandler;
    selfI.paused = !startsSending;
    selfI.backoffStrategy = [ADTAdtraceFactory sdkClickHandlerBackoffStrategy];
    selfI.packageQueue = [NSMutableArray array];
}

- (void)sendSdkClickI:(ADTSdkClickHandler *)selfI
      sdkClickPackage:(ADTActivityPackage *)sdkClickPackage {
    [selfI.packageQueue addObject:sdkClickPackage];
    [selfI.logger debug:@"Added sdk_click %d", selfI.packageQueue.count];
    [selfI.logger verbose:@"%@", sdkClickPackage.extendedString];
    [selfI sendNextSdkClick];
}

- (void)sendNextSdkClickI:(ADTSdkClickHandler *)selfI {
    if (selfI.paused) {
        return;
    }
    NSUInteger queueSize = selfI.packageQueue.count;
    if (queueSize == 0) {
        return;
    }
    if ([selfI.activityHandler isGdprForgotten]) {
        [selfI.logger debug:@"sdk_click request won't be fired for forgotten user"];
        return;
    }

    ADTActivityPackage *sdkClickPackage = [self.packageQueue objectAtIndex:0];
    [self.packageQueue removeObjectAtIndex:0];

    if (![sdkClickPackage isKindOfClass:[ADTActivityPackage class]]) {
        [selfI.logger error:@"Failed to read sdk_click package"];
        [selfI sendNextSdkClick];
        return;
    }

    dispatch_block_t work = ^{
        NSDictionary *sendingParameters = @{
            @"sent_at": [ADTUtil formatSeconds1970:[NSDate.date timeIntervalSince1970]]
        };

        [selfI.requestHandler sendPackageByPOST:sdkClickPackage
                              sendingParameters:sendingParameters];

        [selfI sendNextSdkClick];
    };

    if (selfI.lastPackageRetriesCount <= 0) {
        work();
        return;
    }

    NSTimeInterval waitTime = [ADTUtil waitingTime:selfI.lastPackageRetriesCount backoffStrategy:self.backoffStrategy];
    NSString *waitTimeFormatted = [ADTUtil secondsNumberFormat:waitTime];

    [self.logger verbose:@"Waiting for %@ seconds before retrying sdk_click for the %d time", waitTimeFormatted, selfI.lastPackageRetriesCount];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(waitTime * NSEC_PER_SEC)), self.internalQueue, work);
}

- (void)responseCallback:(ADTResponseData *)responseData {
    if (responseData.jsonResponse) {
        [self.logger debug:
            @"Got click JSON response with message: %@", responseData.message];
    } else {
        [self.logger error:
            @"Could not get click JSON response with message: %@", responseData.message];
    }
    // Check if any package response contains information that user has opted out.
    // If yes, disable SDK and flush any potentially stored packages that happened afterwards.
    if (responseData.trackingState == ADTTrackingStateOptedOut) {
        self.lastPackageRetriesCount = 0;
        [self.activityHandler setTrackingStateOptedOut];
        return;
    }
    if (responseData.jsonResponse == nil) {
        self.lastPackageRetriesCount++;
        [self.logger error:@"Retrying sdk_click package for the %d time", self.lastPackageRetriesCount];
        [self sendSdkClick:responseData.sdkClickPackage];
        return;
    }
    self.lastPackageRetriesCount = 0;
    
    if ([responseData.sdkClickPackage.parameters.allValues containsObject:ADTiAdPackageKey]) {
        // received iAd click package response, clear the errors from UserDefaults
        [ADTUserDefaults cleariAdErrors];
    }

    [self.activityHandler finishedTracking:responseData];
}

@end
