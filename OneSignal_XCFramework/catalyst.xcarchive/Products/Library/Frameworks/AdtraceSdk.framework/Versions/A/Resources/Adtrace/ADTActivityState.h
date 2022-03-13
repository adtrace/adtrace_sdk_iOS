







#import <Foundation/Foundation.h>

@interface ADTActivityState : NSObject <NSCoding, NSCopying>


@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) BOOL isGdprForgotten;
@property (nonatomic, assign) BOOL askingAttribution;
@property (nonatomic, assign) BOOL isThirdPartySharingDisabled;

@property (nonatomic, copy) NSString *dedupeToken;
@property (nonatomic, copy) NSString *deviceToken;
@property (nonatomic, assign) BOOL updatePackages;

@property (nonatomic, copy) NSString *adid;
@property (nonatomic, strong) NSDictionary *attributionDetails;

@property (nonatomic, assign) int trackingManagerAuthorizationStatus;


@property (nonatomic, assign) int eventCount;
@property (nonatomic, assign) int sessionCount;


@property (nonatomic, assign) int subsessionCount;

@property (nonatomic, assign) double timeSpent;
@property (nonatomic, assign) double lastActivity;      
@property (nonatomic, assign) double sessionLength;     


@property (nonatomic, strong) NSMutableArray *transactionIds;


@property (nonatomic, assign) BOOL isPersisted;
@property (nonatomic, assign) double lastInterval;

- (void)resetSessionAttributes:(double)now;

+ (void)saveAppToken:(NSString *)appTokenToSave;


- (void)addTransactionId:(NSString *)transactionId;
- (BOOL)findTransactionId:(NSString *)transactionId;

@end
