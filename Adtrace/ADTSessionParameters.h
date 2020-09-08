//
//  ADTSessionParameters.h
//  Adtrace
//
//  Created by Aref on 9/8/20.
//  Copyright © 2020 Adtrace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADTSessionParameters : NSObject <NSCopying>

@property (nonatomic, strong) NSMutableDictionary* callbackParameters;
@property (nonatomic, strong) NSMutableDictionary* partnerParameters;

@end
