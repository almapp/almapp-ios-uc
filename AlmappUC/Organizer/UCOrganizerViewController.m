//
//  UCOrganizerViewController.m
//  AlmappUC
//
//  Created by Patricio López on 17-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCOrganizerViewController.h"
#import "UCScheduleConstants.h"
#import "UCAppDelegate.h"
#import "UCScheduleNotifications.h"

#import <AlmappCore/AlmappCore.h>

static UIViewAnimationOptions kTransitionAnimation = UIViewAnimationOptionTransitionCrossDissolve;

@interface UCOrganizerViewController ()

@property (strong, nonatomic) ALMScheduleController *schedule;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) UIViewController *currentViewController;

- (IBAction)segmentedControlValueChange:(UISegmentedControl *)sender;

@end

@implementation UCOrganizerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    _segmentedControl.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UCScheduleConstants backgroundColor];
    
    [self segmentedControlValueChange:self.segmentedControl];
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

- (IBAction)segmentedControlValueChange:(UISegmentedControl *)sender {
    UIViewController *vc = [self viewControllerForSegmentIndex:sender.selectedSegmentIndex];
    [self addChildViewController:vc];
    
    // if it's the first time we load a child VC
    if (!self.currentViewController) {
        [self.contentView addSubview:vc.view];
        vc.view.frame = self.contentView.bounds;
        [vc didMoveToParentViewController:self];
        self.currentViewController = vc;
        return;
    }
    
    // if we're switching child VCs
    [self transitionFromViewController:self.currentViewController toViewController:vc duration:0.5 options:kTransitionAnimation animations:^{
        [self.currentViewController.view removeFromSuperview];
        vc.view.frame = self.contentView.bounds;
        [self.contentView addSubview:vc.view];
    } completion:^(BOOL finished) {
        [vc didMoveToParentViewController:self];
        [self.currentViewController removeFromParentViewController];
        self.currentViewController = vc;
    }];
    //self.navigationItem.title = vc.title;
}

- (UIViewController *)viewControllerForSegmentIndex:(NSInteger)index {
    UIViewController *viewController;
    switch (index) {
        case 0:
            viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UCScheduleViewController"];
            break;
        case 1:
            viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UCCoursesTableViewController"];
            break;
        case 2:
            viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UCCoursesTableViewController"];
            break;
        case 3:
            viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UCTeachersTableViewController"];
            break;
    }
    return viewController;
}

@end
