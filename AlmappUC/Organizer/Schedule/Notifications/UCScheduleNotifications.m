//
//  UCScheduleNotifications.m
//  AlmappUC
//
//  Created by Patricio López on 04-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCScheduleNotifications.h"
#import <DateTools/DateTools.h>

static NSString *const kNotificationIdentifierShowMap = @"kNotificationIdentifierShowMap";
static NSString *const kNotificationIdentifierShowCourse = @"kNotificationIdentifierShowCourse";
static NSString *const kNotificationShcheduleCategory = @"kNotificationShcheduleCategory";

@implementation UCScheduleNotifications

+ (void)setup {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    /*
    UIMutableUserNotificationAction *action1;
    action1 = [[UIMutableUserNotificationAction alloc] init];
    [action1 setActivationMode:UIUserNotificationActivationModeForeground];
    [action1 setTitle:@"Mostrar mapa"];
    [action1 setIdentifier:kNotificationIdentifierShowMap];
    [action1 setDestructive:NO];
    [action1 setAuthenticationRequired:NO];
    
    UIMutableUserNotificationAction *action2;
    action2 = [[UIMutableUserNotificationAction alloc] init];
    [action2 setActivationMode:UIUserNotificationActivationModeForeground];
    [action2 setTitle:@"Ver ramo"];
    [action2 setIdentifier:kNotificationIdentifierShowCourse];
    [action2 setDestructive:NO];
    [action2 setAuthenticationRequired:NO];
    
    UIMutableUserNotificationCategory *actionCategory;
    actionCategory = [[UIMutableUserNotificationCategory alloc] init];
    [actionCategory setIdentifier:kNotificationShcheduleCategory];
    [actionCategory setActions:@[action1, action2] forContext:UIUserNotificationActionContextDefault];
    
    NSSet *categories = [NSSet setWithObject:actionCategory];
    UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound);
    
    UIUserNotificationSettings *settings;
    settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
*/
#else
    
    //[[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
#endif

    
}

+ (void)scheduleNotificationFoItems:(id<NSFastEnumeration>)items {
    for (ALMScheduleItem *item in items) {
        [self scheduleNotificationFoItem:item];
    }
}

+ (void)scheduleNotificationFoItem:(ALMScheduleItem *)item {
    UILocalNotification* notification = [[UILocalNotification alloc] init];
    
    NSDate *fireDate = [item.scheduleModule incomingStartTimeWithAnticipation:YES];
    
    notification.alertBody = [self notificationMessage:item];
    notification.fireDate = fireDate;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.alertAction = @"Ver ramo";
    notification.repeatInterval = NSWeekCalendarUnit;
    //notification.category = kNotificationShcheduleCategory;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

+ (NSString *)notificationMessage:(ALMScheduleItem *)item {
    ALMScheduleModule *module = item.scheduleModule;
    ALMSection *section = item.section;
    
    NSMutableString *message = [NSMutableString stringWithFormat:@"%d:", module.startHour];
    if (module.startMinute < 10) {
        [message appendFormat:@"0%d | ", module.startMinute];
    }
    else {
        [message appendFormat:@"%d | ", module.startMinute];
    }
    [message appendFormat:@"%@: %@\nEn %@", item.classType, section.identifier, item.placeName];
    return message;
}

@end
