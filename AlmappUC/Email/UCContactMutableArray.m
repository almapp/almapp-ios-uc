//
//  UCContactMutableArray.m
//  AlmappUC
//
//  Created by Patricio López on 22-03-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCContactMutableArray.h"

@interface UCContactMutableArray ()

@end

@implementation UCContactMutableArray

+ (instancetype)array {
    return [[self alloc] init];
}

+ (instancetype)arrayWithCapacity:(NSUInteger)capacity {
    return [[self alloc] initWithCapacity:capacity];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.array = [NSMutableArray array];
        self.dictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (instancetype)initWithCapacity:(NSUInteger)capacity {
    self = [super init];
    if (self) {
        self.array = [NSMutableArray arrayWithCapacity:capacity];
        self.dictionary = [NSMutableDictionary dictionaryWithCapacity:capacity];
    }
    return self;
}

+ (NSComparator)comparator {
    static NSComparator comparator = nil;
    if (!comparator) {
        comparator = ^NSComparisonResult(id a, id b) {
            NSString *first = [(UCContact *)a name];
            NSString *second = [(UCContact *)b name];
            return [first compare:second];
        };
    }
    return comparator;
}

- (void)addContact:(UCContact *)contact {
    if (!self.dictionary[contact.email]) {
        self.dictionary[contact.email] = contact;
        
        NSUInteger newIndex = [self.array indexOfObject:contact
                                     inSortedRange:(NSRange){0, self.array.count}
                                           options:NSBinarySearchingInsertionIndex
                                   usingComparator:[UCContactMutableArray comparator]];
        
        [self.array insertObject:contact atIndex:newIndex];
        
        //[self addObject:contact];
    }
}

- (void)addContacts:(id)contacts {
    if ([contacts isKindOfClass:self.class]) {
        contacts = [(UCContactMutableArray *)contacts array];
    }
    
    for (UCContact *contact in contacts) {
        [self addContact:contact];
    }
}

- (void)removeContact:(UCContact *)contact {
    [self.dictionary removeObjectForKey:contact.email];
    [self.array removeObject:contact];
}

- (UCContact *)contactAtIndex:(NSUInteger)index {
    return self.array[index];
}

- (BOOL)containsContact:(UCContact *)contact {
    return self.dictionary[contact.email] != nil;
}

- (void)clear {
    [self.array removeAllObjects];
    [self.dictionary removeAllObjects];
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return [self contactAtIndex:idx];
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    [self addContacts:obj];
}

- (NSUInteger)count {
    return self.array.count;
}

@end
