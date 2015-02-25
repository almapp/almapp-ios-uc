//
//  UCFacultyCell.m
//  AlmappUC
//
//  Created by Patricio López on 22-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCFacultyCell.h"

@implementation UCFacultyCell

+ (NSString *)nibName {
    return @"UCFacultyCell";
}

+ (CGFloat)height {
    return 80.0f;
}

- (void)setArea:(ALMArea *)area {
    [super setArea:area];
    [super setBackgroundWithPath:area.bannerSmallPath defaultImage:@"MapBannerSmall"];
}

@end
