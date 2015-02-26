//
//  UCLoginEmailViewController.m
//  AlmappUC
//
//  Created by Patricio López on 25-02-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCLoginEmailViewController.h"

#import <gtm-oauth2/GTMOAuth2Authentication.h>
#import <gtm-oauth2/GTMOAuth2ViewControllerTouch.h>
#import <gtm-oauth2/GTMOAuth2SignIn.h>

#import "UCAppDelegate.h"

@interface UCLoginEmailViewController ()

@property (weak, nonatomic) IBOutlet UIButton *activateButton;

- (IBAction)activateButtonClick:(id)sender;

@end

@implementation UCLoginEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    // Do any additional setup after loading the view.
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

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error {
    if (error) {
        NSLog(@"%@", error);
    } else {
        NSLog(@"%@", auth);
    }
}

- (IBAction)activateButtonClick:(id)sender {
    [UCAppDelegate promiseLoggedToWebMail].then( ^{
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
        
        viewController.signIn.shouldFetchGoogleUserProfile = YES;
        viewController.signIn.additionalAuthorizationParameters=params;
        
        [[self navigationController] pushViewController:viewController animated:YES];
    });

    
    
    /*
    UCGmailAuth *auth = [[UCGmailAuth alloc] init];
    [auth OAuthViewController:self].then( ^(UIViewController *viewController) {
        id a = [[UINavigationController alloc] initWithRootViewController:viewController];
        [self presentViewController:a animated:YES completion:nil];
    }).catch( ^(NSError *error) {
        NSLog(@"%@", error);
    });
     */
}

@end
