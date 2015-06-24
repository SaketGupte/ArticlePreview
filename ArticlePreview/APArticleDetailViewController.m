//
//  APArticleDetailViewController.m
//  ArticlePreview
//
//  Created by Saket on 23/06/15.
//  Copyright (c) 2015 Saket. All rights reserved.
//

#import "APArticleDetailViewController.h"

@interface APArticleDetailViewController()


@end

@implementation APArticleDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *articleLinkURL = [NSURL URLWithString:self.webViewLink];
    NSURLRequest *request =  [NSURLRequest requestWithURL:articleLinkURL];
    [_articleWebView loadRequest:request];
}

//*******************************************************************************************************
#pragma mark - UIWebView Delegate


- (void)webViewDidStartLoad:(UIWebView *)webView {
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}
@end
