//
//  UCRootViewController.m
//  AlmappUC
//
//  Created by Patricio López on 11-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCRootViewController.h"
#import "UCMenuViewController.h"
#import "UCStyle.h"

static NSString * const kSlidingMenuStoryboardID = @"menuController";

@interface UCRootViewController ()

@end

@implementation UCRootViewController

- (void)awakeFromNib {
    self.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    self.contentViewShadowColor = [UIColor blackColor];
    self.contentViewShadowOffset = CGSizeMake(0, 0);
    self.contentViewShadowOpacity = 0.6;
    self.contentViewShadowRadius = 12;
    self.contentViewShadowEnabled = YES;
    
    UCMenuViewController *menu = [self.storyboard instantiateViewControllerWithIdentifier:kSlidingMenuStoryboardID];
    self.leftMenuViewController = menu;
    
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:menu.initialViewStoryboardID];
    
    // self.rightMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightMenuViewController"];
    
    self.backgroundImage = [UCStyle mainBackgroundImage];
    self.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //[self presentLeftMenuViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController {
    NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController {
    NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController {
    NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController {
    NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
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
