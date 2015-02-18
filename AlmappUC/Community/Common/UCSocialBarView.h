//
//  UCSocialBarView.h
//  AlmappUC
//
//  Created by Patricio López on 05-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AlmappCore/ALMSocialResource.h>
#import <AlmappCore/ALMEvent.h>

#import "UCSocialBarButton.h"

@interface UCSocialBarView : UIView

@property (weak, nonatomic) IBOutlet UIView *likesView;
@property (weak, nonatomic) IBOutlet UIView *commentsView;
@property (weak, nonatomic) IBOutlet UIView *eventsView;

@property (weak, nonatomic) ALMSocialResource<ALMEventHost> *socialResource;

+ (instancetype)socialBarWithOwner:(id)owner;

@end
