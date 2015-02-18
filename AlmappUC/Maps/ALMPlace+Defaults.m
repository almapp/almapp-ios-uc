//
//  ALMPlace+Defaults.m
//  AlmappUC
//
//  Created by Patricio López on 07-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "ALMPlace+Defaults.h"

static CGFloat minValue = 1.0f;
static CGFloat defaultZoom = 18.0f;

@implementation ALMPlace (Defaults)

- (CGFloat)preferedZoom {
    return (self.zoom > minValue) ? self.zoom : defaultZoom;
}

- (CGFloat)preferedAngle {
    return self.angle;
}

- (CGFloat)preferedTilt {
    return self.tilt;
}

@end
