//
//  ViewControlleriOS.m
//  AdjustExample-iOS
//
//  Created by Pedro Filipe on 12/10/15.
//  Copyright © 2015 adjust. All rights reserved.
//

#import "Adtrace.h"
#import "Constants.h"
#import "ViewControlleriOS.h"

@interface ViewControlleriOS ()

@property (weak, nonatomic) IBOutlet UIButton *btnTrackSimpleEvent;
@property (weak, nonatomic) IBOutlet UIButton *btnTrackRevenueEvent;
@property (weak, nonatomic) IBOutlet UIButton *btnTrackCallbackEvent;
@property (weak, nonatomic) IBOutlet UIButton *btnTrackPartnerEvent;
//@property (weak, nonatomic) IBOutlet UIButton *btnEnableOfflineMode;
//@property (weak, nonatomic) IBOutlet UIButton *btnDisableOfflineMode;
//@property (weak, nonatomic) IBOutlet UIButton *btnEnableSdk;
//@property (weak, nonatomic) IBOutlet UIButton *btnDisableSdk;
//@property (weak, nonatomic) IBOutlet UIButton *btnIsSdkEnabled;

@end

@implementation ViewControlleriOS

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)clickTrackSimpleEvent:(UIButton *)sender {
    ADJEvent *event = [ADJEvent eventWithEventToken:kEventToken1];

    // Attach callback ID to event.
    [event setCallbackId:@"RandomCallbackId"];

    [Adtrace trackEvent:event];
}

- (IBAction)clickTrackRevenueEvent:(UIButton *)sender {
    ADJEvent *event = [ADJEvent eventWithEventToken:kEventToken2];

    // Add revenue 1 cent of an euro.
    [event setRevenue:0.01 currency:@"EUR"];

    [Adtrace trackEvent:event];
}

- (IBAction)clickTrackCallbackEvent:(UIButton *)sender {
    ADJEvent *event = [ADJEvent eventWithEventToken:kEventToken3];

    // Add callback parameters to this event.
    [event addCallbackParameter:@"a" value:@"b"];
    [event addCallbackParameter:@"key" value:@"value"];
    [event addCallbackParameter:@"a" value:@"c"];

    [Adtrace trackEvent:event];
}

- (IBAction)clickTrackPartnerEvent:(UIButton *)sender {
    ADJEvent *event = [ADJEvent eventWithEventToken:kEventToken4];

    // Add partner parameteres to this event.
    [event addPartnerParameter:@"x" value:@"y"];
    [event addPartnerParameter:@"foo" value:@"bar"];
    [event addPartnerParameter:@"x" value:@"z"];

    [Adtrace trackEvent:event];
}

//- (IBAction)clickEnableOfflineMode:(id)sender {
//    [Adtrace setOfflineMode:YES];
//}
//
//- (IBAction)clickDisableOfflineMode:(id)sender {
//    [Adtrace setOfflineMode:NO];
//}
//
//- (IBAction)clickEnableSdk:(id)sender {
//    [Adtrace setEnabled:YES];
//}
//
//- (IBAction)clickDisableSdk:(id)sender {
//    [Adtrace setEnabled:NO];
//}
//
//- (IBAction)clickIsSdkEnabled:(id)sender {
//    NSString *message;
//
//    if ([Adtrace isEnabled]) {
//        message = @"SDK is ENABLED!";
//    } else {
//        message = @"SDK is DISABLED!";
//    }
//
//    UIAlertView *alert = [[UIAlertView alloc ]initWithTitle:@"Is SDK Enabled?"
//                                                     message:message
//                                                    delegate:nil
//                                           cancelButtonTitle:@"OK"
//                                           otherButtonTitles:nil];
//    [alert show];
//}

@end
