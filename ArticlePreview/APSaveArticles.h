//
//  APSaveArticles.h
//  ArticlePreview
//
//  Created by Saket on 22/06/15.
//  Copyright (c) 2015 Saket. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;

@interface APSaveArticles : NSObject

@property(strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)saveNewArticles:(NSDictionary *)responseDictionary
          forSearchTerm:(NSString *)keyword;

- (void)updateArticle:(NSDictionary *)responseDictionary
        forSearchTerm:(NSString *)keyword;

- (void)updateByAddingNewArticle:(NSDictionary *)responseDictionary
                   forSearchTerm:(NSString *)keyword;

@end
