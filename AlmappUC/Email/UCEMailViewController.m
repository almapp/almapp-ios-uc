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

#import <INSPullToRefresh/INSAnimatable.h>
#import <INSPullToRefresh/INSDefaultInfiniteIndicator.h>
#import <INSPullToRefresh/INSDefaultPullToRefresh.h>
#import <INSPullToRefresh/INSInfiniteScrollBackgroundView.h>
#import <INSPullToRefresh/INSPullToRefreshBackgroundView.h>
#import <INSPullToRefresh/UIScrollView+INSPullToRefresh.h>
#import "INSPinterestPullToRefresh.h"

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
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

- (IBAction)folderButtonClick:(id)sender;

@end

@implementation UCEMailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager.delegate = self;
    
    //[_toolBar setBackgroundImage:[UIImage new] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    //[_toolBar setBackgroundColor:[UIColor clearColor]];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.tableView registerClassesNib:@[[UCEmailCell nibName]]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor accentColor]];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    
    [self setupDropDownMenu];
    [self setupRefreshAndInfinity];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self selectFolder:kDefaultFolder fetch:YES];
}

- (void)dealloc {
    [self.tableView ins_removeInfinityScroll];
    [self.tableView ins_removePullToRefresh];
}


#pragma mark - Refresh and Infinity

- (void)setupRefreshAndInfinity {
    __weak typeof(self) weakSelf = self;
    [self.tableView ins_addPullToRefreshWithHeight:60.0 handler:^(UIScrollView *scrollView) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf fetchEmails].finally(^{
                [scrollView ins_endPullToRefresh];
            });
        }
    }];
    
    UIView <INSPullToRefreshBackgroundViewDelegate> *pullToRefresh = self.refreshTopIndicator;
    self.tableView.ins_pullToRefreshBackgroundView.delegate = pullToRefresh;
    [self.tableView.ins_pullToRefreshBackgroundView addSubview:pullToRefresh];
}

- (UIView <INSPullToRefreshBackgroundViewDelegate> *)refreshTopIndicator {
    CGRect defaultFrame = CGRectMake(0, 0, 25, 25);
    INSPinterestPullToRefresh *indicator = [[INSPinterestPullToRefresh alloc] initWithFrame:defaultFrame
                                                       logo:[UIImage imageNamed:@"Refresh" tint:[UIColor darkGrayColor]]
                                                  backImage:[UIImage imageNamed:@"iconPinterestCircleLight"]
                                                 frontImage:[UIImage imageNamed:@"iconPinterestCircleDark"]];
    return indicator;
}

- (UIView<INSAnimatable> *)refreshBottomIndicator {
    CGRect defaultFrame = CGRectMake(0, 0, 24, 24);
    return [[INSDefaultInfiniteIndicator alloc] initWithFrame:defaultFrame];
}


#pragma mark - Fetching

- (void)selectFolder:(UCEmailFolder)folder fetch:(BOOL)shouldFetch{
    self.currentFolder = [self folder:folder];
    self.currentThreads = self.currentFolder.sortedThreads;
    [self.folderButton setTitle:[self folderDisplayName:folder]];
    [self.tableView reloadData];
    
    if (shouldFetch) {
        [self triggerFetching];
    }
    else {
        return;
    }
}

- (void)triggerFetching {
    [self.tableView ins_beginPullToRefresh];
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

- (ALMGmailManager *)manager {
    if (!_manager) {
        _manager = [UCAppDelegate gmailManager];
    }
    return _manager;
}


#pragma mark - Auth and token

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

- (void)gmailManager:(ALMGmailManager *)manager tokenNotFound:(NSError *)error {
    [self showAuthView];
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


#pragma mark - Table View

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


#pragma mark - Menu

- (IBAction)folderButtonClick:(id)sender {
    if (self.menu.isOpen) {
        [self hideDropDownMenu];
    }
    else {
        [self showDropDownMenu];
    }
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

- (void(^)(REMenuItem *))menuItemSelected:(UCEmailFolder)folder {
    __typeof (self) __weak weakSelf = self;
    return ^(REMenuItem *item) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf triggerFetching];
        }
    };
}

- (void)showDropDownMenu {
    [self.menu showFromNavigationController:self.navigationController];
}

- (void)hideDropDownMenu {
    [self.menu close];
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
