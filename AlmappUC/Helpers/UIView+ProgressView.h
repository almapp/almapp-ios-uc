//
//  UIView+ProgressView.h
//  AlmappUC
//
//  Created by Patricio López on 01-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MRProgress.h"

@interface UINavigationController (ProgressView)

- (MRProgressOverlayView *)showProgress;

- (MRProgressOverlayView *)showProgressWithTitle:(NSString *)title;

- (void)dismissProgress;

- (void)showError;

- (void)showError:(NSError *)error;

@end

@interface UITableViewController (ProgressView)

- (MRProgressOverlayView *)showProgress;

- (MRProgressOverlayView *)showProgressWithTitle:(NSString *)title;

- (void)dismissProgress;

- (void)showError;

- (void)showError:(NSError *)error;

@end


@interface UIView (ProgressView)

- (MRProgressOverlayView *)showProgress;

- (MRProgressOverlayView *)showProgressWithTitle:(NSString *)title;

- (void)dismissProgress;

- (void)showError;

- (void)showError:(NSError *)error;

@end

@interface UIScrollView (ProgressView)

- (MRProgressOverlayView *)showProgress;

- (MRProgressOverlayView *)showProgressWithTitle:(NSString *)title;

- (void)dismissProgress;

- (void)showError;

- (void)showError:(NSError *)error;

@end