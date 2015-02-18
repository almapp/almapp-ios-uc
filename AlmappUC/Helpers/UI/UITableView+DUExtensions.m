//
//  UITableView+DUExtensions.m
//  AlmappUC
//
//  Created by Patricio López on 07-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UITableView+DUExtensions.h"

@implementation UITableView (DUExtensions)

- (void) reloadSectionDU:(NSInteger)section withRowAnimation:(UITableViewRowAnimation)rowAnimation {
    NSRange range = NSMakeRange(section, 1);
    NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
    [self reloadSections:sectionToReload withRowAnimation:rowAnimation];
}

@end