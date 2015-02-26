//
//  AppDelegate.m
//  AlmappUC
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

#import "UCAppDelegate.h"

#import "UCNavigationController.h"
#import "UCMenuViewController.h"

#import "AFNetworkActivityIndicatorManager.h"
#import "UIImage+ImageEffects.h"
#import "UIColor+Almapp.h"
#import "NSUserDefaults+Config.h"
#import "UCScheduleNotifications.h"


#pragma mark - Constants

// static short const kExpectedScheduleModulesCount = 48;
static NSString * const kStoryboardName = @"Main";
static NSString * const kLoginNavigationControllerName = @"LoginNavigationController";

int const kAPIVersion = 1;
NSString * const kAPIBaseUrl = @"http://patiwi-mcburger-pro.local:5000";
//NSString * const kAPIBaseUrl = @"https://almapp.me";
NSString * const KOrganization = @"UC";

#pragma mark - Interface

@interface UCAppDelegate ()

@property (strong, nonatomic) ALMCore* almappCore;
@property (strong, nonatomic) ALMSession *currentSession;
@property (strong, nonatomic) ALMLikesController *controllerLike;
@property (strong, nonatomic) ALMScheduleController *controllerSchedule;
@property (strong, nonatomic) ALMMapController *controllerMap;

@end

@implementation UCAppDelegate
@synthesize currentSession = _currentSession;

#pragma mark - Views

- (UIViewController *)initialView {
    return [self.currentStoryboard instantiateInitialViewController];
}

- (UIViewController *)loginView {
    return [self.currentStoryboard instantiateViewControllerWithIdentifier:kLoginNavigationControllerName];
}

- (void)showInitialView {
    self.window.rootViewController = self.initialView;
}

+ (void)showInitialView {
    [[self delegate] showInitialView];
}

- (void)showLoginView {
    self.window.rootViewController = self.loginView;
}

+ (void)showLoginView {
    [[self delegate] showLoginView];
}

- (void)didLoginWithSession:(ALMSession *)session {
    self.currentSession = session; //[ALMSession sessionWithEmail:session.email];
    
    /*
    self.controllerSchedule.promiseLoaded.then( ^(NSArray *sections){
        
        // [UCScheduleNotifications setup];
        for (ALMSection *section in sections) {
            [UCScheduleNotifications scheduleNotificationFoItems:section.scheduleItems];
        }
        
        return [self.controllerMap fetchMaps];
        
    }).then(^(NSArray *campuses) {
        [NSUserDefaults justUpdateAreas];
        
    }).catch( ^(NSError *error) {
        NSLog(@"ERROR %@", error);
        
    }).finally(^{
        [self setupNotifications];
        [self showInitialView];
    });
     */
}

+ (void)didLoginWithSession:(ALMSession *)session {
    [[self delegate] didLoginWithSession:session];
}

#pragma mark - Main AppDelegate methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Lets add a default value for every user default.
    [self setupUserDefaults];
    
    // Setup activity indicator
    [self setupActivityIndicator];
    
    // Setup AlmappCore
    [self setupAlmapp];
    
    //[self deleteDatabase];
    // NSLog(@"Database path: %@", self.databasePath);
    
    // Prepare external APIs
    [self setupGoogleMaps];
    
    // Prepare notifications
    // [self setupNotifications];
    
    // Set global background
    // [self setupBackground];
    
    // Set navbar style
    [self setupNavigationBar];
    
    //[self promiseLoggedToMainService].catch(^(NSError *error) {
    //    NSLog(@"%@", error);
    //});
    
    BOOL isLoggedIn = (self.currentSession != nil);  // from your server response
    
    //NSString *storyboardId = isLoggedIn ? @"RootController" : @"LoginController";
    //self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:storyboardId];
    
    if (isLoggedIn) {
        [self showInitialView];
    }
    else {
        [self showLoginView];
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    if (![NSUserDefaults hasRegisterNotifications]) {
        
        const unsigned *tokenBytes = [deviceToken bytes];
        NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                              ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                              ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                              ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
        
        NSDictionary *params = @{@"platform" : @"ios", @"token" : hexToken};
        [[self.almappCore controllerWithCredential:self.credential] POST:@"me/devices" parameters:params].then( ^(id response, NSURLSessionDataTask *task) {
            [NSUserDefaults justRegisteredNotifications];
        }).catch( ^(NSError *error) {
            NSLog(@"Error sending push notification token");
        });
    }
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"%@",str);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"%@", userInfo);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self.http activeCookies];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Singleton

+ (instancetype)delegate {
    return (UCAppDelegate*)[UIApplication sharedApplication].delegate;
}

+ (ALMSession *)currentSession {
    return [[self delegate] currentSession];
}

- (ALMSession *)currentSession {
    if (!_currentSession) {
        NSString *email = [NSUserDefaults currentSessionEmail];
        if (email && email.length > 0) {
            _currentSession = [ALMSession sessionWithEmail:email];
        }
    }
    return _currentSession;
}

- (void)setCurrentSession:(ALMSession *)currentSession {
    _currentSession = currentSession;
    [NSUserDefaults setCurrentSession:currentSession.email];
}

- (ALMCredential *)credential {
    return self.currentSession.credential;
}

+ (ALMCredential *)credential {
    return [self currentSession].credential;
}

- (ALMController *)controller {
    ALMController *controller = [self.almappCore controllerWithCredential:self.credential];
    controller.saveToRealm = YES;
    if (!controller.realm) {
        controller.realm = [RLMRealm defaultRealm];
    }
    return controller;
}

+ (ALMController *)controller {
    return [[self delegate] controller];
}


#pragma mark - Getters

- (UCHTTP *)http {
    if (!_http) {
        _http = [[UCHTTP alloc] init];
    }
    return _http;
}

+ (UCHTTP *)http {
    return [[self delegate] http];
}


#pragma mark - Controllers

+ (ALMLikesController *)controllerLike {
    return [[self delegate] controllerLike];
}

- (ALMLikesController *)controllerLike {
    if (!_controllerLike) {
        _controllerLike = [ALMLikesController controllerForSession:self.currentSession];
    }
    return _controllerLike;
}

+ (ALMMapController *)controllerMap {
    return [[self delegate] controllerMap];
}

- (ALMMapController *)controllerMap {
    if (!_controllerMap) {
        _controllerMap = [ALMMapController controllerForSession:self.currentSession];
    }
    return _controllerMap;
}

+ (ALMScheduleController *)controllerSchedule {
    return [[self delegate] controllerSchedule];
}

- (ALMScheduleController *)controllerSchedule {
    if (!_controllerSchedule) {
        _controllerSchedule = [ALMScheduleController controllerForSession:self.currentSession];
    }
    return _controllerSchedule;
}


#pragma mark - Promises

- (PMKPromise *)promiseLoggedToMainService {
    return [self.http loginToMainWebServiceWith:self.credential];
}

+ (PMKPromise *)promiseLoggedToMainService {
    return [[self delegate] promiseLoggedToMainService];
}

- (PMKPromise *)promiseLoggedToWebMail {
    return [self.http loginToWebMail:self.credential];
}

+ (PMKPromise *)promiseLoggedToWebMail {
    return [[self delegate] promiseLoggedToWebMail];
}


#pragma mark - AppDelegate Methods

- (UIStoryboard *)currentStoryboard {
    return [UIStoryboard storyboardWithName:kStoryboardName bundle:nil];
}

- (int)apiVersionNumber {
    return kAPIVersion;
}

- (NSString *)apiVersion {
    return [NSString stringWithFormat:@"v%d", self.apiVersionNumber];
}

- (NSURL *)apiServerUrl {
    return [NSURL URLWithString:kAPIBaseUrl];
}

+ (NSURL *)apiServerUrl {
    return [[self delegate] apiServerUrl];
}

- (void)dropDatabase {
    [_almappCore dropDefaultDatabase];
}

- (void)deleteDatabase {
    [_almappCore deleteDefaultDatabase];
}

- (NSString *)databasePath {
    return _almappCore.defaultRealm.path;
}


#pragma mark - Setup methods

- (void)setupAlmapp {
    UCApiKey *key = [UCApiKey OAuthApiKeyFor:kAlmappApiKey];

    _almappCore = [ALMCore coreWithDelegate:self
                                    baseURL:[NSURL URLWithString:kAPIBaseUrl]
                                 apiVersion:self.apiVersionNumber
                                     apiKey:[ALMApiKey apiKeyWithClient:key.uid secret:key.secret]
                               organization:KOrganization];
}

- (void)setupNotifications {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound |
                                                                                                                          UIUserNotificationTypeAlert |
                                                                                                                          UIUserNotificationTypeBadge) categories:nil]];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge |
                                                                                UIRemoteNotificationTypeSound |
                                                                                UIRemoteNotificationTypeAlert)];
    }
}

- (void)setupUserDefaults {
    NSUserDefaults* defaults =[NSUserDefaults standardUserDefaults];
    if(![defaults boolForKey:@"USER_DEFAULTS_V1_FIRST_RUN"]) {
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        [defaults removePersistentDomainForName:appDomain];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        
        [defaults setBool:YES forKey:@"USER_DEFAULTS_V1_FIRST_RUN"];
    }
}

- (void)setupActivityIndicator {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}

- (void)setupGoogleMaps {
    [GMSServices provideAPIKey:[UCApiKey apiKeyFor:kGoogleMapsApiKey]];
}

- (void)setupBackground {
    UIImageView *iv = [[UIImageView alloc] initWithFrame:self.window.frame];
    //iv.image = [[UIImage imageNamed:@"background1.jpg"] applyBlurWithRadius:1 tintColor:[UIColor clearColor] saturationDeltaFactor:2 maskImage:nil];
    //iv.image = [[UIImage imageNamed:@"background1.jpg"] applyDarkEffect];
    iv.image = [UIImage imageNamed:@"background4.png"];
    [self.window addSubview:iv];
    [self.window sendSubviewToBack: iv];
    
    /*
    UIView* statusBarLayer = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.window.frame.size.width, [[UIApplication sharedApplication] statusBarFrame].size.height)];
    [statusBarLayer setBackgroundColor:[UIColor lightLayer]];
    
    [self.window addSubview:statusBarLayer];
    statusBarLayer.translatesAutoresizingMaskIntoConstraints = NO;
    [statusBarLayer.superview addConstraint:[NSLayoutConstraint constraintWithItem:statusBarLayer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:statusBarLayer.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [statusBarLayer.superview addConstraint:[NSLayoutConstraint constraintWithItem:statusBarLayer attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:statusBarLayer.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [statusBarLayer.superview addConstraint:[NSLayoutConstraint constraintWithItem:statusBarLayer attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:statusBarLayer.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    [statusBarLayer.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[statusBarLayer(==20)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(statusBarLayer)]];
    [statusBarLayer.superview setNeedsUpdateConstraints];
     */
}

- (void)setupNavigationBar {
    [[UINavigationBar appearance] setTintColor:[UIColor accentColor]];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:@"Montserrat" size:19],
                                NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor clearColor];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor accentColor],
       NSShadowAttributeName:shadow,
       NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:17]
       }
     forState:UIControlStateNormal];
    
}


#pragma mark - AlmappCore methods

-(void)startPerformingNetworkTask {
    
}

-(void)stopPerformingNetworkTask {
    
}

@end
