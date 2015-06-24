//
//  APSearchForArticles.h
//  ArticlePreview
//
//  Created by Saket on 22/06/15.
//  Copyright (c) 2015 Saket. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Reachability;

@interface APSearchForArticles : NSObject

- (void)initwithSearchText: (NSString *)searchText updateArticle:(BOOL)updating;
- (void)initWithSearchText: (NSString *)searchText forPageNumber:(NSInteger)pageNumber;

@end
