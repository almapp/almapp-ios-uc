//
//  UCMapsFirstTableViewController.m
//  AlmappUC
//
//  Created by Patricio López on 31-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import <AlmappCore/AlmappCore.h>

#import "UCMapsFirstTableViewController.h"
#import "UCMapMainViewController.h"
#import "UCCampusCell.h"

#import "UCConstants.h"
#import "ALMConstants.h"

#import "UCAppDelegate.h"
#import "UITableView+Nib.h"

static NSString *const kCampusSegueName = @"CampusSegue";

@interface UCMapsFirstTableViewController ()

@property (strong, nonatomic) RLMResults* campuses;
@property (strong, nonatomic) RLMResults* recentAreas;

@end



@implementation UCMapsFirstTableViewController

- (void)loadRecentPlaces {
    _recentAreas = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClassesNib:@[[UCCampusCell nibName]]];

    self.clearsSelectionOnViewWillAppear = YES;
    
    self.campuses = [[ALMCampus allObjects] sortedResultsUsingProperty:kRResourceID ascending:YES];
    if ([NSUserDefaults shouldUpdateAreas]) {
        //[self fetch];
    }
    else {
        [self.tableView reloadData];
    }
}

- (void)fetch {
    [self.navigationController showProgress];
    
    ALMMapController *controller = [UCAppDelegate controllerMap];
    [controller fetchMaps].then(^(NSArray *campuses) {
        self.campuses = [ALMCampus allObjects];
        
        [NSUserDefaults justUpdateAreas];
        [self.navigationController dismissProgress];
        [self.tableView reloadData];
        
        
    }).catch( ^(NSError *error) {
        [self.navigationController showError:error];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
        case 1:
            return _campuses.count;
        case 2:
            return (_recentAreas && _recentAreas.count != 0) ? _recentAreas.count : 1;
        default:
            return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return kDefaultCellHeight;
            
        case 1:
            return [UCCampusCell height];
            
        case 2:
            return (_recentAreas && _recentAreas.count != 0) ? 44.0f : kDefaultCellHeight; // TODO place height
            
        default:
            return 0.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:nil heightForRowAtIndexPath:indexPath]; // TODO: check if this is a good practice
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"FirstCell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Mis salas";
                    break;
                    
                default:
                    cell.textLabel.text = @"¿Dónde están mis amigos?";
                    break;
            }
            return cell;
        }
        case 1: {
            UCCampusCell* cell = [tableView dequeueReusableCellWithIdentifier:[UCCampusCell nibName]];
            ALMArea* campus = [_campuses objectAtIndex:indexPath.row];
            [cell setArea:campus];
            return cell;
        }
        case 2: {
            if(_recentAreas != nil && _recentAreas.count != 0) {
                return nil;
            }
            else {
                UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"FirstCell"];
                cell.textLabel.text = @"No has visto lugares para mostrar aquí";
                cell.textLabel.adjustsFontSizeToFitWidth = YES;
                cell.textLabel.minimumScaleFactor = 0;
                return cell;
            }
        }
        default: {
            return nil;
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return (_recentAreas != nil && _recentAreas.count != 0);
    }
    else {
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 1:
            [self performSegueWithIdentifier:kCampusSegueName sender:self];
            break;
            
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Mostrar en el mapa";
        case 1:
            return @"Campus";
        case 2:
            return @"Lugares recientes";
        default:
            return nil;
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return nil;
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:kCampusSegueName]) {
        UCMapMainViewController *controller = [segue destinationViewController];
        NSUInteger selectedIndex = [self.tableView indexPathForSelectedRow].row;
        controller.campus = [_campuses objectAtIndex:selectedIndex];
    }
    
    // CampusSegue
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
