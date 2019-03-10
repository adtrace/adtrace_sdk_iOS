//
//  ADJTestActivityPackage.m
//  adjust
//
//  Created by Pedro Filipe on 15/05/15.
//  Copyright (c) 2015 adjust GmbH. All rights reserved.
//

#import "ADJTestActivityPackage.h"
#import "ADJActivityKind.h"
#import "ADJUtil.h"

// assert package string equals
#define apsEquals(field, value) \
    aslEquals(field, value, package.extendedString)

// assert package integer equals
#define apiEquals(field, value) \
    ailEquals(field, value, package.extendedString)

// assert package equals
#define apEquals(field, value) \
    alEquals(field, value, package.extendedString)

// assert package string parameter equals
#define apspEquals(parameterName, value) \
    apsEquals((NSString *)package.parameters[parameterName], value)


// assert package parameter not nil
#define appnNil(parameterName) \
    anlNil((NSString *)package.parameters[parameterName], package.extendedString)

// assert package paramenter nil
#define appNil(parameterName) \
    alNil((NSString *)package.parameters[parameterName], package.extendedString)

@interface ADJTestActivityPackage()

@end

@implementation ADJTestActivityPackage

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)resetAttributes {
}

- (void)testPackageSession:(ADJActivityPackage *)package
                    fields:(ADJPackageFields *)fields
              sessionCount:(NSString*)sessionCount
{
    // set the session count
    fields.sessionCount = sessionCount;

    // test default package attributes
    [self testDefaultAttributes:package
                         fields:fields
                           path:@"/session"
                   activityKind:ADJActivityKindSession
             activityKindString:@"session"];

    // check default parameters
    [self testDefaultParameters:package
                         fields:fields];

    // last_interval
    if ([@"1" isEqualToString:fields.sessionCount]) {
        appNil(@"last_interval");
    } else {
        appnNil(@"last_interval");
    }
    // default_tracker
    apspEquals(@"default_tracker", fields.defaultTracker);

    // callback_params
    [self assertJsonParameters:package parameterName:@"callback_params" value:fields.callbackParameters];
    // partner_params
    [self assertJsonParameters:package parameterName:@"partner_params" value:fields.partnerParameters];
}

- (void)testEventPackage:(ADJActivityPackage *)package
                  fields:(ADJPackageFields *)fields
              eventToken:(NSString*)eventToken
{
    // test default package attributes
    [self testDefaultAttributes:package
                         fields:fields
                           path:@"/event"
                   activityKind:ADJActivityKindEvent
             activityKindString:@"event"];

    // check default parameters
    [self testDefaultParameters:package
                         fields:fields];

    // event parameters
    // event_count
    if (fields.eventCount == nil) {
        appnNil(@"event_count");
    } else {
        apspEquals(@"event_count", fields.eventCount);
    }
    // event_token
    apspEquals(@"event_token", eventToken);
    // revenue and currency must come together
    if (package.parameters[@"revenue"] != nil
        && package.parameters[@"currency"] == nil)
    {
        XCTFail(@"%@",package.extendedString);
    }
    if (package.parameters[@"revenue"] == nil
        && package.parameters[@"currency"] != nil)
    {
        XCTFail(@"%@",package.extendedString);
    }
    // revenue
    apspEquals(@"revenue", fields.revenue);
    // currency
    apspEquals(@"currency", fields.currency);

    // callback_params
    [self assertJsonParameters:package parameterName:@"callback_params" value:fields.callbackParameters];
    // partner_params
    [self assertJsonParameters:package parameterName:@"partner_params" value:fields.partnerParameters];

    // saved callback parameters
    if (fields.savedCallbackParameters == nil) {
        alNil(package.callbackParameters, package.extendedString);
    } else {
        alTrue([fields.savedCallbackParameters isEqualToDictionary:package.callbackParameters], package.extendedString);
    }

    // saved partner parameters
    if (fields.savedPartnerParameters == nil) {
        alNil(package.partnerParameters, package.extendedString);
    } else {
        alTrue([fields.savedPartnerParameters isEqualToDictionary:package.partnerParameters], package.extendedString);
    }
}

- (void)testClickPackage:(ADJActivityPackage *)package
                  fields:(ADJPackageFields *)fields
                  source:(NSString*)source
{
    // test default package attributes
    [self testDefaultAttributes:package
                         fields:fields
                           path:@"/sdk_click"
                   activityKind:ADJActivityKindClick
             activityKindString:@"click"];

    // check ids parameters
    [self testIdsParameters:package fields:fields];

    // click parameters
    // source
    apspEquals(@"source", source);

    // params
    [self assertJsonParameters:package parameterName:@"params" value:fields.deepLinkParameters];

    // click_time
    // TODO test click time
    if ([source isEqualToString:@"deeplink"]) {
        appnNil(@"click_time");
        apspEquals(@"deeplink", fields.deepLink);
    } else {
        apspEquals(@"click_time", fields.iadTime);
    }

    // purchase_time
    apspEquals(@"purchase_time", fields.purchaseTime);

    // attributions
    if (fields.attribution == nil) {
        // tracker
        appNil(@"tracker");
        // campaign
        appNil(@"campaign");
        // adgroup
        appNil(@"adgroup");
        // creative
        appNil(@"creative");
    } else {
        // tracker
        apspEquals(@"tracker", fields.attribution.trackerName);
        // campaign
        apspEquals(@"campaign", fields.attribution.campaign);
        // adgroup
        apspEquals(@"adgroup", fields.attribution.adgroup);
        // creative
        apspEquals(@"creative", fields.attribution.creative);
    }

    // details
    apspEquals(@"details", fields.iadDetails);

    // push_token
    apspEquals(@"push_token", fields.pushToken);
}

- (void)testAttributionPackage:(ADJActivityPackage *)package
                  fields:(ADJPackageFields *)fields
{
    // test default package attributes
    [self testDefaultAttributes:package
                         fields:fields
                           path:@"/attribution"
                   activityKind:ADJActivityKindAttribution
             activityKindString:@"attribution"];

    // check ids parameters
    [self testIdsParameters:package fields:fields];
}
- (void)testDefaultAttributes:(ADJActivityPackage *)package
                       fields:(ADJPackageFields *)fields
                         path:(NSString *)path
                 activityKind:(ADJActivityKind)activityKind
           activityKindString:(NSString *)activityKindString
{
    // check the Sdk version is being tested
    apsEquals(package.clientSdk, fields.clientSdk);
    // check the path
    apsEquals(package.path, path);
    // test activity kind
    // check the activity kind
    apiEquals(package.activityKind, activityKind);
    // the conversion from activity kind to String
    apsEquals([ADJActivityKindUtil activityKindToString:package.activityKind], activityKindString);
    // the conversion from String to activity kind
    apiEquals(package.activityKind, [ADJActivityKindUtil activityKindFromString:activityKindString]);
    // test suffix
    apsEquals(package.suffix, fields.suffix);
}
- (void)testIdsParameters:(ADJActivityPackage *)package
                       fields:(ADJPackageFields *)fields
{
    [self testDeviceInfoIds:package fields:fields];
    [self testConfig:package fields:fields];
    // created_at
    appnNil(@"created_at");

}
- (void)testDefaultParameters:(ADJActivityPackage *)package
                       fields:(ADJPackageFields *)fields
{
    [self testDeviceInfo:package fields:fields];
    [self testConfig:package fields:fields];
    [self testActivityState:package fields:fields];
    // created_at
    appnNil(@"created_at");
}

- (void)testDeviceInfoIds:(ADJActivityPackage *)package
                   fields:(ADJPackageFields *)fields
{
    // idfa
    appnNil(@"idfa");
    // idfv
    appnNil(@"idfv");
}

- (void)testDeviceInfo:(ADJActivityPackage *)package
                       fields:(ADJPackageFields *)fields
{
    [self testDeviceInfoIds:package fields:fields];
    // fb_id
    //appnNil(@"fb_id");
    // tracking_enabled
    appnNil(@"tracking_enabled");
    // bundle_id
    //appnNil(@"bundle_id");
    // app_version
    //appnNil(@"app_version");
    // device_type
    appnNil(@"device_type");
    // device_name
    appnNil(@"device_name");
    // os_name
    appnNil(@"os_name");
    // os_version
    appnNil(@"os_version");
    // language
    appnNil(@"language");
    // country
    appnNil(@"country");
    // hardware_name
    appnNil(@"hardware_name");
    // cpu_type
    appnNil(@"cpu_type");
}

- (void)testConfig:(ADJActivityPackage *)package
                fields:(ADJPackageFields *)fields
{
    // app_token
    apspEquals(@"app_token", fields.appToken);
    // environment
    apspEquals(@"environment", fields.environment);
    // needs_attribution_data
    apspEquals(@"needs_response_details", @"1");
    // event_buffering_enabled
    NSString * eventBufferingEnabledString = [NSString stringWithFormat:@"%d",fields.eventBufferingEnabled];
    apspEquals(@"event_buffering_enabled", eventBufferingEnabledString);
}

- (void)testActivityState:(ADJActivityPackage *)package
                   fields:(ADJPackageFields *)fields
{
    // session_count
    if (fields.sessionCount == nil) {
        appnNil(@"session_count");
    } else {
        apspEquals(@"session_count", fields.sessionCount);
    }
    // first session
    if ([@"1" isEqualToString:fields.sessionCount]) {
        // subsession_count
        appNil(@"subsession_count");
        // session_length
        appNil(@"session_length");
        // time_spent
        appNil(@"time_spent");
    } else {
        // subsession_count
        if (fields.subSessionCount == nil) {
            appnNil(@"subsession_count");
        } else {
            apspEquals(@"subsession_count", fields.subSessionCount);
        }
        // session_length
        appnNil(@"session_length");
        // time_spent
        appnNil(@"time_spent");
    }
    // ios_uuid
    appnNil(@"ios_uuid");
}

- (void)assertJsonParameters:(ADJActivityPackage *)package
               parameterName:(NSString *)parameterName
                       value:(NSString *)value
{
    NSString * parameterValue = (NSString *)package.parameters[parameterName];

    if (parameterValue == nil) {
        alNil(value, package.extendedString);
        return;
    }

    // value not nil
    anlNil(value, package.extendedString);

    NSError *error = nil;
    NSException *exception = nil;

    NSData * parameterData = [parameterValue dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * parameterDictionary = [ADJUtil buildJsonDict:parameterData exceptionPtr:&exception errorPtr:&error];

    // check parameter parses from Json string
    anlNil(parameterDictionary, package.extendedString);

    NSData * valueData = [value dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * valueDictionary = [ADJUtil buildJsonDict:valueData exceptionPtr:&exception errorPtr:&error];

    // check value parses from Json string
    anlNil(valueDictionary, package.extendedString);

    // check if the json is equal
    alTrue([valueDictionary isEqualToDictionary:parameterDictionary], package.extendedString);
}

@end
