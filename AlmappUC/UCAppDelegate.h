//
//  UCAppDelegate.h
//  AlmappUC
//
//  Created by Patricio López on 29-12-14.
//  Copyright (c) 2014 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AlmappCore/AlmappCore.h>

#import "UCHTTP.h"
#import "UCApiKey.h"
#import "RESideMenu.h"
#import "UIView+ProgressView.h"

extern int const kAPIVersion;
extern NSString * const kAPIBaseUrl;
extern NSString * const KOrganization;

@interface UCAppDelegate : UIResponder <UIApplicationDelegate, RESideMenuDelegate, ALMCoreDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UCHTTP *http;
+ (UCHTTP *)http;


#pragma mark - Views

- (void)showInitialView;
+ (void)showInitialView;

- (void)showLoginView;
+ (void)showLoginView;

- (void)didLoginWithSession:(ALMSession *)session;
+ (void)didLoginWithSession:(ALMSession *)session;

#pragma mark - Singleton

+ (instancetype)delegate;


#pragma mark - Controllers

- (ALMMapController *)controllerMap;
+ (ALMMapController *)controllerMap;

- (ALMScheduleController *)controllerSchedule;
+ (ALMScheduleController *)controllerSchedule;

- (ALMLikesController *)controllerLike;
+ (ALMLikesController *)controllerLike;


#pragma mark - Promises

- (PMKPromise *)promiseLoggedToMainService;
+ (PMKPromise *)promiseLoggedToMainService;

- (PMKPromise *)promiseLoggedToWebMail;
+ (PMKPromise *)promiseLoggedToWebMail;

#pragma mark - Session

- (ALMSession *)currentSession;
+ (ALMSession *)currentSession;

- (ALMCredential *)credential;
+ (ALMCredential *)credential;

- (ALMController *)controller;
+ (ALMController *)controller;


#pragma mark - Public setup

- (void)setupNotifications;


#pragma mark - AppDelegate Methods

- (UIStoryboard *)currentStoryboard;
- (void)dropDatabase;
- (void)deleteDatabase;
- (NSString *)databasePath;

- (int)apiVersionNumber;
- (NSString *)apiVersion;
- (NSURL *)apiServerUrl;
+ (NSURL *)apiServerUrl;

@end

