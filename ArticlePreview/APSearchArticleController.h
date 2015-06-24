//
//  MasterViewController.h
//  ArticlePreview
//
//  Created by Saket on 22/06/15.
//  Copyright (c) 2015 Saket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface APSearchArticleController
    : UITableViewController <NSFetchedResultsControllerDelegate,
                             UISearchResultsUpdating, UISearchBarDelegate>

@property(strong, nonatomic)
    NSFetchedResultsController *fetchedResultsController;
@property(strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
