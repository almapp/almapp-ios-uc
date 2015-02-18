//
//  UCMapHeaderViewController.h
//  AlmappUC
//
//  Created by Patricio López on 17-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <AlmappCore/AlmappCore.h>
#import "ALMPlace+Defaults.h"

@interface UCMapHeaderViewController : UIViewController <GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

+ (instancetype)mapHeaderWithOwner:(id)owner;

- (void)showArea:(ALMPlace*)place withMarker:(BOOL)withMarker withFocus:(BOOL)withFocus;
- (void)showAreas:(NSArray*)places withMarkers:(BOOL)withMarkers;

- (void)showHybridMap;
- (void)showNormalMap;

@end
