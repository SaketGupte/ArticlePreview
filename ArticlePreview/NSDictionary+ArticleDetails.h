//
//  NSDictionary+ArticleDetails.h
//  ArticlePreview
//
//  Created by Saket on 22/06/15.
//  Copyright (c) 2015 Saket. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ArticleDetails)

- (NSDate *)publishDate;
- (NSString *)articleLink;
- (NSString *)imageLink;
- (NSString *)leadParagraph;
- (NSString *)mainHeadlines;
- (NSString *)leadAuthor;


@end
