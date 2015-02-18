//
//  UCWebPagesCollectionViewCell.m
//  AlmappUC
//
//  Created by Patricio López on 12-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCWebPagesCollectionViewCell.h"
#import <NGAParallaxMotion/NGAParallaxMotion.h>

@implementation UCWebPagesCollectionViewCell

- (void)awakeFromNib {
    _backgroundBlurred.parallaxIntensity = 10;
}

- (void)setWebPage:(ALMWebPage *)webPage {
    _title.text = webPage.name;
    
    [_backgroundBlurred setClipsToBounds:YES];
    
    UIImage *icon = [self iconForWebpage:webPage];
    if (icon) {
        [_icon setImage:icon];
    }
    else {
        [_icon setImage:[UIImage imageNamed:@"WebServices"]];
    }
    
    UIImage *image = [self backgroundForWebpage:webPage];
    if (image) {
        [_backgroundBlurred setImage:[self backgroundForWebpage:webPage]];
    }
    else {
        [_backgroundBlurred setImage:nil];
    }
}

- (UIImage *)backgroundForWebpage:(ALMWebPage *)webPage {
    return [UIImage imageNamed:webPage.identifier];
}

- (UIImage *)iconForWebpage:(ALMWebPage *)webPage {
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@_icon", webPage.identifier]];
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
