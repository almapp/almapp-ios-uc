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

#import "UIScrollView+SVPullToRefresh.h"
#import "TLYShyNavBarManager.h"

#import "UCEMailViewController.h"
#import "UCAppDelegate.h"
#import "UCGoogleOAuthViewController.h"
#import "UITableView+Nib.h"
#import "UCEmailCell.h"
#import "UCStyle.h"

typedef NS_ENUM(NSUInteger, UCEmailFolder) {
    UCEmailFolderInbox,
    UCEmailFolderSent,
    UCEmailFolderStarred,
    UCEmailFolderSpam,
    UCEmailFolderTrash
};

static UCEmailFolder const kDefaultFolder = UCEmailFolderInbox;

@interface UCEMailViewController () <ALMGmailDelegate>

@property (strong, nonatomic) UCGoogleOAuthViewController *authController;
@property (weak, nonatomic) ALMGmailManager *manager;
@property (strong, nonatomic) ALMEmailFolder *currentFolder;
@property (strong, nonatomic) RLMResults *currentThreads;

@property (strong, nonatomic) REMenu *menu;
@property (strong, nonatomic) REMenuItem *inboxItem;
@property (strong, nonatomic) REMenuItem *sentItem;
@property (strong, nonatomic) REMenuItem *starredItem;
@property (strong, nonatomic) REMenuItem *spamItem;
@property (strong, nonatomic) REMenuItem *trashItem;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *folderButton;

@property (strong, nonatomic) UISearchBar *searchBar;

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
    
    self.manager.delegate = self;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];
    if (self.tableView.pullToRefreshView == nil) {
        __weak typeof(self) weakSelf = self;
        [self.tableView addPullToRefreshWithActionHandler:^{
            [self selectFolder:kDefaultFolder fetch:YES].finally(^{
                [weakSelf.tableView.pullToRefreshView stopAnimating];
            });
        }];
        
        [self.tableView triggerPullToRefresh];
    }
}

- (ALMGmailManager *)manager {
    if (!_manager) {
        _manager = [UCAppDelegate gmailManager];
    }
    return _manager;
}

- (PMKPromise *)selectFolder:(UCEmailFolder)folder fetch:(BOOL)shouldFetch{
    self.currentFolder = [self folder:folder];
    self.currentThreads = self.currentFolder.sortedThreads;
    // self.tableView.showsPullToRefresh = (self.currentThreads.count == 0);
    [self.folderButton setTitle:[self folderDisplayName:folder]];
    [self.tableView reloadData];
    
    if (shouldFetch) {
        return [self fetchEmails:self.currentFolder];
    }
    else {
        return nil;
    }
    
}

- (PMKPromise *)fetchEmails {
    return [self fetchEmails:self.currentFolder];
}

- (PMKPromise *)fetchEmails:(ALMEmailFolder *)folder {
    return [self.manager fetchEmailsInFolder:self.currentFolder].then(^(RLMArray *emailThreads) {
        self.currentThreads = self.currentFolder.sortedThreads;
        [self.tableView reloadData];
        return self.currentThreads;
    });
}

- (NSString *)folderDisplayName:(UCEmailFolder)index {
    switch (index) {
        case UCEmailFolderInbox:
            return @"Inbox";
        case UCEmailFolderSent:
            return @"Enviados";
        case UCEmailFolderStarred:
            return @"Marcados";
        case UCEmailFolderSpam:
            return @"Spam";
        case UCEmailFolderTrash:
            return @"Basura";
        default:
            return [self folderDisplayName:kDefaultFolder];
    }
}

- (ALMEmailFolder *)folder:(UCEmailFolder)index {
    switch (index) {
        case UCEmailFolderInbox:
            return self.manager.inboxFolder;
        case UCEmailFolderSent:
            return self.manager.sentFolder;
        case UCEmailFolderStarred:
            return self.manager.starredFolder;
        case UCEmailFolderSpam:
            return self.manager.spamFolder;
        case UCEmailFolderTrash:
            return self.manager.threadFolder;
        default:
            return [self folder:kDefaultFolder];
    }
}

- (void)gmailManager:(ALMGmailManager *)manager tokenNotFound:(NSError *)error {
    [self showAuthView];
}

- (void(^)(REMenuItem *))menuItemSelected:(UCEmailFolder)folder {
    __typeof (self) __weak weakSelf = self;
    return ^(REMenuItem *item) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf selectFolder:folder fetch:YES];
        }
    };
}

- (void)setupDropDownMenu {
    self.inboxItem = [[REMenuItem alloc] initWithTitle:[self folderDisplayName:UCEmailFolderInbox]
                                              subtitle:@"Bandeja de entrada"
                                                 image:[UIImage imageNamed:@"Inbox" tint:[UIColor whiteColor]]
                                      highlightedImage:nil
                                                action:[self menuItemSelected:UCEmailFolderInbox]];
    
    self.sentItem = [[REMenuItem alloc] initWithTitle:[self folderDisplayName:UCEmailFolderSent]
                                             subtitle:@"Bandeja de mensajes enviados"
                                                image:[UIImage imageNamed:@"Outbox" tint:[UIColor whiteColor]]
                                     highlightedImage:nil
                                               action:[self menuItemSelected:UCEmailFolderSent]];
    
    self.starredItem = [[REMenuItem alloc] initWithTitle:[self folderDisplayName:UCEmailFolderStarred]
                                                subtitle:@"Bandeja de mensajes con estrella"
                                                   image:[UIImage imageNamed:@"Star" tint:[UIColor whiteColor]]
                                        highlightedImage:nil
                                                  action:[self menuItemSelected:UCEmailFolderStarred]];
    
    self.spamItem = [[REMenuItem alloc] initWithTitle:[self folderDisplayName:UCEmailFolderSpam]
                                             subtitle:@"Bandeja de mensajes spam"
                                                image:[UIImage imageNamed:@"Warning" tint:[UIColor whiteColor]]
                                     highlightedImage:nil
                                               action:[self menuItemSelected:UCEmailFolderSpam]];
    
    self.trashItem = [[REMenuItem alloc] initWithTitle:[self folderDisplayName:UCEmailFolderTrash]
                                              subtitle:@"Bandeja de mensajes borrados"
                                                 image:[UIImage imageNamed:@"Trash" tint:[UIColor whiteColor]]
                                      highlightedImage:nil
                                                action:[self menuItemSelected:UCEmailFolderTrash]];
    
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
    [self.searchBar setBackgroundImage:[UCStyle bannerBackgroundImage]];
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

- (UCGoogleOAuthViewController *)authController {
    if (!_authController) {
        __weak __typeof(self) weakSelf = self;
        UCApiKey *apiKey = [UCApiKey OAuthApiKeyFor:kGoogleApiKey];
        _authController = [UCGoogleOAuthViewController controllerWitApiKey:apiKey block:^(GTMOAuth2ViewControllerTouch *viewController, GTMOAuth2Authentication *auth, NSError *error) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                if (error) {
                    NSLog(@"%@", error);
                }
                else {
                    [self sendAuthToServer:auth];
                }
            }
        }];
    }
    return _authController;
}

- (void)showAuthView {
    [UCAppDelegate promiseLoggedToWebMail].then( ^{
        [[self navigationController] pushViewController:self.authController animated:YES];
    });
}

- (PMKPromise *)sendAuthToServer:(GTMOAuth2Authentication *)auth {
    return [self.manager setFirstAuthentication:auth].then(^(ALMEmailToken *token) {
        NSLog(@"Token setted on server");
        return token;
        
    }).catch( ^(NSError *error) {
        NSLog(@"%@", error);
        return error;
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
    return self.currentThreads.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UCEmailCell* cell = [self.tableView dequeueReusableCellWithIdentifier:[UCEmailCell nibName]];
    cell.isEven = indexPath.row % 2 == 0;
    cell.emailThread = self.currentThreads[indexPath.row];
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
