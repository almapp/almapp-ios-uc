//
//  NSUserDefaults+Config.h
//  AlmappUC
//
//  Created by Patricio López on 07-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Config)

+ (instancetype)userDefaults;

+ (void)justUpdate:(NSString *)key;
+ (BOOL)shouldUpdate:(NSString *)key;


+ (BOOL)shouldUpdateAreas;
+ (void)justUpdateAreas;

+ (BOOL)hasRegisterNotifications;
+ (void)justRegisteredNotifications;

+ (NSString *)currentSessionEmail;
+ (void)setCurrentSession:(NSString *)email;

@end
