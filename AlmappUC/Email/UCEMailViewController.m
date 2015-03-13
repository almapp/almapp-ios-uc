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

#import <UIActionSheet+PromiseKit.h>
#import <UIAlertView+PromiseKit.h>
#import <UIViewController+PromiseKit.h>
#import <UIActionSheet+PromiseKit.h>

#import <Doppelganger/Doppelganger.h>

#import <INSPullToRefresh/INSAnimatable.h>
#import <INSPullToRefresh/INSDefaultInfiniteIndicator.h>
#import <INSPullToRefresh/INSDefaultPullToRefresh.h>
#import <INSPullToRefresh/INSInfiniteScrollBackgroundView.h>
#import <INSPullToRefresh/INSPullToRefreshBackgroundView.h>
#import <INSPullToRefresh/UIScrollView+INSPullToRefresh.h>
#import "INSPinterestPullToRefresh.h"

#import "UCEMailViewController.h"
#import "UCEmailDetailViewController.h"
#import "UCThreadViewController.h"
#import "UCAppDelegate.h"
#import "UCGoogleOAuthViewController.h"
#import "UITableView+Nib.h"
#import "UCEmailCell.h"
#import "UCStyle.h"

static NSString *const kEmailShowSegue = @"EmailViewSegue";
static NSString *const kThreadShowSegue = @"ThreadViewSegue";
/*
typedef NS_ENUM(NSUInteger, UCEmailFolder) {
    UCEmailFolderInbox,
    UCEmailFolderSent,
    UCEmailFolderStarred,
    UCEmailFolderSpam,
    UCEmailFolderTrash
};
 */

static BOOL const kFetchOnViewDidLoad = NO;
static ALMEmailLabel const kDefaultLabel = ALMEmailLabelInbox;

@interface UCEMailViewController () <ALMGmailDelegate, SWTableViewCellDelegate>

@property (assign, nonatomic) ALMEmailLabel currentLabel;
@property (strong, nonatomic) NSMutableArray *currentThreads;

@property (weak, nonatomic) ALMGmailManager *manager;

@property (strong, nonatomic) UCGoogleOAuthViewController *authController;

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
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

- (IBAction)folderButtonClick:(id)sender;
- (IBAction)editButtonClick:(id)sender;


@end

@implementation UCEMailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager.delegate = self;
    
    //[_toolBar setBackgroundImage:[UIImage new] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClassesNib:@[[UCEmailCell nibName]]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor accentColor]];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    
    [self setupDropDownMenu];
    [self setupRefreshAndInfinity];
    
    [self selectLabels:kDefaultLabel fetch:kFetchOnViewDidLoad];
    
    [self switchTableViewEditingModeTo:NO];
    [self setupToolbarEditing:NO];
    [self.toolBar setTintColor:[UIColor mainColor]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)dealloc {
    [self.tableView ins_removeInfinityScroll];
    [self.tableView ins_removePullToRefresh];
}

#pragma mark - Toolbar

- (void)setupToolbarEditing:(BOOL)isEditing {
    NSMutableArray *baseItems = [self.toolBar.items subarrayWithRange:NSMakeRange(0, 2)].mutableCopy;
    if (isEditing) {
        [baseItems addObjectsFromArray:[self toolBarEditingButtons]];
        [self.toolBar setItems:baseItems animated:YES];
    }
    else {
        [baseItems addObjectsFromArray:[self toolBarButtons]];
        [self.toolBar setItems:baseItems animated:YES];
    }
}

- (NSArray *)toolBarButtons {
    //UIBarButtonItem *compose = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Trash" tint:[UIColor mainColor]] style:UIBarButtonItemStylePlain target:self action:@selector(trashButtonClick:)];
    UIBarButtonItem *compose =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeButtonClick:)];
    return @[compose];
}

- (IBAction)composeButtonClick:(id)sender {
    
}

- (NSArray *)toolBarEditingButtons {
    UIBarButtonItem *trash = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Trash" tint:[UIColor mainColor]] style:UIBarButtonItemStylePlain target:self action:@selector(trashButtonClick:)];
    
    UIBarButtonItem *star = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Star" tint:[UIColor mainColor]] style:UIBarButtonItemStylePlain target:self action:@selector(starButtonClick:)];
    
    UIBarButtonItem *readed = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Eye" tint:[UIColor mainColor]] style:UIBarButtonItemStylePlain target:self action:@selector(readedButtonClick:)];
    
    UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedItem.width = 10.0f;
    
    return @[readed, fixedItem, star, fixedItem, trash];
}

- (void)trashButtonClick:(id)sender {
    NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
    [self deleteThreadsAtIndexes:indexPaths];
}

- (void)starButtonClick:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Marcar con estrella, esto es para destacar correo importante." delegate:nil cancelButtonTitle:@"Cancelar" destructiveButtonTitle:@"Remover estrellas" otherButtonTitles:@"Añadir estrellas", nil];
    
    [sheet promiseInView:self.view].then(^(NSNumber *buttonIndex){
        NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
        switch (buttonIndex.intValue) {
            case 0: // Remove
                return [self starThreadsAtIndexes:indexPaths star:NO];
            case 1: // Star
                return [self starThreadsAtIndexes:indexPaths star:YES];
            default:
                return [PMKPromise promiseWithValue:buttonIndex];
        }
    });
}

- (void)readedButtonClick:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Marcar como leído." delegate:nil cancelButtonTitle:@"Cancelar" destructiveButtonTitle:@"Marcar como no leído" otherButtonTitles:@"Marcar como leído", nil];
    
    [sheet promiseInView:self.view].then(^(NSNumber *buttonIndex){
        NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
        switch (buttonIndex.intValue) {
            case 0: // Remove
                return [self readThreadsAtIndexes:indexPaths readed:NO];
            case 1: // Readed
                return [self readThreadsAtIndexes:indexPaths readed:YES];
            default:
                return [PMKPromise promiseWithValue:buttonIndex];
        }
    });
}



#pragma mark - Refresh and Infinity

- (void)setupRefreshAndInfinity {
    __weak typeof(self) weakSelf = self;
    [self.tableView ins_addPullToRefreshWithHeight:60.0 handler:^(UIScrollView *scrollView) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            strongSelf.folderButton.enabled = NO;
            [strongSelf fetchFirstItems].finally(^{
                [scrollView ins_endPullToRefresh];
                strongSelf.folderButton.enabled = YES;
            });
        }
    }];
    [self.tableView ins_addInfinityScrollWithHeight:60.0f handler:^(UIScrollView *scrollView) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            strongSelf.folderButton.enabled = NO;
            [strongSelf fetchNextPageEmails].finally(^{
                [scrollView ins_endInfinityScroll];
                strongSelf.folderButton.enabled = YES;
            });
        }
    }];
    
    UIView <INSPullToRefreshBackgroundViewDelegate> *pullToRefresh = self.refreshTopIndicator;
    self.tableView.ins_pullToRefreshBackgroundView.delegate = pullToRefresh;
    [self.tableView.ins_pullToRefreshBackgroundView addSubview:pullToRefresh];
    
    UIView <INSAnimatable> *infinityIndicator = [self refreshBottomIndicator];
    [self.tableView.ins_infiniteScrollBackgroundView addSubview:infinityIndicator];
    [infinityIndicator startAnimating];
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


#pragma mark - Cache

- (NSMutableDictionary *)lastPageTokens {
    static NSMutableDictionary *lastPageTokens = nil;
    if (!lastPageTokens) {
        lastPageTokens = [NSMutableDictionary dictionary];
    }
    return lastPageTokens;
}

- (NSMutableDictionary *)threadStates {
    static NSMutableDictionary *threadStates = nil;
    if (!threadStates) {
        threadStates = [NSMutableDictionary dictionary];
    }
    return threadStates;
}


#pragma mark - Fetching

- (NSInteger)itemsPerPage {
    return 20;
}

- (void)selectLabels:(ALMEmailLabel)labels fetch:(BOOL)shouldFetch{
    self.currentLabel = labels;
    self.currentThreads = [self folder:self.currentLabel].mutableCopy;
    
    NSLog(@"COUNT %lu", (unsigned long)self.currentThreads.count);
    
    [self.folderButton setTitle:[self labelDisplayName:labels]];
    
    //[self.tableView reloadData];
    [self.tableView beginUpdates];
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
    [self.tableView endUpdates];
    
    if (shouldFetch) {
        [self triggerrefreshFirstItems];
    }
    else {
        return;
    }
}

- (void)triggerrefreshFirstItems {
    [self.tableView ins_beginPullToRefresh];
}

- (NSString *)lastPageToken {
    return self.lastPageTokens[@(self.currentLabel)];
}

- (PMKPromise *)fetchFirstItems {
    return [self fetchEmailsOnPage:nil].then(^(NSArray *emailThreads, NSString *nextPageToken) {
        if (!self.lastPageToken && nextPageToken) {
            [self.lastPageTokens setObject:nextPageToken forKey:@(self.currentLabel)];
        }
        NSArray *oldData = self.currentThreads;
        self.currentThreads = emailThreads.mutableCopy;
        
        NSArray *diffs = [WMLArrayDiffUtility diffForCurrentArray:self.currentThreads
                                                    previousArray:oldData];
        
        [self.tableView wml_applyBatchChanges:diffs
                                    inSection:0
                             withRowAnimation:UITableViewRowAnimationRight];
        
        return PMKManifold(emailThreads, nextPageToken);
    });

}

- (PMKPromise *)fetchNextPageEmails {
    return [self fetchEmailsOnPage:self.lastPageToken].then(^(NSArray *emailThreads, NSString *nextPageToken) {
        if (nextPageToken) {
            [self.lastPageTokens setObject:nextPageToken forKey:@(self.currentLabel)];
        }
        
        NSArray *oldData = self.currentThreads.copy;
        [self.currentThreads addObjectsFromArray:emailThreads];

        NSArray *diffs = [WMLArrayDiffUtility diffForCurrentArray:self.currentThreads
                                                    previousArray:oldData];
        
        [self.tableView wml_applyBatchChanges:diffs
                                    inSection:0
                             withRowAnimation:UITableViewRowAnimationRight];
        
        return PMKManifold(emailThreads, nextPageToken);
    });
}

- (PMKPromise *)fetchEmailsOnPage:(NSString *)pageToken {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    return [self.manager fetchThreadsWithEmailsLabeled:self.currentLabel count:self.itemsPerPage pageToken:pageToken].then(^(NSArray *emailThreads, NSArray *errors, NSString *nextPageToken) {
        
        return PMKManifold(emailThreads, nextPageToken);
        
    }).finally( ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    });
}


- (NSString *)labelDisplayName:(ALMEmailLabel)index {
    switch (index) {
        case ALMEmailLabelInbox:
            return @"Inbox";
        case ALMEmailLabelSent:
            return @"Enviados";
        case ALMEmailLabelStarred:
            return @"Marcados";
        case ALMEmailLabelSpam:
            return @"Spam";
        case ALMEmailLabelTrash:
            return @"Basura";
        default:
            return [self labelDisplayName:kDefaultLabel];
    }
}

- (NSArray *)folder:(ALMEmailLabel)index {
    switch (index) {
        case ALMEmailLabelInbox:
            return self.manager.inboxFolder;
        case ALMEmailLabelSent:
            return self.manager.sentFolder;
        case ALMEmailLabelStarred:
            return self.manager.starredFolder;
        case ALMEmailLabelSpam:
            return self.manager.spamFolder;
        case ALMEmailLabelTrash:
            return self.manager.trashFolder;
        default:
            return [self folder:kDefaultLabel];
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
    [self.navigationController showProgressWithTitle:@"Preparando..."];
    [UCAppDelegate promiseLoggedToWebMail].then( ^{
        [self.navigationController dismissProgress];
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


#pragma mark - States
- (UCEmailCellState)stateForThread:(ALMEmailThread *)thread {
    NSNumber *state = self.threadStates[thread.identifier];
    return (state) ? [state integerValue] : UCEmailCellStateNormal;
}

- (void)setState:(UCEmailCellState)state onArray:(id<NSFastEnumeration>)threads {
    for (ALMEmailThread *thread in threads) {
        [self setState:state on:thread];
    }
}

- (void)setState:(UCEmailCellState)state on:(ALMEmailThread *)thread {
    if (state == UCEmailCellStateNormal) {
        [self.threadStates removeObjectForKey:thread.identifier];
    }
    else {
        self.threadStates[thread.identifier] = @(state);
    }
}

- (BOOL)isCellBusy:(NSIndexPath *)indexPath {
    ALMEmailThread *thread = self.currentThreads[indexPath.row];
    return [self isThreadBusy:thread];
}

- (BOOL)isThreadBusy:(ALMEmailThread *)thread {
    UCEmailCellState state = [self stateForThread:thread];
    return !(state == UCEmailCellStateNormal || state == UCEmailCellStateError);
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
    cell.delegate = self;
    cell.isEven = indexPath.row % 2 == 0;
    ALMEmailThread *thread = self.currentThreads[indexPath.row];
    [cell setThread:thread email:[thread displayEmail] state:[self stateForThread:thread]];
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return ([self isCellBusy:indexPath]) ? nil : indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!tableView.isEditing) {
        ALMEmailThread *thread = self.currentThreads[indexPath.row];
        
        NSString *segue = (thread.emails.count > 1) ? kThreadShowSegue : kEmailShowSegue;
        [self performSegueWithIdentifier:segue sender:self];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return ![self isCellBusy:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UCEmailCell height];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UCEmailCell height];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


#pragma mark - Swipeable delegate

// click event on left utility button
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    switch (index) {
        case 0:
            [self readThreadAtIndex:indexPath];
            break;
        case 1:
            [self starThreadAtIndex:indexPath];
            break;
        default:
            break;
    }
}

// click event on right utility button
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0: {
            [cell showLeftUtilityButtonsAnimated:YES];
            break;
        }
        case 1: {
            [cell hideUtilityButtonsAnimated:YES];
            [self deleteThreadsAtIndexes:@[[self.tableView indexPathForCell:cell]]];
            break;
        }
        default:
            break;
    }
    
}

// utility button open/close event
- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state {
    
}

// prevent multiple cells from showing utilty buttons simultaneously
- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    return YES;
}

// prevent cell(s) from displaying left/right utility buttons
- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state {
    return YES;
}


#pragma mark - Actions

- (IBAction)editButtonClick:(id)sender {
    [self switchTableViewEditingModeTo:!self.tableView.isEditing];
}

- (void)switchTableViewEditingModeTo:(BOOL)enable {
    if (enable) {
        [self.tableView setEditing:YES animated:YES];
        [self.editButton setTitle:@"Listo"];
        [super menuButtonEnable:NO];
        self.folderButton.enabled = NO;
    }
    else {
        [self.tableView setEditing:NO animated:YES];
        [self.editButton setTitle:@"Editar"];
        [super menuButtonEnable:YES];
        self.folderButton.enabled = YES;
    }
    [self setupToolbarEditing:enable];
}

- (PMKPromise *)starThreadAtIndex:(NSIndexPath *)index {
    ALMEmailThread *thread = self.currentThreads[index.row];
    BOOL starred = (thread.newestEmail.labels & ALMEmailLabelStarred);
    return [self readThreadsAtIndexes:@[index] readed:!starred];
}

- (PMKPromise *)starThreadsAtIndexes:(NSArray *)indexes star:(BOOL)star {
    if (star) {
        return [self addLabels:@[kGmailLabelSTARRED] removeLabels:nil andRemove:NO indexes:indexes];
    }
    else {
        return [self addLabels:nil removeLabels:@[kGmailLabelSTARRED] andRemove:NO indexes:indexes];
    }
}

- (PMKPromise *)readThreadAtIndex:(NSIndexPath *)index {
    ALMEmailThread *thread = self.currentThreads[index.row];
    BOOL readed = !(thread.newestEmail.labels & ALMEmailLabelUnread);
    return [self readThreadsAtIndexes:@[index] readed:!readed];
}

- (PMKPromise *)readThreadsAtIndexes:(NSArray *)indexes readed:(BOOL)readed {
    if (readed) {
        return [self addLabels:nil removeLabels:@[kGmailLabelUNREAD] andRemove:NO indexes:indexes];
    }
    else {
        return [self addLabels:@[kGmailLabelUNREAD] removeLabels:nil andRemove:NO indexes:indexes];
    }
}

- (PMKPromise *)deleteThreadsAtIndexes:(NSArray *)indexes {
    return [self addLabels:@[kGmailLabelTRASH] removeLabels:nil andRemove:YES indexes:indexes];
}

- (PMKPromise *)addLabels:(NSArray *)addLabels removeLabels:(NSArray *)removeLabels andRemove:(BOOL)shouldRemove indexes:(NSArray *)indexes {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSMutableArray *threads = [NSMutableArray arrayWithCapacity:indexes.count];
    for (NSIndexPath *indexPath in indexes) {
        ALMEmailThread *t = [self.currentThreads objectAtIndex:indexPath.row];
        [self setState:UCEmailCellStateDeleting on:t];
        [threads addObject:t];
    }
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
    NSMutableArray *emails = [NSMutableArray array];
    for (ALMEmailThread *thread in threads) {
        for (ALMEmail *email in thread.emails) {
            [emails addObject:email];
        }
    }
    
    return [self.manager modifyEmails:emails addLabels:addLabels removeLabels:removeLabels].then( ^(NSArray *emails, NSArray *errors) {
        NSLog(@"%@", errors);
        
        NSMutableArray *newIndexes = [NSMutableArray arrayWithCapacity:threads.count];
        for (ALMEmailThread *thread in threads) {
            NSUInteger index = [self.currentThreads indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                return [[obj identifier] isEqualToString:thread.identifier ];
            }];
            
            if (index != NSNotFound) {
                [newIndexes addObject:[NSIndexPath indexPathForRow:index inSection:0]];
                ALMEmailThread *newThread = [ALMEmailThread objectForPrimaryKey:thread.identifier];
                if (!shouldRemove) {
                    [self.currentThreads replaceObjectAtIndex:index withObject:newThread];
                }
                [self setState:UCEmailCellStateNormal on:thread];
            }
        }
        
        [self.tableView beginUpdates];
        
        if (shouldRemove) {
            NSMutableIndexSet *indexesToRemove = [[NSMutableIndexSet alloc] init];
            for (NSIndexPath *indexPath in newIndexes) {
                [indexesToRemove addIndex:indexPath.row];
            }
            [self.currentThreads removeObjectsAtIndexes:indexesToRemove];
            [self.tableView deleteRowsAtIndexPaths:newIndexes withRowAnimation:UITableViewRowAnimationLeft];
        }
        else {
            [self.tableView reloadRowsAtIndexPaths:newIndexes withRowAnimation:UITableViewRowAnimationFade];
        }
        
        [self.tableView endUpdates];
        
        return emails;
        
    }).catch( ^(NSError *error) {
        NSLog(@"Error %@", error);
        
        NSMutableArray *newIndexes = [NSMutableArray arrayWithCapacity:threads.count];
        for (ALMEmailThread *thread in threads) {
            NSUInteger index = [self.currentThreads indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                return [[obj identifier] isEqualToString:thread.identifier ];
            }];
            if (index != NSNotFound) {
                [newIndexes addObject:[NSIndexPath indexPathForRow:index inSection:0]];
                [self setState:UCEmailCellStateError on:thread];
            }
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:newIndexes withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        }
        return error;
    }).finally( ^ {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    });
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
    self.inboxItem = [[REMenuItem alloc] initWithTitle:[self labelDisplayName:ALMEmailLabelInbox]
                                              subtitle:@"Bandeja de entrada"
                                                 image:[UIImage imageNamed:@"Inbox" tint:[UIColor whiteColor]]
                                      highlightedImage:nil
                                                action:[self menuItemSelected:ALMEmailLabelInbox]];
    
    self.sentItem = [[REMenuItem alloc] initWithTitle:[self labelDisplayName:ALMEmailLabelSent]
                                             subtitle:@"Bandeja de mensajes enviados"
                                                image:[UIImage imageNamed:@"Outbox" tint:[UIColor whiteColor]]
                                     highlightedImage:nil
                                               action:[self menuItemSelected:ALMEmailLabelSent]];
    
    self.starredItem = [[REMenuItem alloc] initWithTitle:[self labelDisplayName:ALMEmailLabelStarred]
                                                subtitle:@"Bandeja de mensajes con estrella"
                                                   image:[UIImage imageNamed:@"Star" tint:[UIColor whiteColor]]
                                        highlightedImage:nil
                                                  action:[self menuItemSelected:ALMEmailLabelStarred]];
    
    self.spamItem = [[REMenuItem alloc] initWithTitle:[self labelDisplayName:ALMEmailLabelSpam]
                                             subtitle:@"Bandeja de mensajes spam"
                                                image:[UIImage imageNamed:@"Warning" tint:[UIColor whiteColor]]
                                     highlightedImage:nil
                                               action:[self menuItemSelected:ALMEmailLabelSpam]];
    
    self.trashItem = [[REMenuItem alloc] initWithTitle:[self labelDisplayName:ALMEmailLabelTrash]
                                              subtitle:@"Bandeja de mensajes borrados"
                                                 image:[UIImage imageNamed:@"Trash" tint:[UIColor whiteColor]]
                                      highlightedImage:nil
                                                action:[self menuItemSelected:ALMEmailLabelTrash]];
    
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

- (void(^)(REMenuItem *))menuItemSelected:(ALMEmailLabel)label {
    __typeof (self) __weak weakSelf = self;
    return ^(REMenuItem *item) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            strongSelf.scrollToTop.then( ^{
                [strongSelf selectLabels:label fetch:YES];
            });
        }
    };
}

- (PMKPromise *)scrollToTop {
    return [UIView promiseWithDuration:0.3 animations:^{
        [self.tableView setContentOffset:CGPointZero animated:NO];
    }];
}

- (void)showDropDownMenu {
    [self.menu showFromNavigationController:self.navigationController];
}

- (void)hideDropDownMenu {
    [self.menu close];
}



 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     NSUInteger selectedIndex = [self.tableView indexPathForSelectedRow].row;
     if ([segue.identifier isEqual:kEmailShowSegue]) {
         UCEmailDetailViewController *detail = [segue destinationViewController];
         detail.threadList = self.currentThreads;
         detail.email = [self.currentThreads[selectedIndex] displayEmail];
     }
     else if ([segue.identifier isEqual:kThreadShowSegue]) {
         UCThreadViewController *detail = [segue destinationViewController];
         detail.selectedThreadIndex = selectedIndex;
         detail.currentThreads = self.currentThreads;
     }
     
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }


@end
