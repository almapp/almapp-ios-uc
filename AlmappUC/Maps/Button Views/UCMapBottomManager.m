//
//  UCMapButtonDelegate.m
//  AlmappUC
//
//  Created by Patricio López on 06-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCMapBottomManager.h"

@implementation UCMapBottomManager

- (id)initWithArea:(ALMArea *)area delegate:(id<UCMapBottomDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.area = area;
    }
    return self;
}

- (void)start {
    for (NSString* nibName in @[[UCMapTableViewCell nibNameBuildingCell],
                                [UCMapTableViewCell nibNameFacultyCell],
                                [UCPlaceCell nibName]]) {
        
        UINib *nib = [UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]];
        [self.tableView registerNib:nib forCellReuseIdentifier:nibName];
    }
}

- (UITableView *)tableView {
    return (_delegate) ? [_delegate tableView] : nil;
}

- (UCSegmentedIndex)selectedSegment {
    return [_delegate selectedSegment];
}

- (NSObject<RLMCollection> *)selectedSocialCollection {
    switch (self.selectedSegment) {
        case UCSegmentedIndexLikes:
            return self.likes;
        case UCSegmentedIndexComments:
            return self.comments;
        case UCSegmentedIndexEvents:
            return self.events;
        default:
            return nil;
    }
}

- (void)showProgress {
    if (_delegate) {
        [_delegate.navigationController showProgress];
    }
}

- (void)dismissProgress {
    if (_delegate) {
        [_delegate.navigationController dismissProgress];
    }
}

- (void)showError:(NSError *)error {
    if (_delegate) {
        [_delegate.navigationController showError:error];
    }
}

- (void)reloadData {
    if (_delegate) {
        [self.tableView reloadData];
    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self selectedSocialCollection].count;
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //UCEventCell *cell = [tableView dequeueReusableCellWithIdentifier:[UCEventCell nibName] forIndexPath:indexPath];
        //[cell setEvent:_events[indexPath.row]];
        //return cell;
        return nil;
    }
    else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (self.selectedSegment) {
            case UCSegmentedIndexLikes:
                return 0.0f;
            case UCSegmentedIndexComments:
                return 0.0f;
            case UCSegmentedIndexEvents:
                return 0.0f;
        }
    }
    return 44.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}


- (void)showLikes {
    
}

- (void)showComments {
    
}

- (void)showEvents {
    
}

@end
