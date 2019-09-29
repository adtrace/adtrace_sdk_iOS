//
//  AppDelegate.h
//  AdtraceExample-ObjC
//
//  Created by Pedro Filipe (@nonelse) on 12th October 2015.
//  Copyright © 2015-2019 Adtrace GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Adtrace.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, AdtraceDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
