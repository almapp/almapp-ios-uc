//
//  UCGoogleOAuthViewController.m
//  AlmappUC
//
//  Created by Patricio López on 26-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCGoogleOAuthViewController.h"

#import <PromiseKit/PromiseKit.h>
#import <gtm-oauth2/GTMOAuth2Authentication.h>
#import <gtm-oauth2/GTMOAuth2ViewControllerTouch.h>
#import <gtm-oauth2/GTMOAuth2SignIn.h>

static NSString * const kGoogleAuthKeychainIdentifier = @"ALMAPP_GMAIL_API_KEYCHAIN";

@interface UCGoogleOAuthViewController ()

@end

@implementation UCGoogleOAuthViewController

+ (instancetype)controllerWitApiKey:(UCApiKey *)apiKey {
    NSString *scope = [GTMOAuth2Authentication scopeWithStrings:
                       //@"https://www.googleapis.com/auth/userinfo.email",
                       //@"https://www.googleapis.com/auth/userinfo.profile",
                       @"https://www.googleapis.com/auth/gmail.modify",
                       @"https://www.googleapis.com/auth/gmail.compose", nil];
    
    UCGoogleOAuthViewController *viewController =
    [UCGoogleOAuthViewController controllerWithScope:scope
                                            clientID:apiKey.uid
                                        clientSecret:apiKey.secret
                                    keychainItemName:kGoogleAuthKeychainIdentifier
                                   completionHandler:^(GTMOAuth2ViewControllerTouch *viewController, GTMOAuth2Authentication *auth, NSError *error) {
                                       
                                   }];
    
    NSDictionary *params = @{@"access_type" : @"offline"}; //, @"approval_prompt" : @"force"};
    
    viewController.signIn.shouldFetchGoogleUserProfile = YES;
    viewController.signIn.additionalAuthorizationParameters=params;
    
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Autorización";
    self.initialHTMLString  = nil;
    self.showsInitialActivityIndicator = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpNavigation {
    [super setUpNavigation];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancelar"
                                                                              style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(cancelButtonClick:)];
}

- (void)cancelButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)swapInCookies {
    
}

- (void)swapOutCookies {
    
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
