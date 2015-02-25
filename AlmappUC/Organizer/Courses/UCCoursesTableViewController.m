//
//  UCCoursesTableViewController.m
//  AlmappUC
//
//  Created by Patricio López on 06-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCCoursesTableViewController.h"
#import "UCScheduleConstants.h"
#import "UCAppDelegate.h"
#import "UIColor+Almapp.h"

#import <AlmappCore/ALMResourceConstants.h>

@interface UCCoursesTableViewController ()
@property (weak, nonatomic) ALMController *controller;
@end

@implementation UCCoursesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    self.view.backgroundColor = [UCScheduleConstants backgroundColor];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    backgroundView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = backgroundView;
    
    self.navigationController.navigationBar.translucent = NO;
    self.searchDisplayController.searchBar.translucent = NO;
    self.searchDisplayController.searchBar.backgroundColor = [UCScheduleConstants backgroundColor];
    
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor navbarAccent]];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    
    //self.tableView.backgroundView = nil;
    //self.tableView.backgroundColor = [UCScheduleConstants backgroundColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    for (NSString *nibName in @[[UCCourseCell nibName], [UCAcademicUnityCell nibName]]) {
        UINib *nib = [UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]];
        [self.tableView registerNib:nib forCellReuseIdentifier:nibName];
    }
    
    self.controller = [UCAppDelegate controller];
    self.controller.realm = [RLMRealm inMemoryRealmWithIdentifier:@"Courses"];
    
    [self fetch];
}

- (void)fetch {
    self.currentCourses = (RLMResults *)[[UCAppDelegate controllerSchedule].courses sortedResultsUsingProperty:kRName ascending:YES];
    self.currentCourses = [self.currentCourses sortedResultsUsingProperty:kRName ascending:YES];

    [self.tableView reloadData];
    
    [self.controller GETResources:[ALMAcademicUnity class] parameters:nil].then( ^(id response, NSURLSessionDataTask *task) {
        self.academicUnities = [[ALMAcademicUnity allObjects] sortedResultsUsingProperty:kRShortName ascending:YES];
        [self.tableView reloadData];
        
    }).catch(^(NSError *error) {
        [self.navigationController showError:error];
    });
}


- (IBAction) dismiss:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSObject<RLMCollection> *)collectionAtSection:(NSInteger)section {
    switch (section) {
        case 0:
            return _currentCourses;
        case 1:
            return _academicUnities;
        default:
            return nil;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }
    else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return _searchResults.count;
    }
    else {
        return [self collectionAtSection:section].count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        UCCourseCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[UCCourseCell nibName] ];
        ALMCourse *course = [_searchResults objectAtIndex:indexPath.row];
        cell.course = course;
        return cell;
    }
    else if (indexPath.section == 0){
        UCCourseCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[UCCourseCell nibName] forIndexPath:indexPath];
        ALMCourse *course = [[self collectionAtSection:indexPath.section] objectAtIndex:indexPath.row];
        cell.course = course;
        return cell;
    }
    else {
        UCAcademicUnityCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[UCAcademicUnityCell nibName] forIndexPath:indexPath];
        ALMAcademicUnity *unity = [[self collectionAtSection:indexPath.section] objectAtIndex:indexPath.row];
        cell.area = unity;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [UCCourseCell height];
    }
    else if (indexPath.section == 0){
        return [UCCourseCell height];
    }
    else {
        return [UCAcademicUnityCell height];
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UCCourseCell height];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return @"Cursos encontrados";
    }
    
    switch (section) {
        case 0:
            return @"Mis Cursos";
        case 1:
            return @"Unidades académicas";
        default:
            return @"HEADER";
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchDisplayController.searchResultsTableView.backgroundColor = [UCScheduleConstants backgroundColor];
}



- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    if (searchString.length <= 1) {
        return NO;
    }
    
    [self filterContentForSearchText:searchString scope:nil];
    return NO;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    //NSString *query = [NSString stringWithFormat:@"%@ CONTAINS[c] '%@' OR %@ CONTAINS[c] '%@'", kRName, searchText, kRInitials, searchText];
    //_searchResults = [ALMCourse objectsWhere:query];
    
    [self.controller SEARCH:searchText ofType:[ALMCourse class]].then( ^(id results, NSURLSessionDataTask *taks) {
        self.searchResults = results;
        [self.searchDisplayController.searchResultsTableView reloadData];
    });
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
