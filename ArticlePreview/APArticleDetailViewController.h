//
//  APArticleDetailViewController.h
//  ArticlePreview
//
//  Created by Saket on 23/06/15.
//  Copyright (c) 2015 Saket. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APArticleDetailViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, strong) NSString* webViewLink;
@property (weak, nonatomic) IBOutlet UIWebView *articleWebView;


@end
