
#import "ADTTimerOnce.h"
#import "ADTLogger.h"
#import "ADTAdtraceFactory.h"
#import "ADTUtil.h"

static const uint64_t kTimerLeeway   =  1 * NSEC_PER_SEC; // 1 second

#pragma mark - private
@interface ADTTimerOnce()

@property (nonatomic, strong) dispatch_queue_t internalQueue;
@property (nonatomic, strong) dispatch_source_t source;
@property (nonatomic, copy) dispatch_block_t block;
@property (nonatomic, assign, readonly) dispatch_time_t start;
@property (nonatomic, strong) NSDate * fireDate;
@property (nonatomic, weak) id<ADTLogger> logger;
@property (nonatomic, copy) NSString *name;

@end

#pragma mark -
@implementation ADTTimerOnce

+ (ADTTimerOnce *)timerWithBlock:(dispatch_block_t)block
                       queue:(dispatch_queue_t)queue
                            name:(NSString*)name
{
    return [[ADTTimerOnce alloc] initBlock:block queue:queue name:name];
}

- (id)initBlock:(dispatch_block_t)block
          queue:(dispatch_queue_t)queue
           name:(NSString*)name
{
    self = [super init];
    if (self == nil) return nil;

    self.internalQueue = queue;
    self.logger = ADTAdtraceFactory.logger;
    self.name = name;

    self.block = ^{
        [ADTAdtraceFactory.logger verbose:@"%@ fired", name];
        block();
    };

    return self;
}

- (NSTimeInterval)fireIn {
    if (self.fireDate == nil) {
        return 0;
    }
    return [self.fireDate timeIntervalSinceNow];
}

- (void)startIn:(NSTimeInterval)startIn {
    // cancel previous
    [self cancel:NO];

    self.fireDate = [[NSDate alloc] initWithTimeIntervalSinceNow:startIn];
    NSString * fireInFormatted = [ADTUtil secondsNumberFormat:[self fireIn]];
    [self.logger verbose:@"%@ starting. Launching in %@ seconds", self.name, fireInFormatted];

    self.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.internalQueue);

    if (!self.source) {
        [self.logger error:@"%@ could not start witouth source", self.name];
        return;
    }
    if (!self.block) {
        [self.logger error:@"%@ could not start witouth block", self.name];
        return;
    }

    dispatch_source_set_timer(self.source,
                              dispatch_walltime(NULL, startIn * NSEC_PER_SEC),
                              DISPATCH_TIME_FOREVER,
                              kTimerLeeway);


    dispatch_resume(self.source);

    dispatch_source_set_event_handler(self.source, self.block);
}

- (void)cancel:(BOOL)log {
    if (self.source != nil) {
        dispatch_cancel(self.source);
    }
    self.source = nil;
    if (log) {
        [self.logger verbose:@"%@ canceled", self.name];
    }
}

- (void)cancel {
    [self cancel:YES];
}

- (void)dealloc {
    [self.logger verbose:@"%@ dealloc", self.name];
}

@end
