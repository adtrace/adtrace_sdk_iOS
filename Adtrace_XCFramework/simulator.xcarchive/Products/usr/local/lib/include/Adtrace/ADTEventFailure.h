







#import <Foundation/Foundation.h>

@interface ADTEventFailure : NSObject


@property (nonatomic, copy) NSString * message;


@property (nonatomic, copy) NSString * timeStamp;


@property (nonatomic, copy) NSString * adid;


@property (nonatomic, copy) NSString * eventToken;


@property (nonatomic, copy) NSString *callbackId;


@property (nonatomic, assign) BOOL willRetry;


@property (nonatomic, strong) NSDictionary *jsonResponse;


+ (ADTEventFailure *)eventFailureResponseData;

@end
