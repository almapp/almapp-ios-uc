//
//  UCTableViewController.m
//  AlmappUC
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "UCTableViewController.h"

@interface UCTableViewController ()

@property (strong, nonatomic) UIBarButtonItem *menuButtom;

@end

@implementation UCTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UCStyle bannerBackgroundImage] forBarMetrics:UIBarMetricsDefault];
    
    self.menuButtom = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"] style:UIBarButtonItemStyleDone target:self action:@selector(menuButtonPressed:)];
    
    self.navigationItem.leftBarButtonItem = self.menuButtom;

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

- (void)menuButtonEnable:(BOOL)enable {
    self.menuButtom.enabled = enable;
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
