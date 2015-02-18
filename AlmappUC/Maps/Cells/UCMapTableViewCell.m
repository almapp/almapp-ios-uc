//
//  UCMapTableViewCell.m
//  AlmappUC
//
//  Created by Patricio López on 31-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "UCMapTableViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <NGAParallaxMotion/NGAParallaxMotion.h>

static NSString *const kCampusCellNibName = @"UCCampusCell";
static NSString *const kFacultyCellNibName = @"UCFacultyCell";
static NSString *const kBuildingCellNibName = @"UCBuildingCell";

static CGFloat const kCampusCellHeight =  140.0f;
static CGFloat const kFacultyCellHeight =  80.0f;
static CGFloat const kBuildingCellHeight =  50.0f;

static NSURL *baseURL = nil;

@implementation UCMapTableViewCell

+ (NSString *)nibNameCampusCell {
    return kCampusCellNibName;
}

+ (NSString *)nibNameFacultyCell {
    return kFacultyCellNibName;
}

+ (NSString *)nibNameBuildingCell {
    return kBuildingCellNibName;
}

+ (NSString *)nibNameAcademicUnityCell {
    return @"UCAcademicUnityCell";
}

+ (CGFloat)heightCampusCell {
    return kCampusCellHeight;
}

+ (CGFloat)heightFacultyCell {
    return kFacultyCellHeight;
}

+ (CGFloat)heightBuildingCell {
    return kBuildingCellHeight;
}

+ (CGFloat)heightAcademicUnityCell {
    return [self heightBuildingCell];
}

- (NSURL *)generateURLFor:(NSString *)path {
    if (!baseURL) {
        baseURL = [[ALMCore sharedInstance] baseURL];
    }
    return [baseURL URLByAppendingPathComponent:path];
}

- (void)awakeFromNib {
    // Initialization code
    [_parallaxView setClipsToBounds:YES];
    _titleLabel.parallaxIntensity = _arrowImage.parallaxIntensity = 11;
    if (_subtitleLabel) {
        _subtitleLabel.parallaxIntensity = 11;
    }
    [_arrowImage setTintColor:[UIColor whiteColor]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setArea:(ALMArea *)area {
    _area = area;
    
    self.titleLabel.text = area.shortName;
    
    if ([area isKindOfClass:[ALMCampus class]]) {
        self.subtitleLabel.text = area.address;
    }
    
    NSURL *url = [self generateURLFor:[NSString stringWithFormat:@"/images/%@/%@.jpg", [area apiPluralForm], area.abbreviation.lowercaseString]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //UIImage *placeholderImage = [UIImage imageNamed:@"campus_placeholder.png"];
    
    __weak UCMapTableViewCell *weakCell = self;
    [self.parallaxView setImageWithURLRequest:request
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       
                                       weakCell.parallaxView.image = image;
                                       [weakCell setNeedsLayout];
                                       
                                   } failure:nil];
    
    
    [self bringSubviewToFront:_arrowImage];
    [self bringSubviewToFront:_titleLabel];
}


@end
