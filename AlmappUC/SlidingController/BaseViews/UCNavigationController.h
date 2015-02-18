//
//  UCNavigationController.h
//  AlmappUC
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RESideMenu/RESideMenu.h>
#import "UIColor+Almapp.h"

@interface UCNavigationController : UINavigationController

- (void)showMenu;

- (BOOL)shouldAddPanGesture;

- (BOOL)shouldUseLightStatusBar;

- (BOOL)shouldUseTransparentNavBar;

@end
