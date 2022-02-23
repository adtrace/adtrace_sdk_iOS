







#import <Foundation/Foundation.h>

@interface ADTEventSuccess : NSObject


@property (nonatomic, copy) NSString *message;


@property (nonatomic, copy) NSString *timeStamp;


@property (nonatomic, copy) NSString *adid;


@property (nonatomic, copy) NSString *eventToken;


@property (nonatomic, copy) NSString *callbackId;


@property (nonatomic, strong) NSDictionary *jsonResponse;


+ (ADTEventSuccess *)eventSuccessResponseData;

@end
