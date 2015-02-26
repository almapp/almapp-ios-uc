//
//  UCWebBrowserViewController.m
//  AlmappUC
//
//  Created by Patricio López on 13-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCWebBrowserViewController.h"
#import "TLYShyNavBarManager.h"
#import "UCAppDelegate.h"
#import "UCConstants.h"

NSString *const kWebBrowserDefaultURL = @"http://www.google.cl";

@interface UCWebBrowserViewController ()
@property (strong, nonatomic) UISearchBar *searchBar;
@end

@implementation UCWebBrowserViewController

+ (UCWebBrowserViewController *)myWebBrowser {
    return [[UCWebBrowserViewController alloc] initWithConfiguration:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.shyNavBarManager.scrollView = self.uiWebView.scrollView;
    
    /*
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44.f)];
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [_searchBar setBackgroundImage:[UCStyle bannerBackgroundImage]];
    
    [self.shyNavBarManager setExtensionView:_searchBar];
     */
    
    self.uiWebView.delegate = self;
    
    self.showsURLInNavigationBar = YES;
    self.showsPageTitleInNavigationBar = YES;
    self.hidesBottomBarWhenPushed = YES;
    
    
    if (_initialUrlToLoad && _initialUrlToLoad.length > 0) {
        [self loadURLString:_initialUrlToLoad];
    }
    else if (_initialWebpageToLoad) {
        if ([_initialWebpageToLoad.identifier isEqualToString:@"PORTALUC"] ||
            [_initialWebpageToLoad.identifier isEqualToString:@"WEBCURSOS"]) {
            [self loginTo:_initialWebpageToLoad after:[UCAppDelegate promiseLoggedToMainService]];
        }
        
        else if ([_initialWebpageToLoad.identifier isEqualToString:@"SIDING"]) {
            [self loginTo:_initialWebpageToLoad after:[[UCAppDelegate http] loginToSiding:[UCAppDelegate credential]]];
        }
        
        else if ([_initialWebpageToLoad.identifier isEqualToString:@"LABMAT"]) {
            [self loginTo:_initialWebpageToLoad after:[[UCAppDelegate http] loginToLabmat:[UCAppDelegate credential]]];
        }
        
        else {
            [self loadURLString:_initialWebpageToLoad.homeUrl];
        }
    }
    else {
        [self loadURLString:kWebBrowserDefaultURL];
    }
}

- (void)loginTo:(ALMWebPage *)webPage after:(PMKPromise *)promise {
    __weak __typeof(self) weakSelf = self;
    
    promise.then(^ {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf loadURLString:webPage.loginUrl];
        }
        
    }).catch(^(NSError *error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf loadURLString:webPage.homeUrl];
        }
    });
}



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    [super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    //NSURL *url = request.URL;
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
