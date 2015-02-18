//
//  UCTableViewController.m
//  AlmappUC
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "UCTableViewController.h"

@interface UCTableViewController ()

@end

@implementation UCTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar.jpg"] forBarMetrics:UIBarMetricsDefault];
    
    UIImage *menu = [UIImage imageNamed:@"Menu"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:menu style:UIBarButtonItemStyleDone target:self action:@selector(menuButtonPressed:)];
    
    self.navigationItem.leftBarButtonItem = leftButton;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)menuButtonPressed:(UIBarButtonItem*)sender {
    [self showMenu];
}

-(void)showMenu {
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return [self shouldUseLightStatusBar] ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

- (BOOL)shouldAddPanGesture {
    return YES;
}

- (BOOL)shouldUseLightStatusBar {
    return YES;
}


@end
