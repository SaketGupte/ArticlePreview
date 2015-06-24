//
//  DetailViewController.m
//  ArticlePreview
//
//  Created by Saket on 22/06/15.
//  Copyright (c) 2015 Saket. All rights reserved.
//

#import "APArticleListController.h"
#import "APConstants.h"
#import "APSearchForArticles.h"
#import "APSaveArticles.h"
#import "ArticleDetailsTableViewCell.h"
#import "APArticleSnippetViewController.h"
#import "UIImageView+DownloadImage.h"
#import "NSDictionary+APIResponse.h"

@interface APArticleListController ()

- (void)initializePullToRefreshController;
- (void)getUpdatedArticles;
- (void)newContentDownloaded:(NSNotification *)notif;
- (void)newArticlesAdded:(NSNotification *)notif;

@property(nonatomic, assign) NSInteger lastCell;
@property(nonatomic) BOOL shouldPreventDisplayCellAnimation;

@end

@implementation APArticleListController

//**********************************************************************************************************
#pragma mark - LifeCycle Methods

- (void)viewDidLoad {
  [super viewDidLoad];
  [self initializePullToRefreshController];

  // Notification Registration
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(newContentDownloaded:)
             name:apArticleUpdatedNotitifcation
           object:nil];
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(newArticlesAdded:)
             name:apMoreArticlesAddedNotification
           object:nil];
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(noInternetConnectivity)
             name:apNoInternetConnectivityNotification
           object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
  self.shouldPreventDisplayCellAnimation = YES;
}

- (void)viewDidAppear:(BOOL)animated {
  self.shouldPreventDisplayCellAnimation = NO;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

//**********************************************************************************************************
#pragma mark - Private Methods

- (void)initializePullToRefreshController {
  self.refreshControl = [[UIRefreshControl alloc] init];
  self.refreshControl.backgroundColor = [UIColor purpleColor];
  self.refreshControl.tintColor = [UIColor whiteColor];
  [self.refreshControl addTarget:self
                          action:@selector(getUpdatedArticles)
                forControlEvents:UIControlEventValueChanged];
}

- (void)getUpdatedArticles {
  [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
  [[APSearchForArticles alloc] initwithSearchText:self.searchTerm
                                    updateArticle:true];
}

//*****************************************************************************************************
#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([[segue identifier] isEqualToString:@"showArticlePreview"]) {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSManagedObject *object =
        [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [[segue destinationViewController]
        setHeadlines:[[object valueForKey:apHeadline] description]];
    [[segue destinationViewController]
        setImageLink:[[object valueForKey:apImageLink] description]];
    [[segue destinationViewController]
        setParagraph:[[object valueForKey:apLeadParagraph] description]];
    [[segue destinationViewController]
        setUrlLink:[[object valueForKey:apArticleLink] description]];
  }
}

//*****************************************************************************************************
#pragma mark - UITableView Datasource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  _lastCell = [self.fetchedResultsController.fetchedObjects count] - 1;
  return [self.fetchedResultsController.fetchedObjects count];
  // will return number of rows based on the basis fetched results controller
  // results
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  ArticleDetailsTableViewCell *cell = (ArticleDetailsTableViewCell *)[tableView
      dequeueReusableCellWithIdentifier:@"DetailViewCell"]; // changed
  if (!cell) {
    cell = [[ArticleDetailsTableViewCell alloc] init];
  }
  [self configureCell:cell atIndexPath:indexPath];
  return cell;
}

- (void)configureCell:(ArticleDetailsTableViewCell *)cell
          atIndexPath:(NSIndexPath *)indexPath {
  NSManagedObject *object =
      [self.fetchedResultsController objectAtIndexPath:indexPath];
  cell.headlinesLabel.text = [[object valueForKey:apHeadline] description];
  cell.authorNameLabel.text = [[object valueForKey:apAuthorName] description];
  if ([object valueForKey:apImageLink]) {
    [cell.articleImageView
        downloadImageFromURL:[object valueForKey:apImageLink]
              operateWithKey:[object valueForKey:apHeadline]];
  }
  if (indexPath.row % 2) {
    [cell setBackgroundColor:
              [UIColor colorWithRed:1.0 green:0.6 blue:0.2 alpha:1]];
  } else {
    [cell setBackgroundColor:
              [UIColor colorWithRed:1.0 green:0.8 blue:0.6 alpha:1]];
  }
}

- (void)tableView:(UITableView *)tableView
      willDisplayCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == _lastCell &&
      self.shouldPreventDisplayCellAnimation == NO) {
    NSInteger pageNumberToDownload = (_lastCell + 1) / 10;
    [[APSearchForArticles alloc] initWithSearchText:self.searchTerm
                                      forPageNumber:pageNumberToDownload];
  }
}

//**********************************************************************************************************
#pragma mark -
#pragma mark - Notification Methods

- (void)newContentDownloaded:(NSNotification *)notif {
  dispatch_async(dispatch_get_main_queue(), ^{
    APSaveArticles *saveArticleDetails = [[APSaveArticles alloc] init];
    saveArticleDetails.managedObjectContext = self.managedObjectContext;
    [saveArticleDetails updateArticle:[notif userInfo]
                        forSearchTerm:self.searchTerm];
    [self.refreshControl endRefreshing];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
  });
}

- (void)newArticlesAdded:(NSNotification *)notif {
  dispatch_async(dispatch_get_main_queue(), ^{
    NSDictionary *responeDictionary = [notif userInfo];
    if ([[responeDictionary articleList] count] != 0) {
      APSaveArticles *saveArticleDetails = [[APSaveArticles alloc] init];
      saveArticleDetails.managedObjectContext = self.managedObjectContext;
      [saveArticleDetails updateByAddingNewArticle:[notif userInfo]
                                     forSearchTerm:self.searchTerm];
    }
  });
}

- (void)noInternetConnectivity {

  [self.refreshControl endRefreshing];
}

//**********************************************************************************************************
#pragma mark -
#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
  if (_fetchedResultsController != nil) {
    return _fetchedResultsController;
  }

  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  // Edit the entity name as appropriate.

  NSEntityDescription *entity =
      [NSEntityDescription entityForName:apEntityArticleDetails
                  inManagedObjectContext:self.managedObjectContext];
  [fetchRequest setEntity:entity];

  NSSortDescriptor *sortDescriptor =
      [[NSSortDescriptor alloc] initWithKey:apPublishDate ascending:NO];
  NSArray *sortDescriptors = @[ sortDescriptor ];

  [fetchRequest setSortDescriptors:sortDescriptors];

  NSPredicate *predicate =
      [NSPredicate predicateWithFormat:@"SELF.searchTerm.keyword matches[c] %@",
                                       self.searchTerm];
  [fetchRequest setPredicate:predicate];

  NSFetchedResultsController *aFetchedResultsController =
      [[NSFetchedResultsController alloc]
          initWithFetchRequest:fetchRequest
          managedObjectContext:self.managedObjectContext
            sectionNameKeyPath:nil
                     cacheName:nil];
  aFetchedResultsController.delegate = self;
  self.fetchedResultsController = aFetchedResultsController;

  NSError *error = nil;
  if (![self.fetchedResultsController performFetch:&error]) {
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
  }

  return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
  [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
    didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
             atIndex:(NSUInteger)sectionIndex
       forChangeType:(NSFetchedResultsChangeType)type {
  switch (type) {
  case NSFetchedResultsChangeInsert:
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                  withRowAnimation:UITableViewRowAnimationFade];
    break;

  case NSFetchedResultsChangeDelete:
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                  withRowAnimation:UITableViewRowAnimationFade];
    break;

  default:
    return;
  }
}

- (void)controller:(NSFetchedResultsController *)controller
    didChangeObject:(id)anObject
        atIndexPath:(NSIndexPath *)indexPath
      forChangeType:(NSFetchedResultsChangeType)type
       newIndexPath:(NSIndexPath *)newIndexPath {
  UITableView *tableView = self.tableView;

  switch (type) {
  case NSFetchedResultsChangeInsert:
    [tableView insertRowsAtIndexPaths:@[ newIndexPath ]
                     withRowAnimation:UITableViewRowAnimationFade];
    break;

  case NSFetchedResultsChangeDelete:
    [tableView deleteRowsAtIndexPaths:@[ indexPath ]
                     withRowAnimation:UITableViewRowAnimationFade];
    break;

  case NSFetchedResultsChangeUpdate:
    [self configureCell:(ArticleDetailsTableViewCell *)
                            [tableView cellForRowAtIndexPath:indexPath]
            atIndexPath:indexPath];
    break;

  case NSFetchedResultsChangeMove:
    [tableView deleteRowsAtIndexPaths:@[ indexPath ]
                     withRowAnimation:UITableViewRowAnimationFade];
    [tableView insertRowsAtIndexPaths:@[ newIndexPath ]
                     withRowAnimation:UITableViewRowAnimationFade];
    break;
  }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  [self.tableView endUpdates];
}

@end
