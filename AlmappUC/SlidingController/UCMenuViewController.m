//
//  UCMenuViewController.m
//  AlmappUC
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import "UCMenuViewController.h"
#import "UCAppDelegate.h"
#import "UIImage+ImageEffects.h"
#import "UCImageHelper.h"
#import "UCButtonHelper.h"
#import "UIColor+Almapp.h"
#import "UITableView+Nib.h"

#import "UCMenuCell.h"
#import "UCMenuHeaderCell.h"

static int const kDefaultViewIndex = 1;
static NSString *const kControllerStoryboardIDForProfile = @"";
static NSString *const kControllerStoryboardIDForMaps = @"mapsNavigation";
static NSString *const kControllerStoryboardIDForOrganizer = @"organizerNavigation";
static NSString *const kControllerStoryboardIDForChat = @"chatNavigation";
static NSString *const kControllerStoryboardIDForCommunity = @"communityTabBar";
static NSString *const kControllerStoryboardIDForEmail = @"emailNavigation";
static NSString *const kControllerStoryboardIDForWebServices = @"webPagesNavigation";
static NSString *const kControllerStoryboardIDForUtilities = @"";

@interface UCMenuViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign) NSInteger currentViewIndex;
@property (nonatomic, weak) UINavigationController *currentViewController;

@property (nonatomic, strong) NSMutableArray *searchResult;
@property (assign) BOOL isUserSearching;

@end


@implementation UCMenuViewController

#pragma mark - Configuration

- (NSArray *)menuItems {
    if (!_menuItems) {
        _menuItems = @[
                       [[UCMenuItem alloc] initWithTitle:@"Ramos y horario"
                                             imageString:@"Organizer"
                                                viewName:kControllerStoryboardIDForOrganizer],
                       
                       [[UCMenuItem alloc] initWithTitle:@"Mapas"
                                             imageString:@"Maps"
                                                viewName:kControllerStoryboardIDForMaps],
                       
                       [[UCMenuItem alloc] initWithTitle:@"Chat"
                                             imageString:@"Chat"
                                                viewName:kControllerStoryboardIDForChat],
                       
                       [[UCMenuItem alloc] initWithTitle:@"Comunidad y eventos"
                                             imageString:@"Community"
                                                viewName:kControllerStoryboardIDForCommunity],
                       
                       [[UCMenuItem alloc] initWithTitle:@"Email"
                                             imageString:@"Email"
                                                viewName:kControllerStoryboardIDForEmail],
                       
                       [[UCMenuItem alloc] initWithTitle:@"Servicios Web"
                                             imageString:@"WebServices"
                                                viewName:kControllerStoryboardIDForWebServices],
                       
                       [[UCMenuItem alloc] initWithTitle:@"Utilidades"
                                             imageString:@"Settings"
                                                viewName:kControllerStoryboardIDForUtilities]
                       ];
    }
    return _menuItems;
}

#pragma mark - Methods

- (UCNavigationController*)preparedControllerForIndex:(int)index {
    UCNavigationController* controller = [self controllerForIndex:index];
    return controller;
}

- (UCNavigationController*)controllerForIndex:(NSInteger)index {
    return [self.storyboard instantiateViewControllerWithIdentifier:[self controllerStoryboardIDForIndex:index]];
}

- (NSString *)controllerStoryboardIDForIndex:(NSInteger)index {
    UCMenuItem *item = [self.menuItems objectAtIndex:index];
    if (item != nil && item.viewName != nil && item.viewName.length > 0) {
        return item.viewName;
    }
    else {
        return ((UCMenuItem*)[self.menuItems objectAtIndex:kDefaultViewIndex]).viewName;
    }
}

- (NSString *)initialViewStoryboardID {
    return [self controllerStoryboardIDForIndex:_currentViewIndex];
}


#pragma mark - Apparence

- (void)setupApparence {
    [self setNeedsStatusBarAppearanceUpdate];
    [self.view setBackgroundColor:[UIColor myTransparent]];
    [self.tableView setBackgroundColor:[UIColor myTransparent]];
    
    //UILabel *headerLabelAppearance = [UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil];
    //[headerLabelAppearance setBackgroundColor:[UIColor clearColor]];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


#pragma mark - Lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _currentViewIndex = kDefaultViewIndex;
        _isUserSearching = NO;
        _searchResult = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClassesNib:@[[UCMenuCell nibName], [UCMenuHeaderCell nibName]]];

    [self setupApparence];
    [self.tableView reloadData];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    //[self.menuTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:(_currentViewIndex + 1) inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:kDefaultViewIndex inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionBottom];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([self isSearching]) {
        return _searchResult.count;
    }
    else {
        return self.menuItems.count;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UCMenuHeaderCell *header = [self.tableView dequeueReusableCellWithIdentifier:[UCMenuHeaderCell nibName]];
    ALMSession *session = [UCAppDelegate currentSession];
    header.user = session.user;
    
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self isSearching]) {
        /*
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kMenuCell];
        
        [cell setBackgroundColor:[UIColor myTransparent]];
        [cell.contentView setBackgroundColor:[UIColor myTransparent]];
        
        NSString *menuItem = _searchResult[indexPath.row];
        
        UILabel *title = (UILabel*)[cell.contentView viewWithTag:1];
        title.text = menuItem;

        return cell;
         */
        return nil;
        
    } else {
        UCMenuCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[UCMenuCell nibName] forIndexPath:indexPath];
        cell.menuItem = self.menuItems[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [UCMenuHeaderCell height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isSearching]){
        return 60;
    }
    else {
        return [UCMenuCell height];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_currentViewIndex != indexPath.row) {
        UCNavigationController *controller = [self controllerForIndex:indexPath.row];
        [self.sideMenuViewController setContentViewController:controller animated:YES];
    }
    _currentViewIndex = indexPath.row;
    
    [self.sideMenuViewController hideMenuViewController];
}


#pragma mark - Searching

- (BOOL)isSearching {
    return _isUserSearching;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    _isUserSearching = YES;
    searchBar.showsCancelButton = YES;
    [self.tableView reloadData];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    _isUserSearching = YES;
    searchBar.showsCancelButton = YES;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    //_isUserSearching = NO;
    [self.view endEditing:YES];
    [self.tableView reloadData];
    searchBar.showsCancelButton = (searchBar.text.length != 0);
    _isUserSearching = (searchBar.text.length != 0);
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    _isUserSearching = NO;
    [self.view endEditing:YES];
    [self.tableView reloadData];
}

-(void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar {
    //_isUserSearching = NO;
    [self.view endEditing:YES];
    [self.tableView reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
    [self.tableView reloadData];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    _searchResult = [NSMutableArray arrayWithObject:@"Result1"];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                                          objectAtIndex:[self.searchDisplayController.searchBar
                                                                         selectedScopeButtonIndex]]];
    return YES;
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
