//
//  UINavigationBar+Clear.m
//  AlmappUC
//
//  Created by Patricio López on 05-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UINavigationBar+Clear.h"

@implementation UINavigationBar (Clear)

- (void)setClear {
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:[UIImage new]];
    [self setTranslucent:YES];
    [self setBackgroundColor:[UIColor clearColor]];
}

@end

@implementation UINavigationController (Clear)

- (void)setClearNavigationBar {
    self.view.backgroundColor = [UIColor clearColor];
    [self.navigationBar setClear];
}

@end
