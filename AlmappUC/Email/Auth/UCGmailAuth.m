//
//  UCGmailAuth.m
//  AlmappUC
//
//  Created by Patricio López on 25-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <PromiseKit/PromiseKit.h>
#import <gtm-oauth2/GTMOAuth2Authentication.h>
#import <gtm-oauth2/GTMOAuth2ViewControllerTouch.h>
#import <gtm-oauth2/GTMOAuth2SignIn.h>

#import "UCGmailAuth.h"
#import "UCAppDelegate.h"

@implementation UCGmailAuth

- (PMKPromise *)OAuthViewController {
    return [UCAppDelegate promiseLoggedToWebMail].then( ^{
        // We'll make up an arbitrary redirectURI.  The controller will watch for
        // the server to redirect the web view to this URI, but this URI will not be
        // loaded, so it need not be for any actual web page.
        
        UCApiKey *key = [UCApiKey OAuthApiKeyFor:kGoogleApiKey];
        
        NSString *scope = [GTMOAuth2Authentication scopeWithStrings:
                           //@"https://www.googleapis.com/auth/userinfo.email",
                           //@"https://www.googleapis.com/auth/userinfo.profile",
                           @"https://www.googleapis.com/auth/gmail.modify",
                           @"https://www.googleapis.com/auth/gmail.compose", nil];
        
        
        GTMOAuth2ViewControllerTouch *viewController;
        viewController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:scope
                                                                    clientID:key.uid
                                                                clientSecret:key.secret
                                                            keychainItemName:@"AlmappKey"
                                                                    delegate:self
                                                            finishedSelector:@selector(viewController:finishedWithAuth:error:)];
        
        NSDictionary *params = @{@"access_type" : @"offline"}; //, @"approval_prompt" : @"force"};
        
        // viewController.signIn.shouldFetchGoogleUserProfile = YES;
        viewController.signIn.additionalAuthorizationParameters=params;
        
        return viewController;
    });
}

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error {
    if (error) {
        NSLog(@"%@", error);
    } else {
        NSLog(@"%@", auth);
    }
}


@end
