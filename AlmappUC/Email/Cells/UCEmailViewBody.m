//
//  UCEmailViewBody.m
//  AlmappUC
//
//  Created by Patricio López on 01-03-15.
//  Copyright (c) 2015 almapp. All rights reserved.
//

#import "UCEmailViewBody.h"

static NSString *const kEmptyWebPageURl = @"about:blank";

@implementation UCEmailViewBody

+ (NSString *)nibName {
    return @"UCEmailViewBody";
}

+ (CGFloat)height {
    return 44.0f;
}

- (void)awakeFromNib {
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.scrollView.bounces = NO;
    //self.webView.scrollView.delegate = self;
    //[self.webView.scrollView setShowsVerticalScrollIndicator:NO];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 0  ||  scrollView.contentOffset.y < 0 )
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
}

- (void)setEmail:(ALMEmail *)email {
    if (!self.email || ![self.email.identifier isEqualToString:email.identifier]) {
        [super setEmail:email];
        [self.webView stopLoading];
        [self hideWebView];
        [self.webView loadHTMLString:email.bodyHTML baseURL:[NSURL URLWithString:@"www.uc.cl"]];
    }
}
// http://fuzionpro.com/2014/01/14/add-dynamic-height-uiwebview-uitableview/
// http://stackoverflow.com/questions/6118035/fitting-uiwebview-into-uitableviewcell?rq=1
// http://blog.jldagon.me/blog/2012/08/13/uiscrollception-embedding-multiple-uiwebviews-in-a-uitableview/

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *string = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('html')[0].innerHTML"];
    BOOL isEmpty = string==nil || [string length]==0;
    if (isEmpty) {
        return;
    }
    
    CGSize contentSize = webView.scrollView.contentSize;
    CGSize viewSize = self.contentView.bounds.size;
    
    float rw = viewSize.width / contentSize.width;
    
    webView.scrollView.minimumZoomScale = rw;
    webView.scrollView.maximumZoomScale = rw;
    webView.scrollView.zoomScale = rw;
    
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
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kEmptyWebPageURl]]];
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
