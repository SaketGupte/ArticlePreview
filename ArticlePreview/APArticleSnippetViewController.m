//
//  APArticleSnippetViewController.m
//  ArticlePreview
//
//  Created by Saket on 23/06/15.
//  Copyright (c) 2015 Saket. All rights reserved.
//

#import "APArticleSnippetViewController.h"
#import "UIImageView+DownloadImage.h"
#import "APConstants.h"
#import "APArticleDetailViewController.h"
#import "Reachability.h"

@interface APArticleSnippetViewController ()

@property(nonatomic, strong) UILabel *headlinesLabel;
@property(nonatomic, strong) UITextView *paragraphView;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIView *containerView;

- (void)arrangeViewLayoutForLandscapeOrientation;

- (void)arrangeViewLayoutForPotraitOrientation;

- (void)setConstraintsToView:(UIView *)view
            withVisualFormat:(NSString *)format
               forDictionary:(NSDictionary *)dictionary;
- (void)presentWebViewForArticle;
- (BOOL)isConnectionAvailable;

@end

@implementation APArticleSnippetViewController

@synthesize headlinesLabel = _headlinesLabel;
@synthesize paragraphView = _paragraphView;
@synthesize imageView = _imageView;
@synthesize containerView = _containerView;

//**********************************************************************************************************
#pragma mark - LifeCycle Methods

- (void)viewWillAppear:(BOOL)animated {

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(deviceOrientationChanged)
             name:UIDeviceOrientationDidChangeNotification
           object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {

  [[NSNotificationCenter defaultCenter]
      removeObserver:self
                name:UIDeviceOrientationDidChangeNotification
              object:nil];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  UIBarButtonItem *webViewButton = [[UIBarButtonItem alloc]
      initWithTitle:@"Go To Link"
              style:UIBarButtonItemStyleDone
             target:self
             action:@selector(presentWebViewForArticle)];
  self.navigationItem.rightBarButtonItem = webViewButton;
  [self deviceOrientationChanged];
}

//*****************************************************************************************************
#pragma mark - Notification Methods

- (void)deviceOrientationChanged {

  UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;

  if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
    [self arrangeViewLayoutForLandscapeOrientation];
  } else if (UIDeviceOrientationIsPortrait(deviceOrientation)) {
    [self arrangeViewLayoutForPotraitOrientation];
  }
}

//**********************************************************************************************************
#pragma mark - Arrange Viewlayout

- (void)arrangeViewLayoutForLandscapeOrientation {

  [self.containerView addSubview:self.imageView];
  [self.containerView addSubview:self.paragraphView];
  [self.view addSubview:self.headlinesLabel];
  [self.view addSubview:self.containerView];

  NSDictionary *elementsOfSubview =
      NSDictionaryOfVariableBindings(_imageView, _paragraphView);

  [self setConstraintsToView:self.containerView
            withVisualFormat:apHorizonatlSubview
               forDictionary:elementsOfSubview];
  [self setConstraintsToView:self.containerView
            withVisualFormat:apVerticalImageViewSubview
               forDictionary:elementsOfSubview];
  [self setConstraintsToView:self.containerView
            withVisualFormat:apVerticalParagraphSubview
               forDictionary:elementsOfSubview];

  NSDictionary *elementsOfMainview =
      NSDictionaryOfVariableBindings(_headlinesLabel, _containerView);

  [self setConstraintsToView:self.view
            withVisualFormat:apVerticalMainViewLandscape
               forDictionary:elementsOfMainview];
  [self setConstraintsToView:self.view
            withVisualFormat:apHorizontalHeadlineMainLandscape
               forDictionary:elementsOfMainview];
  [self setConstraintsToView:self.view
            withVisualFormat:apHorizontalSubviewMainlandscape
               forDictionary:elementsOfMainview];
}

- (void)arrangeViewLayoutForPotraitOrientation {

  [self.view addSubview:self.headlinesLabel];
  [self.view addSubview:self.imageView];
  [self.view addSubview:self.paragraphView];

  NSDictionary *elementsOfMainview = NSDictionaryOfVariableBindings(
      _headlinesLabel, _imageView, _paragraphView);

  [self setConstraintsToView:self.view
            withVisualFormat:apVerticalPotrait
               forDictionary:elementsOfMainview];

  [self setConstraintsToView:self.view
            withVisualFormat:apHorizontalHeadlinePotrait
               forDictionary:elementsOfMainview];

  [self setConstraintsToView:self.view
            withVisualFormat:apHorizontalImageViewPotrait
               forDictionary:elementsOfMainview];

  [self setConstraintsToView:self.view
            withVisualFormat:apHorizontalParagraphPotrait
               forDictionary:elementsOfMainview];
}

//**********************************************************************************************************
#pragma mark - Private Methods

- (void)setConstraintsToView:(UIView *)view
            withVisualFormat:(NSString *)format
               forDictionary:(NSDictionary *)dictionary {

  [view addConstraints:
            [NSLayoutConstraint
                constraintsWithVisualFormat:
                    format options:NSLayoutFormatDirectionLeadingToTrailing
                                    metrics:nil
                                      views:dictionary]];
}

- (void)presentWebViewForArticle {

  if ([self isConnectionAvailable]) {
    UIStoryboard *storyboard =
        [UIStoryboard storyboardWithName:apMainStoryBoardName bundle:nil];
    APArticleDetailViewController *apArticleDetailViewController =
        (APArticleDetailViewController *)
            [storyboard instantiateViewControllerWithIdentifier:
                            apArticleDetailViewControllerIdentifier];
    apArticleDetailViewController.webViewLink = self.urlLink;
    [self.navigationController pushViewController:apArticleDetailViewController
                                         animated:YES];
  } else {
    UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:apAlertViewTitle
                                   message:apNoInternetConnectivityAlertMessage
                                  delegate:self
                         cancelButtonTitle:apAlertViewOkButton
                         otherButtonTitles:nil];
    [alertView show];
  }
}

- (BOOL)isConnectionAvailable {
  Reachability *myNetwork =
      [Reachability reachabilityWithHostname:@"google.com"];
  NetworkStatus netStatus = [myNetwork currentReachabilityStatus];

  switch (netStatus) {
  case ReachableViaWWAN: {
    return true;
  }
  case ReachableViaWiFi: {
    return true;
  }
  case NotReachable: {
    return false;
  }
  }
}
//**********************************************************************************************************
#pragma mark - UI Elements

- (UILabel *)headlinesLabel {
  if (!_headlinesLabel) {
    _headlinesLabel = [UILabel new];
    [_headlinesLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_headlinesLabel setTextAlignment:NSTextAlignmentCenter];
    [_headlinesLabel setText:self.headlines]; // add picture here
    [_headlinesLabel setNumberOfLines:2];
    [_headlinesLabel setBackgroundColor:
                         [UIColor colorWithRed:1.0 green:0.6 blue:0.2 alpha:1]];
  }
  [_headlinesLabel removeFromSuperview];
  return _headlinesLabel;
}

- (UIImageView *)imageView {
  if (!_imageView) {
    _imageView = [UIImageView new];
    [_imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    if (self.imageLink) {
      [_imageView downloadImageFromURL:self.imageLink
                        operateWithKey:self.headlines];
    } else {
      [_imageView setImage:[UIImage imageNamed:@"NYTimesLogo"]];
    }
  }
  [_imageView removeFromSuperview];
  return _imageView;
}

- (UITextView *)paragraphView {
  if (!_paragraphView) {
    _paragraphView = [UITextView new];
    [_paragraphView setEditable:NO];
    [_paragraphView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_paragraphView setTextAlignment:NSTextAlignmentCenter];
    [_paragraphView setBackgroundColor:
                        [UIColor colorWithRed:1.0 green:0.8 blue:0.6 alpha:1]];
    if (self.paragraph) {
      [_paragraphView setText:self.paragraph]; // set text here;
    } else {
      [_paragraphView setText:@"No details Found"];
      [_paragraphView setFont:[UIFont boldSystemFontOfSize:14.0]];
    }
  }
  [_paragraphView removeFromSuperview];
  return _paragraphView;
}

- (UIView *)containerView {
  if (!_containerView) {
    _containerView = [UIView new];
    [_containerView setTranslatesAutoresizingMaskIntoConstraints:NO];
  }
  return _containerView;
}

@end
