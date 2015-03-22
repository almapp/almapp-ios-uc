//
//  UCPostLoginViewController.m
//  AlmappUC
//
//  Created by Patricio López on 12-03-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <MRProgress/MRProgress.h>

#import "UCPostLoginViewController.h"
#import "UCAppDelegate.h"

@interface UCPostLoginViewController ()

@property (assign, nonatomic) BOOL didLoadMaps;
@property (assign, nonatomic) BOOL didLoadSchedule;

@end

@implementation UCPostLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startFetching];
}

- (void)startFetching {
    MRProgressOverlayView *overlay = [MRProgressOverlayView showOverlayAddedTo:self.navigationController.view title:@"Actualizando mapas..." mode:MRProgressOverlayViewModeIndeterminate animated:YES];
    
    [UCAppDelegate controllerMap].fetchMaps.then( ^{
        overlay.titleLabelText = @"Bajando tu horario...";
        return [UCAppDelegate controllerSchedule].promiseLoaded;
    }).then( ^{
        [overlay dismissProgress];
        [UCAppDelegate showInitialView];
    });
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
