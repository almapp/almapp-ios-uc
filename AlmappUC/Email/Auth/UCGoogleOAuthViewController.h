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

+ (instancetype)controllerWitApiKey:(UCApiKey *)apiKey
                              block:(void(^)(GTMOAuth2ViewControllerTouch *viewController,
                                             GTMOAuth2Authentication *auth,
                                             NSError *error))block;

@end
