//
//  UCTabBarViewController.m
//  AlmappUC
//
//  Created by Patricio López on 13-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCTabBarViewController.h"

@interface UCTabBarViewController ()

@end

@implementation UCTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self.navigationController.navigationBar setBackgroundImage:[UCStyle bannerBackgroundImage] forBarMetrics:UIBarMetricsDefault];
    
    UIImage *menu = [UIImage imageNamed:@"Menu"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:menu style:UIBarButtonItemStyleDone target:self action:@selector(menuButtonPressed:)];
    
    self.navigationItem.leftBarButtonItem = leftButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return [self shouldUseLightStatusBar] ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

-(IBAction)menuButtonPressed:(UIBarButtonItem*)sender {
    [self showMenu];
}

-(void)showMenu {
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (BOOL)shouldAddPanGesture {
    return YES;
}

- (BOOL)shouldUseLightStatusBar {
    return YES;
}

- (void)viewWillLayoutSubviews
{
    float height = 48.0f;
    CGRect tabFrame = self.tabBar.frame; //self.TabBar is IBOutlet of your TabBar
    tabFrame.size.height = height;
    tabFrame.origin.y = self.view.frame.size.height - height;
    self.tabBar.frame = tabFrame;
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
