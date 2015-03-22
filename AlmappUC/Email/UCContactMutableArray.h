//
//  UCContactMutableArray.h
//  AlmappUC
//
//  Created by Patricio López on 22-03-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UCContact.h"

@interface UCContactMutableArray : NSObject

@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) NSMutableDictionary *dictionary;
@property (readonly) NSUInteger count;


+ (instancetype)array;
+ (instancetype)arrayWithCapacity:(NSUInteger)capacity;

- (void)addContact:(UCContact *)contact;

- (void)addContacts:(id)contacts ;

- (UCContact *)contactAtIndex:(NSUInteger)index;

- (void)removeContact:(UCContact *)contact;

- (void)clear;

- (BOOL)containsContact:(UCContact *)contact;

- (id)objectAtIndexedSubscript:(NSUInteger)idx;

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;

@end
