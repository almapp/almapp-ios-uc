//
//  UITableView+Nib.m
//  AlmappUC
//
//  Created by Patricio López on 26-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UITableView+Nib.h"

@implementation UITableView (Nib)

- (void)registerClassesNib:(id)input {
    if ([input isKindOfClass:[NSArray class]]) {
        for (NSString* nibName in (NSArray *)input) {
            UINib *nib = [UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]];
            [self registerNib:nib forCellReuseIdentifier:nibName];
        }
    }
    else if ([input isKindOfClass:[NSString class]]) {
        UINib *nib = [UINib nibWithNibName:input bundle:[NSBundle mainBundle]];
        [self registerNib:nib forCellReuseIdentifier:input];
    }
}

@end
