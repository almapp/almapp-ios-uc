//
//  UCCampusManager.m
//  AlmappUC
//
//  Created by Patricio López on 06-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCCampusManager.h"

@implementation UCCampusManager

- (void)start {
    [super start];
    
    [self fetch];
}


- (void)fetch {
    ALMCampus *campus = (ALMCampus *)self.area;
    _faculties = [campus.faculties sortedResultsUsingProperty:kRShortName ascending:YES];
    _buildings = [campus.buildings sortedResultsUsingProperty:kRShortName ascending:YES];
    //[self.tableView reloadSectionDU:1 withRowAnimation:UITableViewRowAnimationAutomatic];
    //[self.tableView reloadSectionDU:2 withRowAnimation:UITableViewRowAnimationAutomatic];
    [self reloadData];
    
    //NSRange range = NSMakeRange(0, [self numberOfSectionsInTableView:self.tableView]);
    //NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
    //[self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)showLikes {
    [self.tableView reloadSectionDU:0 withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)showComments {
    
}

- (void)showEvents {
    
}


- (NSObject<RLMCollection> *)collectionForSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [super selectedSocialCollection];
        case 1:
            return _faculties;
        case 2:
            return _buildings;
        default:
            return nil;
    }
}

- (ALMArea *)areaAtIndex:(NSIndexPath *)indexPath {
    return [[self collectionForSection:indexPath.section] objectAtIndex:indexPath.row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [super tableView:tableView numberOfRowsInSection:section];
            break;
            
        default:
            return [self collectionForSection:section].count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return [super tableView:tableView cellForRowAtIndexPath:indexPath];
        case 1: {
            UCMapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UCMapTableViewCell nibNameFacultyCell] forIndexPath:indexPath];
            [cell setArea:[[self collectionForSection:indexPath.section] objectAtIndex:indexPath.row]];
            return cell;
        }
        case 2: {
            UCMapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UCMapTableViewCell nibNameBuildingCell] forIndexPath:indexPath];
            [cell setArea:[[self collectionForSection:indexPath.section] objectAtIndex:indexPath.row]];
            return cell;
        }
            
        default:
            return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
            [super tableView:tableView didSelectRowAtIndexPath:indexPath];
            break;
            
        case 1: {
            ALMArea *area = [self areaAtIndex:indexPath];
            [self.delegate didSelect:area];
            break;
        }
            
        default:
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [super tableView:tableView titleForHeaderInSection:section];
        case 1:
            return ([self collectionForSection:section].count == 0) ? nil : @"Facultades";
        case 2:
            return ([self collectionForSection:section].count == 0) ? nil : @"Edificios";
        default:
            return @"";
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];
            
        case 1:
            return [UCMapTableViewCell heightFacultyCell];
            
        case 2:
            return [UCMapTableViewCell heightBuildingCell];
            
        default:
            return 0.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return ([self collectionForSection:section].count == 0) ? 0.0f : UITableViewAutomaticDimension;
}

@end
