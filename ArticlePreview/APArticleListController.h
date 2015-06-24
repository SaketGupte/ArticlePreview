//
//  DetailViewController.h
//  ArticlePreview
//
//  Created by Saket on 22/06/15.
//  Copyright (c) 2015 Saket. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreData;

@interface APArticleListController : UITableViewController<NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSString *searchTerm;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property(strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

