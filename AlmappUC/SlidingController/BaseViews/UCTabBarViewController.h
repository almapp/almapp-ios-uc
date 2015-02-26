//
//  UCTabBarViewController.h
//  AlmappUC
//
//  Created by Patricio López on 13-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RESideMenu/RESideMenu.h>
#import "UCStyle.h"
#import "BFPaperTabBarController.h"

@interface UCTabBarViewController : BFPaperTabBarController

- (void)showMenu;

- (BOOL)shouldAddPanGesture;

- (BOOL)shouldUseLightStatusBar;

@end
