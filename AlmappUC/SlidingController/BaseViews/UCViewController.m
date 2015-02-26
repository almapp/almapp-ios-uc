//
//  UCViewController.m
//  AlmappUC
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "UCViewController.h"

@interface UCViewController ()

@end

@implementation UCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    //[self.view setBackgroundColor:[UIColor clearColor]];
    if([self shouldAddPanGesture]) {
        //[self.view addGestureRecognizer:self.slidingViewController.panGesture];
    }
    
    [self.navigationController.navigationBar setBackgroundImage:[UCStyle bannerBackgroundImage] forBarMetrics:UIBarMetricsDefault];
    
    UIImage *menu = [UIImage imageNamed:@"Menu"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:menu style:UIBarButtonItemStyleDone target:self action:@selector(menuButtonPressed:)];
    
    self.navigationItem.leftBarButtonItem = leftButton;
    

    // UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:[super hamburgerButton]];
    // NSArray *arrRightBarItems = @[barButtonItem2];
    // self.navigationItem.leftBarButtonItems = arrRightBarItems;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)menuButtonPressed:(UIBarButtonItem*)sender {
    [self showMenu];
}
                                   
- (void)showMenu {
    [self.sideMenuViewController presentLeftMenuViewController];
    
    //if ([self.slidingViewController currentTopViewPosition] == ECSlidingViewControllerTopViewPositionAnchoredRight) {
    //    [self.slidingViewController resetTopViewAnimated:YES];
    //}
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

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
