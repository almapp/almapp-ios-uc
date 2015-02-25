//
//  UCLoginMapViewController.m
//  AlmappUC
//
//  Created by Patricio López on 18-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

#import "UCConstants.h"
#import "UCLoginMapViewController.h"
#import "UCAppDelegate.h"

@interface UCLoginMapViewController () <CLLocationManagerDelegate>

@property (assign, nonatomic) BOOL didFetchMaps;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UIButton *permissionButton;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)permisionButtonTouch:(id)sender;

@end

@implementation UCLoginMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.activityIndicator startAnimating];
    self.loadingLabel.hidden = NO;
    
    if (![self permissionEnabled]) {
        [self askPermision];
    }
    else {
        self.permissionButton.hidden = YES;
    }
    
    [UCAppDelegate controllerMap].fetchMaps.finally( ^{
        self.didFetchMaps = YES;
        [self.activityIndicator stopAnimating];
        self.loadingLabel.hidden = YES;
        [self tryToPass];
    });
    
    // Do any additional setup after loading the view.
}

- (void)tryToPass {
    
    if ([self permissionEnabled] && self.didFetchMaps) {
        NSLog(@"NEXT!");
        [UCAppDelegate showInitialView];
    }
}

- (BOOL)permissionEnabled {
    return [CLLocationManager locationServicesEnabled];
}

- (void)askPermision {
    self.permissionButton.hidden = NO;
    
    if(IS_OS_8_OR_LATER) {
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)onSuccessPermission {
    [self.locationManager stopUpdatingLocation];
    self.permissionButton.hidden = YES;
    [self tryToPass];
}

- (void)onFailPermission {
    
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    }
    return _locationManager;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorized:
            [self onSuccessPermission];
            break;
            
        default:
            [self onFailPermission];
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    //if (error.code ==  kCLErrorDenied) {
        [self onFailPermission];
    //}
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

- (IBAction)permisionButtonTouch:(id)sender {
}
@end
