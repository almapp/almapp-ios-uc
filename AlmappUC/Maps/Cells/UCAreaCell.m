//
//  UCAreaCell.m
//  AlmappUC
//
//  Created by Patricio López on 22-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import <NGAParallaxMotion/NGAParallaxMotion.h>

#import "UCAreaCell.h"
#import "UCAppDelegate.h"

static const CGFloat kParallaxIntensity = 11.0f;

@implementation UCAreaCell

+ (NSString *)nibName {
    return nil;
}

+(CGFloat)height {
    return 0.0;
}

- (void)awakeFromNib {
    [_areaImageView setClipsToBounds:YES];
    _titleLabel.parallaxIntensity = _arrowImage.parallaxIntensity = kParallaxIntensity;
    if (_subtitleLabel) {
        _subtitleLabel.parallaxIntensity = kParallaxIntensity;
    }
    [_arrowImage setTintColor:[UIColor whiteColor]];
}


- (void)setArea:(ALMArea *)area {
    _area = area;
    
    if (self.titleLabel) {
        self.titleLabel.text = area.shortName;
    }
    
    if (self.subtitleLabel) {
        self.subtitleLabel.text = area.address;
    }
}

- (void)setBackgroundWithPath:(NSString *)path defaultImage:(NSString *)defaultImageName {

    NSURL *url = [NSURL URLWithString:path];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:defaultImageName];
    
    __weak UCAreaCell *weakCell = self;
    [self.areaImageView setImageWithURLRequest:request
                             placeholderImage:placeholderImage
                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                          
                                          weakCell.areaImageView.image = image;
                                          [weakCell setNeedsLayout];
                                          
                                      } failure:nil];
    
    // [self bringSubviewToFront:self.arrowImage];
    // [self bringSubviewToFront:self.titleLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
