//
//  UIView+ProgressView.m
//  AlmappUC
//
//  Created by Patricio López on 01-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UIView+ProgressView.h"

@implementation UIView (ProgressView)

- (MRProgressOverlayView *)showProgress {
    return [self showProgressWithTitle:@"Cargando..."];
}

- (MRProgressOverlayView *)showProgressWithTitle:(NSString *)title {
    return [MRProgressOverlayView showOverlayAddedTo:self title:title mode:MRProgressOverlayViewModeIndeterminate animated:YES];
}

- (void)dismissProgress {
    [MRProgressOverlayView dismissOverlayForView:self animated:YES];
}

- (void)showError {
    [self showError:nil]; // TODO: error
}

- (void)showError:(NSError *)error {
    [self dismissProgress];
    
    NSString *title = (error) ? error.localizedDescription : @"Error";
    
    MRProgressOverlayView *progressView = [MRProgressOverlayView showOverlayAddedTo:self title:title mode:MRProgressOverlayViewModeCross animated:YES];
    [self performBlock:^{
        [progressView dismiss:YES];
    } afterDelay:2.0];
}

- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

@end


@implementation UIScrollView (ProgressView)

- (MRProgressOverlayView *)showProgress {
    return [self showProgressWithTitle:@"Cargando..."];
}

- (MRProgressOverlayView *)showProgressWithTitle:(NSString *)title {
    self.scrollEnabled = NO;
    return [super showProgressWithTitle:title];
}

- (void)dismissProgress {
    [super dismissProgress];
    self.scrollEnabled = YES;
}

- (void)showError {
    [self showError:nil]; // TODO: error
}

- (void)showError:(NSError *)error {
    [super showError:error];
    self.scrollEnabled = YES;
}

@end


@implementation UINavigationController (ProgressView)

- (MRProgressOverlayView *)showProgress {
    return [self showProgressWithTitle:@"Cargando..."];
}

- (MRProgressOverlayView *)showProgressWithTitle:(NSString *)title {
    return [self.view showProgressWithTitle:title];
}

- (void)dismissProgress {
    [self.view dismissProgress];
}

- (void)showError {
    [self showError:nil]; // TODO: error
}

- (void)showError:(NSError *)error {
    [self.view showError:error];
}

@end

@implementation UITableViewController (ProgressView)

- (MRProgressOverlayView *)showProgress {
    return [self showProgressWithTitle:@"Cargando..."];
}

- (MRProgressOverlayView *)showProgressWithTitle:(NSString *)title {
    return [self.tableView showProgressWithTitle:title];
}

- (void)dismissProgress {
    [self.tableView dismissProgress];
}

- (void)showError {
    [self showError:nil]; // TODO: error
}

- (void)showError:(NSError *)error {
    [self.tableView showError:error];
}

@end
