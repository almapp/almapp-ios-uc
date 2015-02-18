//
//  UCFacultyManager.m
//  AlmappUC
//
//  Created by Patricio López on 07-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCFacultyManager.h"

@implementation UCFacultyManager

- (void)start {
    [super start];
    
    [self fetch];
}


- (void)fetch {
    _classrooms = [self.area placesWithCategory:ALMCategoryTypeClassroom];
    _otherPlaces = [self.area placesWithCategory:ALMCategoryTypeOther];
    NSRange range = NSMakeRange(0, [self numberOfSectionsInTableView:self.tableView]);
    NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
    [self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
    if (_classrooms.count == 0) {
        [self showProgress];
    }
    
    ALMController *controller = [UCAppDelegate controller];
    [controller GETResources:[ALMPlace class] on:self.area parameters:nil].then( ^(id result, NSURLSessionDataTask *task) {
        [self dismissProgress];
        
        self.classrooms = [self.area placesWithCategory:ALMCategoryTypeClassroom];
        self.otherPlaces = [self.area placesWithCategory:ALMCategoryTypeOther];
        
        NSRange range = NSMakeRange(0, [self numberOfSectionsInTableView:self.tableView]);
        NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.tableView reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }).catch( ^(NSError *error) {
       [super showError:error];
    });
}

- (NSObject<RLMCollection> *)collectionForSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [super selectedSocialCollection];
        case 1:
            return _classrooms;
        case 2:
            return _otherPlaces;
        default:
            return nil;
    }
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
            
        case 1: case 2:{
            UCPlaceCell *cell = [tableView dequeueReusableCellWithIdentifier:[UCPlaceCell nibName] forIndexPath:indexPath];
            [cell setPlace:[[self collectionForSection:indexPath.section] objectAtIndex:indexPath.row]];
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
            
        case 1: case 2:{
            ALMPlace *place = [[self collectionForSection:indexPath.section] objectAtIndex:indexPath.row];
            [self.delegate scrollAndShow:place mark:YES zoom:YES];
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
            return ([self collectionForSection:section].count == 0) ? nil : @"Salas";
        case 2:
            return ([self collectionForSection:section].count == 0) ? nil : @"Otros lugares";
        default:
            return @"";
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];
            
        case 1: case 2:
            return [UCPlaceCell height];
            
        default:
            return 0.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return ([self collectionForSection:section].count == 0) ? 0.0f : UITableViewAutomaticDimension;
}

@end
