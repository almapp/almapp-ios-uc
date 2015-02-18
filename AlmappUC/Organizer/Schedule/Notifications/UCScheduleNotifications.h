//
//  UCScheduleNotifications.h
//  AlmappUC
//
//  Created by Patricio López on 04-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AlmappCore/AlmappCore.h>

@interface UCScheduleNotifications : NSObject

+ (void)setup;

+ (void)scheduleNotificationFoItems:(id<NSFastEnumeration>)items;

+ (void)scheduleNotificationFoItem:(ALMScheduleItem *)item;

@end
