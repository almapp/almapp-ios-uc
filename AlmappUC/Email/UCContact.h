//
//  UCContact.h
//  AlmappUC
//
//  Created by Patricio López on 15-03-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>

@interface UCContact : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *email;

@property (strong, nonatomic) NSURL *imageUrl;
@property (strong, nonatomic) UIImage *imageThumbnail;

+ (instancetype)contactNamed:(NSString *)name email:(NSString *)email;
+ (instancetype)contactNamed:(NSString *)name email:(NSString *)email image:(id)image;

@end
