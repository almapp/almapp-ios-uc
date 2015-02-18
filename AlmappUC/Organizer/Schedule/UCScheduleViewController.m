//
//  UCScheduleViewController.m
//  AlmappUC
//
//  Created by Patricio López on 17-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <AlmappCore/AlmappCore.h>

#import "UCMapHeaderViewController.h"
#import "UCScheduleViewController.h"
#import "UCScheduleTableViewController.h"
#import "UCConstants.h"
#import "UCAppDelegate.h"
#import "UIView+ProgressView.h"
#import "UCScheduleNotifications.h"
#import "UCScheduleConstants.h"

#import "DIDatepicker.h"
#import <DateTools/DateTools.h>

static NSString *const kMapHeaderIdentifier = @"mapHeaderView";
static NSString *const kScheduleTableViewIdentifier = @"scheduleTable";
static float const kMapHeaderHeight = 180.0f;

@interface UCScheduleViewController ()

@property (strong, nonatomic) UCMapHeaderViewController *mapViewController;
@property (strong, nonatomic) UCScheduleTableViewController *tableViewController;
@property (strong, nonatomic) RLMResults *sections;

@end

@implementation UCScheduleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _mapViewController = [UCMapHeaderViewController mapHeaderWithOwner:self];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableViewController = [self.storyboard instantiateViewControllerWithIdentifier:kScheduleTableViewIdentifier];
    
    self.view.backgroundColor = [UCScheduleConstants backgroundColor];
    
    [self setupWithTopViewController:_mapViewController andTopHeight:kMapHeaderHeight andBottomViewController:_tableViewController];
    
    self.delegate = self;
    
    self.maxHeight = self.view.frame.size.height - 130.0f;
     self.automaticallyAdjustsScrollViewInsets = NO;
    
    //CGFloat y = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;

}


- (IBAction) dismiss:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - QMBParallaxScrollViewControllerDelegate

- (void)parallaxScrollViewController:(QMBParallaxScrollViewController *)controller didChangeState:(QMBParallaxState)state{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
