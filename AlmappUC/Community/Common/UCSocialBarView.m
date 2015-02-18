//
//  UCSocialBarView.m
//  AlmappUC
//
//  Created by Patricio López on 05-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCSocialBarView.h"

@implementation UCSocialBarView

+ (instancetype)socialBarWithOwner:(id)owner {
    return [[NSBundle mainBundle] loadNibNamed:@"UCSocialBarView" owner:owner options:nil].firstObject;
}

- (void)awakeFromNib {
    NSString* nibName = @"UCSocialBarButton";
    for (UIView *view in @[self.likesView, self.commentsView, self.eventsView]) {
        UCSocialBarButton *button = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil].firstObject;
        button.frame = view.bounds;
        [view addSubview:button];
        [view setClipsToBounds:YES];
    }
    [[self likesButton] setSelected:YES];
}

- (void)setSocialResource:(ALMSocialResource<ALMEventHost> *)socialResource {
    self.likesButton.numberLabel.text = [NSString stringWithFormat:@"%ld", (long)socialResource.likesCount];
    self.likesButton.titleLabel.text = @"Likes";
    
    self.commentsButton.numberLabel.text = [NSString stringWithFormat:@"%ld", (long)socialResource.commentsCount];
    self.commentsButton.titleLabel.text = @"Comments";
    
    self.eventsButton.numberLabel.text = [NSString stringWithFormat:@"%ld", (long)socialResource.events.count];
    self.commentsButton.titleLabel.text = @"Eventos";
}

- (UCSocialBarButton *)likesButton {
    return (UCSocialBarButton *)[self.likesView subviews].firstObject;
}

- (UCSocialBarButton *)commentsButton {
    return (UCSocialBarButton *)[self.commentsView subviews].firstObject;
}

- (UCSocialBarButton *)eventsButton {
    return (UCSocialBarButton *)[self.eventsView subviews].firstObject;
}



@end
