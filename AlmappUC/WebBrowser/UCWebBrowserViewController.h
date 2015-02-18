//
//  UCWebBrowserViewController.h
//  AlmappUC
//
//  Created by Patricio López on 13-01-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "KINWebBrowserViewController.h"
#import <AlmappCore/AlmappCore.h>

extern NSString *const kWebBrowserDefaultURL;

@interface UCWebBrowserViewController : KINWebBrowserViewController

@property (strong, nonatomic) NSString *initialUrlToLoad;
@property (strong, nonatomic) ALMWebPage *initialWebpageToLoad;

+ (UCWebBrowserViewController *)myWebBrowser;

@end
