//
//  APSearchForArticles.m
//  ArticlePreview
//
//  Created by Saket on 22/06/15.
//  Copyright (c) 2015 Saket. All rights reserved.
//

#import "APConstants.h"
#import "APSearchForArticles.h"
#import "Reachability.h"

//*********************************************************************************************************
#pragma mark - Private Class Interface

@interface __p_articleDownload : APSearchForArticles

@end

//*********************************************************************************************************
#pragma mark - Private Class Implementation

@implementation __p_articleDownload

- (void)downloadArticlesWithText:(NSString *)searchText
                isGettingUpdated:(BOOL)updating {

  NSURLSession *session = [self createSession];
  NSString *baseString =
      [NSString stringWithFormat:apBaseQuery, searchText, apAPI_KEY];
  NSURLSessionDataTask *task = [session
        dataTaskWithURL:
            [NSURL URLWithString:[baseString
                                     stringByAddingPercentEscapesUsingEncoding:
                                         NSUTF8StringEncoding]]
      completionHandler:^(NSData *responseData, NSURLResponse *response,
                          NSError *error) {
        if (!error) {
          NSError *parsingError;
          NSMutableDictionary *articlesJson =
              [NSJSONSerialization JSONObjectWithData:responseData
                                              options:kNilOptions
                                                error:&parsingError];
          if (!updating) {
            [[NSNotificationCenter defaultCenter]
                postNotificationName:apArticleSearchCompleteNotification
                              object:self
                            userInfo:articlesJson];
          } else {
            [[NSNotificationCenter defaultCenter]
                postNotificationName:apArticleUpdatedNotitifcation
                              object:self
                            userInfo:articlesJson];
          }
        }
      }];

  [task resume];
}

- (void)downloadArticlesWithText:(NSString *)searchText
                   forPageNumber:(NSInteger)pageNumber {

  NSURLSession *session = [self createSession];
  NSString *baseString = [NSString
      stringWithFormat:apQueryForPageNumber, searchText, pageNumber, apAPI_KEY];
  NSURLSessionDataTask *task = [session
        dataTaskWithURL:
            [NSURL URLWithString:[baseString
                                     stringByAddingPercentEscapesUsingEncoding:
                                         NSUTF8StringEncoding]]
      completionHandler:^(NSData *responseData, NSURLResponse *response,
                          NSError *error) {
        if (!error) {
          NSError *parsingError;
          NSMutableDictionary *articlesJson =
              [NSJSONSerialization JSONObjectWithData:responseData
                                              options:kNilOptions
                                                error:&parsingError];
          [[NSNotificationCenter defaultCenter]
              postNotificationName:apMoreArticlesAddedNotification
                            object:self
                          userInfo:articlesJson];
        }
      }];
  [task resume];
}

- (NSURLSession *)createSession {

  static NSURLSession *session;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSURLSessionConfiguration *configuration =
        [NSURLSessionConfiguration defaultSessionConfiguration];
    session = [NSURLSession sessionWithConfiguration:configuration];
  });
  return session;
}
@end

//*********************************************************************************************************
#pragma mark - Extension

@interface APSearchForArticles () {
  Reachability *isInternetConnectionAvailable;
}

- (BOOL)isConnectionAvailable;

@end

//*********************************************************************************************************
#pragma mark - Implementation

@implementation APSearchForArticles

- (void)initwithSearchText:(NSString *)searchText
             updateArticle:(BOOL)articleListGettingUpdated {
  if ([self isConnectionAvailable]) {

    __p_articleDownload *downloadArticle = [[__p_articleDownload alloc] init];
    [downloadArticle downloadArticlesWithText:searchText
                             isGettingUpdated:articleListGettingUpdated];
  }
}

- (void)initWithSearchText:(NSString *)searchText
             forPageNumber:(NSInteger)pageNumber {
  if ([self isConnectionAvailable]) {
    __p_articleDownload *downloadArticle = [[__p_articleDownload alloc] init];
    [downloadArticle downloadArticlesWithText:searchText
                                forPageNumber:pageNumber];
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
    [[NSNotificationCenter defaultCenter]
        postNotificationName:apNoInternetConnectivityNotification
                      object:self
                    userInfo:nil];
    return false;
  }
  }
}

@end
