//
//  UCBuildingCell.m
//  AlmappUC
//
//  Created by Patricio López on 22-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCBuildingCell.h"

@implementation UCBuildingCell

+ (NSString *)nibName {
    return @"UCBuildingCell";
}

+ (CGFloat)height {
    return 50.0f;
}

- (void)setArea:(ALMArea *)area {
    [super setArea:area];
    [super setBackgroundWithPath:area.bannerSmallPath defaultImage:@"MapBannerSmall"];
}

@end
