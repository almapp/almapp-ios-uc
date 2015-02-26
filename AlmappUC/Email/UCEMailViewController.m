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

#import "TLYShyNavBarManager.h"

#import "UCEMailViewController.h"
#import "UCAppDelegate.h"
#import "UCGoogleOAuthViewController.h"
#import "UITableView+Nib.h"
#import "UCEmailCell.h"
#import "UIColor+Almapp.h"


@interface UCEMailViewController () 

@property (strong, nonatomic) REMenu *menu;
@property (strong, nonatomic) REMenuItem *inboxItem;
@property (strong, nonatomic) REMenuItem *sentItem;
@property (strong, nonatomic) REMenuItem *starredItem;
@property (strong, nonatomic) REMenuItem *spamItem;
@property (strong, nonatomic) REMenuItem *trashItem;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *folderButton;
- (IBAction)folderButtonClick:(id)sender;

@end

@implementation UCEMailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //[_toolBar setBackgroundImage:[UIImage new] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    //[_toolBar setBackgroundColor:[UIColor clearColor]];
    
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView registerClassesNib:@[[UCEmailCell nibName]]];
    
    [self setupSearchBar];
    [self setupShyNavBar];
    [self setupDropDownMenu];
}

- (void)setupDropDownMenu {
    __typeof (self) __weak weakSelf = self;
    void(^buttonAction)(REMenuItem *item) = ^(REMenuItem *item) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf.folderButton setTitle:item.title];
        }
    };
    
    self.inboxItem = [[REMenuItem alloc] initWithTitle:@"Inbox"
                                                    subtitle:@"Bandeja de entrada"
                                                       image:[UIImage imageNamed:@"Email"]
                                            highlightedImage:nil
                                                       action:buttonAction];
    
    self.sentItem = [[REMenuItem alloc] initWithTitle:@"Enviados"
                                                       subtitle:@"Bandeja de mensajes enviados"
                                                          image:[UIImage imageNamed:@"Email"]
                                               highlightedImage:nil
                                                      action:buttonAction];
    
    self.starredItem = [[REMenuItem alloc] initWithTitle:@"Marcados"
                                                        subtitle:@"Bandeja de mensajes con estrella"
                                                           image:[UIImage imageNamed:@"Email"]
                                                highlightedImage:nil
                                                         action:buttonAction];
    
    self.spamItem = [[REMenuItem alloc] initWithTitle:@"Spam"
                                             subtitle:@"Bandeja de mensajes spam"
                                                image:[UIImage imageNamed:@"Email"]
                                     highlightedImage:nil
                                               action:buttonAction];
    
    self.trashItem = [[REMenuItem alloc] initWithTitle:@"Borrados"
                                              subtitle:@"Bandeja de mensajes borrados"
                                                 image:[UIImage imageNamed:@"Email"]
                                      highlightedImage:nil
                                                action:buttonAction];
    
    self.menu = [[REMenu alloc] initWithItems:@[self.inboxItem,
                                                self.sentItem,
                                                self.starredItem,
                                                self.spamItem,
                                                self.trashItem]];
    self.menu.bounce = YES;
    self.menu.liveBlur = YES;
    self.menu.liveBlurBackgroundStyle = REMenuLiveBackgroundStyleDark;
    self.menu.textColor = [UIColor whiteColor];
    self.menu.subtitleTextColor = [UIColor lightTextColor];
    self.menu.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:19];
    self.menu.subtitleFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    self.menu.subtitleTextOffset = CGSizeMake(0, -2);
}

- (void)setupSearchBar {
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44.f)];
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [self.searchBar setBackgroundImage:[UIImage imageNamed:@"navbar.jpg"]];
}

- (void)setupShyNavBar {
    [self.shyNavBarManager setExtensionView:self.searchBar];
    self.shyNavBarManager.contractionResistance = 100;
    self.shyNavBarManager.scrollView = _tableView;
}

- (void)showDropDownMenu {
    [self.menu showFromNavigationController:self.navigationController];
}

- (void)hideDropDownMenu {
    [self.menu close];
}

- (void)showAuthView {
    [UCAppDelegate promiseLoggedToWebMail].then( ^{
        UCGoogleOAuthViewController *viewController = [UCGoogleOAuthViewController controllerWitApiKey:[UCApiKey OAuthApiKeyFor:kGoogleApiKey]];
        [[self navigationController] pushViewController:viewController animated:YES];
    });
}


- (IBAction)folderButtonClick:(id)sender {
    if (self.menu.isOpen) {
        [self hideDropDownMenu];
    }
    else {
        [self showDropDownMenu];
    }
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
    UCEmailCell* cell = [self.tableView dequeueReusableCellWithIdentifier:[UCEmailCell nibName]];
    cell.isEven = indexPath.row % 2 == 0;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UCEmailCell height];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UCEmailCell height];
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
