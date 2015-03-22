//
//  UCContact.m
//  AlmappUC
//
//  Created by Patricio López on 15-03-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCContact.h"

@implementation UCContact

+ (instancetype)contactNamed:(NSString *)name email:(NSString *)email {
    return [self contactNamed:name email:email image:nil];
}

+ (instancetype)contactNamed:(NSString *)name email:(NSString *)email image:(id)image {
    UCContact *contact = [[self alloc] init];
    contact.name = name;
    contact.email = email;
    
    if ([image isKindOfClass:[UIImage class]]) {
        contact.imageThumbnail = image;
    }
    else if ([image isKindOfClass:[NSURL class]]) {
        contact.imageUrl = image;
    }
    else if ([image isKindOfClass:[NSString class]]) {
        contact.imageUrl = [NSURL URLWithString:image];
    }
    
    return contact;
}

@end
