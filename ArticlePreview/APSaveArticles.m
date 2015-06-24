//
//  APSaveArticles.m
//  ArticlePreview
//
//  Created by Saket on 22/06/15.
//  Copyright (c) 2015 Saket. All rights reserved.
//

#import "APConstants.h"
#import "APSaveArticles.h"
#import "NSDictionary+APIResponse.h"
#import "NSDictionary+ArticleDetails.h"

@interface APSaveArticles ()

- (NSManagedObject *)createNewInstanceOfEntity:(NSEntityDescription *)entity
                                withValuesFrom:(NSDictionary *)dictionary;

@end

@implementation APSaveArticles

- (void)saveNewArticles:(NSDictionary *)responseDictionary
          forSearchTerm:(NSString *)keyword {

  NSEntityDescription *searchTermEntity =
      [NSEntityDescription entityForName:apEntitySearchTerm
                  inManagedObjectContext:self.managedObjectContext];

  NSManagedObject *newSearchTerm =
      [[NSManagedObject alloc] initWithEntity:searchTermEntity
               insertIntoManagedObjectContext:self.managedObjectContext];

  [newSearchTerm setValue:keyword forKey:apKeyword];
  [newSearchTerm setValue:[NSDate date] forKey:apLastSearchDate];

  NSEntityDescription *articleDetailEntity =
      [NSEntityDescription entityForName:apEntityArticleDetails
                  inManagedObjectContext:self.managedObjectContext];
  NSArray *listOfArticle = [responseDictionary articleList];
  NSMutableSet *articleList = [[NSMutableSet alloc] init];

  for (NSDictionary *article in listOfArticle) {
    // add to set
    [articleList addObject:[self createNewInstanceOfEntity:articleDetailEntity
                                            withValuesFrom:article]];
  }
  [newSearchTerm setValue:articleList forKey:apRelationshipArticleDetails];

  NSError *error = nil;
  if (![newSearchTerm.managedObjectContext save:&error]) {
    NSLog(@"Unable to save managed object context.");
    NSLog(@"%@, %@", error, error.localizedDescription);
  }
}

- (void)updateArticle:(NSDictionary *)responseDictionary
        forSearchTerm:(NSString *)keyword {

  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

  NSEntityDescription *entity =
      [NSEntityDescription entityForName:apEntitySearchTerm
                  inManagedObjectContext:self.managedObjectContext];

  [fetchRequest setEntity:entity];

  NSPredicate *predicate =
      [NSPredicate predicateWithFormat:@"SELF.keyword matches[c] %@", keyword];

  [fetchRequest setPredicate:predicate];

  NSError *error = nil;
  NSArray *result =
      [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

  NSManagedObject *searchTerm = (NSManagedObject *)[result objectAtIndex:0];
  // this is the list of the articles present
  // may be will need to change it to [result objectAtIndex:0]

  NSMutableSet *newArticles =
      [searchTerm mutableSetValueForKey:apRelationshipArticleDetails];
  // these is the set of the articles to be added

  NSEntityDescription *articleDetailEntity =
      [NSEntityDescription entityForName:apEntityArticleDetails
                  inManagedObjectContext:self.managedObjectContext];
  // create an entity for the articles to be added

  NSArray *listOfArticle = [responseDictionary articleList];
  // get all the articles that have been fetched

  for (NSDictionary *article in
           listOfArticle) { // iterate over the list of articles

    NSSet *existingLinks =
        [[searchTerm valueForKey:apRelationshipArticleDetails]
            valueForKey:apArticleLink];

    if (![existingLinks containsObject:[article articleLink]]) {

      [newArticles addObject:[self createNewInstanceOfEntity:articleDetailEntity
                                              withValuesFrom:article]];
    }
  }

  [searchTerm setValue:newArticles forKey:apRelationshipArticleDetails];

  if (![searchTerm.managedObjectContext save:&error]) {
    NSLog(@"Unable to save managed object context.");
    NSLog(@"%@, %@", error, error.localizedDescription);
  }
}

- (void)updateByAddingNewArticle:(NSDictionary *)responseDictionary
                   forSearchTerm:(NSString *)keyword {

  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

  NSEntityDescription *entity =
      [NSEntityDescription entityForName:apEntitySearchTerm
                  inManagedObjectContext:self.managedObjectContext];

  [fetchRequest setEntity:entity];

  NSPredicate *predicate =
      [NSPredicate predicateWithFormat:@"SELF.keyword matches[c] %@", keyword];

  [fetchRequest setPredicate:predicate];

  NSError *error = nil;
  NSArray *result =
      [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

  NSManagedObject *searchTerm = (NSManagedObject *)[result objectAtIndex:0];
  // this is the list of the articles present
  // may be will need to change it to [result objectAtIndex:0]

  NSMutableSet *newArticles =
      [searchTerm mutableSetValueForKey:apRelationshipArticleDetails];
  // these is the set of the articles to be added

  NSEntityDescription *articleDetailEntity =
      [NSEntityDescription entityForName:apEntityArticleDetails
                  inManagedObjectContext:self.managedObjectContext];
  // create an entity for the articles to be added

  NSArray *listOfArticle = [responseDictionary articleList];
  // get all the articles that have been fetched

  for (NSDictionary *article in
           listOfArticle) { // iterate over the list of articles
    [newArticles addObject:[self createNewInstanceOfEntity:articleDetailEntity
                                            withValuesFrom:article]];
  }

  [searchTerm setValue:newArticles forKey:apRelationshipArticleDetails];

  if (![searchTerm.managedObjectContext save:&error]) {
    NSLog(@"Unable to save managed object context.");
    NSLog(@"%@, %@", error, error.localizedDescription);
  }
}

- (NSManagedObject *)createNewInstanceOfEntity:(NSEntityDescription *)entity
                                withValuesFrom:(NSDictionary *)dictionary {

  NSManagedObject *newArticle =
      [[NSManagedObject alloc] initWithEntity:entity
               insertIntoManagedObjectContext:self.managedObjectContext];

  [newArticle setValue:[dictionary articleLink] forKey:apArticleLink];
  [newArticle setValue:[dictionary leadAuthor] forKey:apAuthorName];
  [newArticle setValue:[dictionary mainHeadlines] forKey:apHeadline];
  [newArticle setValue:[dictionary leadParagraph] forKey:apLeadParagraph];
  [newArticle setValue:[dictionary publishDate] forKey:apPublishDate];
  if ([dictionary imageLink]) {
    [newArticle setValue:[dictionary imageLink] forKey:apImageLink];
  }
  return newArticle;
}

@end
