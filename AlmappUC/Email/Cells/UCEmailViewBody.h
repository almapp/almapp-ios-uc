//
//  UCEmailViewBody.h
//  AlmappUC
//
//  Created by Patricio López on 01-03-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCEmailViewCell.h"

@protocol UCEmailViewBodyDelegate <NSObject>

@required
- (void)reloadEmailCell:(ALMEmail *)email height:(NSInteger)height;

@end

@interface UCEmailViewBody : UCEmailViewCell <UIWebViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) id<UCEmailViewBodyDelegate> delegate;

@end
