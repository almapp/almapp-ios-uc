//
//  UCGoogleOAuthViewController.h
//  AlmappUC
//
//  Created by Patricio López on 26-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "GTMOAuth2ViewControllerTouch.h"
#import "UCApiKey.h"

@interface UCGoogleOAuthViewController : GTMOAuth2ViewControllerTouch

+ (instancetype)controllerWitApiKey:(UCApiKey *)apiKey;

@end
