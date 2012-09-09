//
//  CHKeychain.h 
//  scalextreme
//
//  Created by Bill gates on 12-1-20.
//  Copyright (c) 2012年 HT&L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>


@interface CHKeychain : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;


@end
