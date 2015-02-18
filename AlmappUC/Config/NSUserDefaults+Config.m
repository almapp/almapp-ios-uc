//
//  NSUserDefaults+Config.m
//  AlmappUC
//
//  Created by Patricio López on 07-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "NSUserDefaults+Config.h"
#import <DateTools/DateTools.h>

static NSString *const kAreasKey = @"UPDATE_TIME_AREAS";
static NSString *const kNotificationKey = @"REGISTER_NOTIFICATION";
static NSString *const kSessionKey = @"SESSION_EMAIL";
static BOOL developmentEnv = NO;

@implementation NSUserDefaults (Config)

+ (instancetype)userDefaults {
    return [self standardUserDefaults];
}

+ (NSString *)keyForClass:(Class)keyClass {
    return NSStringFromClass (keyClass);
}

+ (NSInteger)persistenceUpdateInterval {
    return 60 * 60 * 24 * 3;
}

+ (BOOL)shouldUpdate:(NSString *)key {
    if (developmentEnv) {
        return YES;
    }
    
    NSDate *updateDate = [[self userDefaults] objectForKey:key];
    if (!updateDate) {
        return YES;
    }

    BOOL shouldUpdate = ([[updateDate dateByAddingTimeInterval:self.persistenceUpdateInterval] isEarlierThan:[NSDate date]]);
    return shouldUpdate;
}

+ (void)justUpdate:(NSString *)key {
    NSUserDefaults *defauls = [self userDefaults];
    [defauls setObject:[NSDate date] forKey:key];
    [defauls synchronize];
}



+ (BOOL)shouldUpdateAreas {
    return [self shouldUpdate:kAreasKey];
}

+ (void)justUpdateAreas {
    [self justUpdate:kAreasKey];
}


+ (BOOL)hasRegisterNotifications {
    return [[self userDefaults] boolForKey:kNotificationKey];
}

+ (void)justRegisteredNotifications {
    [[self userDefaults] setBool:YES forKey:kNotificationKey];
}

+ (NSString *)currentSessionEmail {
    return [[self userDefaults] objectForKey:kSessionKey];
}

+ (void)setCurrentSession:(NSString *)email {
    [[self userDefaults] setObject:email forKey:kSessionKey];
}


@end
