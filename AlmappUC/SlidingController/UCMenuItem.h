//
//  UCMenuItem.h
//  AlmappUC
//
//  Created by Patricio López on 30-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UCMenuItem : NSObject

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* viewName;
@property (strong, nonatomic) NSString* imageString;
@property (getter=image, nonatomic) UIImage* image;

-(id)initWithTitle:(NSString*)title imageString:(NSString*)imageString viewName:(NSString*)viewName;

@end
