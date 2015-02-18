//
//  UCMenuItem.m
//  AlmappUC
//
//  Created by Patricio López on 30-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "UCMenuItem.h"

@implementation UCMenuItem

-(id)initWithTitle:(NSString *)title imageString:(NSString *)imageString viewName:(NSString *)viewName{
    self = [super init];
    if (self) {
        _title = title;
        _viewName = viewName;
        _imageString = imageString;
    }
    return self;
}

-(UIImage *)image {
    UIImage* image = [UIImage imageNamed:_imageString];
    return image;
}

@end
