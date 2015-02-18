//
//  UCSocialBarButton.m
//  AlmappUC
//
//  Created by Patricio López on 05-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCSocialBarButton.h"

@implementation UCSocialBarButton

- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
    [self.selectedView setHidden:YES];
}

- (void)setSelected:(BOOL)selected {
    [self.selectedView setHidden:!selected];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
