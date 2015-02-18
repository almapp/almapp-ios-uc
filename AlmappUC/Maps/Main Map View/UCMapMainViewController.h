//
//  UCMapMainViewController.h
//  AlmappUC
//
//  Created by Patricio López on 05-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AlmappCore/AlmappCore.h>

#import "QMBParallaxScrollViewController.h"
#import "UCMapHeaderViewController.h"
#import "UCMapBottomViewController.h"

@interface UCMapMainViewController : QMBParallaxScrollViewController <QMBParallaxScrollViewControllerDelegate>

@property (strong, nonatomic) ALMCampus *campus;

@property (strong, nonatomic) UCMapHeaderViewController *mapViewController;
@property (strong, nonatomic) UCMapBottomViewController *mapBottomViewController;

- (void)setMapTitle:(NSString *)title;

@end
