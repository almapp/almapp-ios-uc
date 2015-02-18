//
//  UCMapMainViewController.m
//  AlmappUC
//
//  Created by Patricio López on 05-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCMapMainViewController.h"
#import "UCAppDelegate.h"
#import "ALMResourceConstants.h"
#import "UIViewController+BackButtonHandler.h"

@interface UCMapMainViewController ()

@end

@implementation UCMapMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setMapTitle: _campus.shortName];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupWithTopViewController:self.mapViewController andTopHeight:230 andBottomViewController:self.mapBottomViewController];
    
    self.enableSectionSupport = YES;
    self.maxHeight = self.view.frame.size.height;
    self.delegate = self;
}

- (UCMapHeaderViewController *)mapViewController {
    if (!_mapViewController) {
        _mapViewController = [UCMapHeaderViewController mapHeaderWithOwner:self];
        [_mapViewController showArea:_campus.localization withMarker:NO withFocus:YES];
    }
    return _mapViewController;
}

- (UCMapBottomViewController *)mapBottomViewController {
    if (!_mapBottomViewController) {
        _mapBottomViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UCMapBottomViewController"];
        _mapBottomViewController.mainView = self;
        _mapBottomViewController.area = _campus;
    }
    return _mapBottomViewController;
}

- (void)setMapTitle:(NSString *)title {
    self.navigationItem.title = title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)navigationShouldPopOnBackButton {
    return [self.mapBottomViewController navigationShouldPopOnBackButton];
}

- (void)parallaxScrollViewController:(QMBParallaxScrollViewController *)controller didChangeState:(QMBParallaxState)state{
    switch (state) {
        case QMBParallaxStateFullSize:
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            break;
            
        case QMBParallaxStateVisible:
            [self.mapViewController.view setHidden:NO];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            break;
            
        case QMBParallaxStateHidden:
            [self.mapViewController.view setHidden:YES];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            break;
            
        default:
            break;
    }
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
