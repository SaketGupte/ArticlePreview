//
//  NSDictionary+APIResponse.h
//  ArticlePreview
//
//  Created by Saket on 22/06/15.
//  Copyright (c) 2015 Saket. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (APIResponse)

- (NSDictionary *) metaData;
- (NSArray *) articleList;

@end
