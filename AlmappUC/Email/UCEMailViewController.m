//
//  UCEMailViewController.m
//  AlmappUC
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//


#import <gtm-oauth2/GTMOAuth2Authentication.h>
#import <gtm-oauth2/GTMOAuth2ViewControllerTouch.h>
#import <gtm-oauth2/GTMOAuth2SignIn.h>

#import "UCEMailViewController.h"
#import "TLYShyNavBarManager.h"
#import "UCAppDelegate.h"
#import "UCGoogleOAuthViewController.h"



@interface UCEMailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) UISearchBar *searchBar;

@end

@implementation UCEMailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //[self.view setBackgroundColor:[UIColor clearColor]];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44.f)];
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [_searchBar setBackgroundImage:[UIImage imageNamed:@"navbar.jpg"]];
    
    [self.shyNavBarManager setExtensionView:_searchBar];
    self.shyNavBarManager.contractionResistance = 100;
    
    //[_toolBar setBackgroundImage:[UIImage new] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    //[_toolBar setBackgroundColor:[UIColor clearColor]];
    
    self.shyNavBarManager.scrollView = _tableView;
    
}

- (void)showAuthView {
    [UCAppDelegate promiseLoggedToWebMail].then( ^{
        UCGoogleOAuthViewController *viewController = [UCGoogleOAuthViewController controllerWitApiKey:[UCApiKey OAuthApiKeyFor:kGoogleApiKey]];
        [[self navigationController] pushViewController:viewController animated:YES];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"EmailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor colorWithRed:247/255.0 green:249/255.0 blue:249/255.0 alpha:1.0f];
    }
    else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
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
