//
//  UCCampusCell.m
//  AlmappUC
//
//  Created by Patricio López on 22-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCCampusCell.h"

@implementation UCCampusCell

+ (NSString *)nibName {
    return @"UCCampusCell";
}

+ (CGFloat)height {
    return 140.0f;
}

- (void)setArea:(ALMArea *)area {
    [super setArea:area];
    [super setBackgroundWithPath:area.bannerOriginalPath defaultImage:@"MapBannerOriginal"];
}

@end
