//
//  EventTrackedController.m
//  AdtraceExample-iWatch
//
//  Created by Uglješa Erceg (@uerceg) on 6th April 2016
//  Copyright © 2016-Present Adtrace GmbH. All rights reserved.
//

#import "EventTrackedController.h"

@interface EventTrackedController ()

@property (nonatomic, weak) IBOutlet WKInterfaceLabel *wkLblMessage;

@end

@implementation EventTrackedController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    [_wkLblMessage setText:context];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)btnOkTapped {
    [self popToRootController];
}

@end



