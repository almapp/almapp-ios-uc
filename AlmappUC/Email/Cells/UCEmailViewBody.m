//
//  UCEmailViewBody.m
//  AlmappUC
//
//  Created by Patricio López on 01-03-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCEmailViewBody.h"

@implementation UCEmailViewBody

+ (NSString *)nibName {
    return @"UCEmailViewBody";
}

+ (CGFloat)height {
    return 44.0f;
}

- (void)awakeFromNib {
    self.webView.scalesPageToFit = YES;
    //self.webView.scrollView.delegate = self;
    //[self.webView.scrollView setShowsVerticalScrollIndicator:NO];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 0  ||  scrollView.contentOffset.y < 0 )
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
}

- (void)setEmail:(ALMEmail *)email {
    if (![self.email.identifier isEqualToString:email.identifier]) {
        [super setEmail:email];
        [self.webView stopLoading];
        self.webView.delegate = self;
        self.webView.scrollView.scrollEnabled = NO;
        self.webView.scrollView.bounces = NO;
        [self hideWebView];
        [self.webView loadHTMLString:email.bodyHTML baseURL:nil];
    }
}

// http://blog.jldagon.me/blog/2012/08/13/uiscrollception-embedding-multiple-uiwebviews-in-a-uitableview/

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSInteger height = 0;
    
    int option = 0;
    switch (option) {
        case 0: {
            CGRect frame = webView.frame;
            frame.size.height = 1;
            webView.frame = frame;
            CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
            frame.size = fittingSize;
            webView.frame = frame;
            
            height = fittingSize.height;
            break;
        }
        case 1: {
            NSString *output = [webView  stringByEvaluatingJavaScriptFromString: @"document.documentElement.clientHeight;"];
            height = [output intValue];
        }
            
            
        default:
            break;
    }
    
    
    if (self.delegate) {
        [self.delegate reloadEmailCell:self.email height:height];
    }
    
    [self showWebView];
}

- (void)hideWebView {
    self.webView.hidden = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.activityIndicator startAnimating];
}

- (void)showWebView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.activityIndicator stopAnimating];
    self.webView.hidden = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
