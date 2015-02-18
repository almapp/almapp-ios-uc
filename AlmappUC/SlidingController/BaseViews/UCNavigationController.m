//
//  UCNavigationController.m
//  AlmappUC
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "UCNavigationController.h"
#import "Colours.h"

@interface UCNavigationController ()

@end

@implementation UCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    if([self shouldUseTransparentNavBar]) {
        [self setTranslucentNavBar];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTranslucentNavBar {
    //[self.navigationController.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    //[self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //[self.navigationBar setShadowImage:[UIImage new]];
    [self.navigationBar setTranslucent:YES];
    //[self.navigationBar setBackgroundColor:[UIColor indigoColor]];
    [self.navigationBar setBarTintColor:[UIColor indigoColor]];
    
    
}

- (void)showMenu {
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

- (BOOL)shouldUseTransparentNavBar {
    return YES;
}

-(BOOL)shouldAutorotate {
    return [[self.viewControllers lastObject] shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations {
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
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
