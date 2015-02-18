//
//  UCMapHeaderViewController.m
//  AlmappUC
//
//  Created by Patricio López on 17-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <objc/runtime.h>

#import "UCMapHeaderViewController.h"
#import "UCConstants.h"

static NSString *const kMapHeaderNibName = @"UCMapHeader";
static CGFloat const kMapVerticalOffset = -10.0f;

@interface ALMPlace (Coords)

@property (strong, nonatomic) GMSMarker* marker;

@end

@implementation ALMPlace (Coords)

+ (NSArray *)ignoredProperties {
    return @[@"marker"];
}

- (GMSMarker *)marker {
    GMSMarker *marker = objc_getAssociatedObject(self, @selector(marker));
    if (!marker) {
        marker = [GMSMarker markerWithPosition:self.coordinates];
        marker.title = self.name;
        marker.snippet = self.information;
        marker.appearAnimation = kGMSMarkerAnimationPop;
        
        [self setMarker:marker];
    }
    return marker;
}

- (void)setMarker:(GMSMarker *)marker {
    objc_setAssociatedObject(self, @selector(marker), marker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)removeMarker {
    self.marker.map = nil;
}

- (CLLocationCoordinate2D)coordinates {
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

- (GMSCameraPosition *)cameraPosition {
    return [GMSCameraPosition cameraWithTarget:[self coordinates] zoom:self.preferedZoom bearing:self.preferedTilt viewingAngle:self.preferedAngle];
}


@end

@interface UCMapHeaderViewController ()

@end

@implementation UCMapHeaderViewController

+ (instancetype)mapHeaderWithOwner:(id)owner {
    return [[NSBundle mainBundle] loadNibNamed:kMapHeaderNibName owner:owner options:nil].firstObject;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:kSantiagoLatitude
                                                            longitude:kSantiagoLongitude
                                                                 zoom:kSantiagoZoom];
    
    CLLocationManager* locationManager;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100m
    
    if(IS_OS_8_OR_LATER) {
        [locationManager requestAlwaysAuthorization];
    }
    
    [locationManager startUpdatingLocation];
    
    
    _mapView.camera = camera;
    _mapView.myLocationEnabled = YES;
    _mapView.buildingsEnabled = YES;
    _mapView.indoorEnabled = YES;
    _mapView.delegate = self;
    [_mapView.settings setAllGesturesEnabled:YES];
    _mapView.settings.compassButton = YES;
    _mapView.settings.myLocationButton = YES;
    _mapView.settings.indoorPicker = YES;
    [self showHybridMap];
    //_mapView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
}

/*
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    
    CLLocationCoordinate2D coords = marker.position;
    coords.longitude += kMapVerticalOffset;
    
    //[self.mapView animateWithCameraUpdate:[GMSCameraUpdate scrollByX:0 Y:kMapVerticalOffset]];
    
    [self.mapView animateToCameraPosition: [GMSCameraPosition cameraWithLatitude:coords.latitude longitude:coords.longitude zoom:18.0f]];
    mapView.selectedMarker = marker;
    
    return NO;
}
 */

- (void)onFullScreen {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAreas:(NSArray *)places withMarkers:(BOOL)withMarkers {
    [self showArea:places.firstObject withMarker:withMarkers withFocus:YES];
    for(int i = 1; i < places.count; i++) {
        [self showArea:places[i] withMarker:withMarkers withFocus:NO];
    }
}

- (void)showArea:(ALMPlace *)place withMarker:(BOOL)withMarker withFocus:(BOOL)withFocus {
    if(place != nil && withMarker) {
        // TODO
    }
    if(place != nil && withFocus) {
        [CATransaction begin];
        if (withMarker) {
            __weak __typeof(self) weakSelf = self;
            [CATransaction setCompletionBlock:^{
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                if (strongSelf) {
                    [strongSelf.mapView animateWithCameraUpdate:[GMSCameraUpdate scrollByX:0 Y:kMapVerticalOffset]];
                    place.marker.map = strongSelf.mapView;
                    strongSelf.mapView.selectedMarker = place.marker;
                }
            }];
        }
        [CATransaction setValue:[NSNumber numberWithFloat: 1.0f] forKey:kCATransactionAnimationDuration];
        // change the camera, set the zoom, whatever.  Just make sure to call the animate* method.
        [self.mapView animateToCameraPosition:place.cameraPosition];
        [CATransaction commit];
        
        
        //[_mapView animateToCameraPosition:[self cameraFor:place]];
    }
}

- (void)showHybridMap {
    _mapView.mapType = kGMSTypeHybrid;
}

- (void)showNormalMap {
    _mapView.mapType = kGMSTypeNormal;
}

@end
