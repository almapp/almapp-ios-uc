//
//  UCImageHelper.m
//  AlmappUC
//
//  Created by Patricio López on 30-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "UCImageHelper.h"

@implementation UCImageHelper

+ (UIImageView*)circleImagen:(NSString *)imageName rect:(CGRect)rect {

    UIImageView *image = [[UIImageView alloc]initWithFrame:rect];
    image.image=[UIImage imageNamed:imageName];
    
    image.layer.cornerRadius = image.frame.size.width / 2;
    image.clipsToBounds = YES;
    
    image.layer.borderWidth = 3.0f;
    image.layer.borderColor = [UIColor whiteColor].CGColor;
    
    return image;
}


@end
