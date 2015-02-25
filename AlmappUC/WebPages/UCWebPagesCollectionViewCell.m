//
//  UCWebPagesCollectionViewCell.m
//  AlmappUC
//
//  Created by Patricio López on 12-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import <NGAParallaxMotion/NGAParallaxMotion.h>

#import "UCWebPagesCollectionViewCell.h"
#import "UCAppDelegate.h"

@implementation UCWebPagesCollectionViewCell

- (void)awakeFromNib {
    _backgroundBlurred.parallaxIntensity = 10;
}

- (void)setWebpage:(ALMWebPage *)webpage {
    _webpage = webpage;
    
    _title.text = webpage.name;
    
    [_backgroundBlurred setClipsToBounds:YES];
    
    [self setWebpageBackground:webpage];
    [self setWebpageIcon:webpage];
}

- (void)setWebpageIcon:(ALMWebPage *)webpage {
    NSURL *url = [NSURL URLWithString:webpage.iconOriginalPath];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"WebServices"];
    
    __weak UCWebPagesCollectionViewCell *weakCell = self;
    [self.icon setImageWithURLRequest:request
                                  placeholderImage:placeholderImage
                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                               
                                               weakCell.icon.image = image;
                                               [weakCell setNeedsLayout];
                                               
                                           } failure:nil];
    
}

- (void)setWebpageBackground:(ALMWebPage *)webpage {
    NSURL *url = [NSURL URLWithString:webpage.backgroundOriginalPath];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"WebServicesBackground"];
    
    __weak UCWebPagesCollectionViewCell *weakCell = self;
    [self.backgroundBlurred setImageWithURLRequest:request
                              placeholderImage:placeholderImage
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           
                                           weakCell.backgroundBlurred.image = image;
                                           [weakCell setNeedsLayout];
                                           
                                       } failure:nil];

}


- (void)setSelected:(BOOL)selected {
    if (selected) {
        _backgroundLayer.alpha = 0.4f;
    }
    else {
        _backgroundLayer.alpha = 0.3f;
    }
}


@end
