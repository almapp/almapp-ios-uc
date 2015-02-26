//
//  UCTeachersTableViewController.m
//  AlmappUC
//
//  Created by Patricio López on 07-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCTeachersTableViewController.h"
#import "UCScheduleConstants.h"
#import "UCAppDelegate.h"
#import "UCStyle.h"

#import <AlmappCore/ALMResourceConstants.h>

@interface UCTeachersTableViewController ()

@end

@implementation UCTeachersTableViewController

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
    
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor accentColor]];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    
    //self.tableView.backgroundView = nil;
    //self.tableView.backgroundColor = [UCScheduleConstants backgroundColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    for (NSString *nibName in @[[UCTeacherCell nibName]]) {
        UINib *nib = [UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]];
        [self.tableView registerNib:nib forCellReuseIdentifier:nibName];
    }
    
    
    [self load];
}

- (void)load {
    self.currentTeachers = (RLMResults *)[UCAppDelegate controllerSchedule].teachers;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentTeachers.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UCTeacherCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[UCTeacherCell nibName] forIndexPath:indexPath];
    cell.isEven = (indexPath.row % 2 == 0);
    cell.teacher = self.currentTeachers[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UCTeacherCell height];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UCTeacherCell height];
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
