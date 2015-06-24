
//
//  MasterViewController.m
//  ArticlePreview
//
//  Created by Saket on 22/06/15.
//  Copyright (c) 2015 Saket. All rights reserved.
//

#import "APArticleListController.h"
#import "APConstants.h"
#import "APSearchArticleController.h"
#import "APSearchForArticles.h"
#import "APSaveArticles.h"
#import "NSDictionary+APIResponse.h"

@interface APSearchArticleController ()

@property(nonatomic, strong) UISearchController *searchController;
@property(nonatomic, strong) NSMutableArray *searchResults;
@property(nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property(nonatomic, strong) NSString *searchTerm;

- (void)addSearchController;
- (void)initializeActivityIndicator;
- (void)startActivityIndicator;
- (void)stopActivityIndicator;
- (void)presentDetailViewControllerForSearchTerm:(NSString *)searchTerm;
- (void)noInternetConnectivity;
- (void)noResultsFound;

@end

@implementation APSearchArticleController

// ********************************************************************************************************
#pragma mark -
#pragma mark - Lifecycle Methods

- (void)awakeFromNib {
  [super awakeFromNib];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self addSearchController];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(articleSearchComplete:)
             name:apArticleSearchCompleteNotification
           object:nil];
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(noInternetConnectivity)
             name:apNoInternetConnectivityNotification
           object:nil];
  [self initializeActivityIndicator];
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

// ********************************************************************************************************
#pragma mark -
#pragma mark - Private Methods

- (void)addSearchController {

  self.searchController =
      [[UISearchController alloc] initWithSearchResultsController:nil];
  self.searchController.searchBar.frame =
      CGRectMake(self.searchController.searchBar.frame.origin.x,
                 self.searchController.searchBar.frame.origin.y,
                 self.searchController.searchBar.frame.size.width,
                 apSearchBarControllerheight);
  self.tableView.tableHeaderView = self.searchController.searchBar;
  self.searchController.searchResultsUpdater = self;
  self.searchController.searchBar.delegate = self;
  self.definesPresentationContext = YES; // may not be required. Check.
}

- (void)initializeActivityIndicator {
  _activityIndicator = [[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  _activityIndicator.frame = self.view.frame;
  _activityIndicator.center = self.view.center;
  [_activityIndicator hidesWhenStopped];
  [_activityIndicator.layer
      setBackgroundColor:[[UIColor colorWithWhite:0.0f alpha:0.30f] CGColor]];
  [self.view addSubview:_activityIndicator];
}

- (void)presentDetailViewControllerForSearchTerm:(NSString *)searchTerm {
  UIStoryboard *storyboard =
      [UIStoryboard storyboardWithName:apMainStoryBoardName bundle:nil];
  APArticleListController *apArticleListController = (APArticleListController *)
      [storyboard instantiateViewControllerWithIdentifier:
                      apDetailViewControllerIdentifier];
  apArticleListController.searchTerm = searchTerm;
  apArticleListController.managedObjectContext = self.managedObjectContext;
  [self.navigationController pushViewController:apArticleListController
                                       animated:YES];
}

- (void)startActivityIndicator {
  [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
  [_activityIndicator startAnimating];
}

- (void)stopActivityIndicator {
  [_activityIndicator stopAnimating];
  [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

- (void)noResultsFound {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self stopActivityIndicator];
    UIAlertView *noResultFound =
        [[UIAlertView alloc] initWithTitle:apNoResultsFoundTitle
                                   message:apNoResultsFoundMessage
                                  delegate:self
                         cancelButtonTitle:apAlertViewOkButton
                         otherButtonTitles:nil];
    [noResultFound show];
  });
}

//*****************************************************************************************************
#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([[segue identifier] isEqualToString:@"showDetail"]) {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSManagedObject *object =
        [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [[segue destinationViewController]
        setManagedObjectContext:self.managedObjectContext];
    [[segue destinationViewController]
        setSearchTerm:[object valueForKey:apKeyword]];
  }
}

//*****************************************************************************************************
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  if (self.searchController.active) {
    return [self.searchResults count];
  } else {
    return [self.fetchedResultsController.fetchedObjects count];
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                      forIndexPath:indexPath];

  if (indexPath.row % 2) {
    [cell setBackgroundColor:
              [UIColor colorWithRed:1.0 green:0.6 blue:0.2 alpha:1]];
  } else {
    [cell setBackgroundColor:
              [UIColor colorWithRed:1.0 green:0.8 blue:0.6 alpha:1]];
  }

  if (self.searchController.active && [self.searchResults count]) {
    cell.textLabel.text =
        [self.searchResults[indexPath.row] valueForKey:apKeyword];
    return cell;
  } else {
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
  }
}

- (BOOL)tableView:(UITableView *)tableView
    canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  // Return NO if you do not want the specified item to be editable.
  return YES;
}

- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    NSManagedObjectContext *context =
        [self.fetchedResultsController managedObjectContext];
    [context deleteObject:[self.fetchedResultsController
                              objectAtIndexPath:indexPath]];

    NSError *error = nil;
    if (![context save:&error]) {
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
  }
}

- (void)configureCell:(UITableViewCell *)cell
          atIndexPath:(NSIndexPath *)indexPath {
  if (self.fetchedResultsController.fetchedObjects.count != 0) {
    NSManagedObject *object =
        [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [object valueForKey:apKeyword];
    cell.detailTextLabel.text =
        [[object valueForKey:apLastSearchDate] description];
  }
}

//**********************************************************************************************************
#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:
        (UISearchController *)searchController {

  NSString *searchString = [self.searchController.searchBar text];
  NSString *scope = nil;
  [self updateFilteredContentForArticle:searchString type:scope];
  [self.tableView reloadData];
}

- (void)updateFilteredContentForArticle:(NSString *)articleName
                                   type:(NSString *)typeName {

  [self.searchResults removeAllObjects];
  if ((articleName == nil) || [articleName length] == 0) {
    self.searchResults = [NSMutableArray
        arrayWithArray:self.fetchedResultsController.fetchedObjects];
  } else {
    NSPredicate *predicate = [NSPredicate
        predicateWithFormat:@"SELF.keyword contains[c] %@", articleName];
    self.searchResults = [NSMutableArray
        arrayWithArray:[self.fetchedResultsController.fetchedObjects
                           filteredArrayUsingPredicate:predicate]];
  }
}

//**********************************************************************************************************
#pragma mark - UISearchResultsUpdating

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  _searchTerm = [[NSString alloc] initWithString:[searchBar text]];
  [searchBar resignFirstResponder];
  if (![self.searchResults containsObject:self.searchTerm] &&
      searchBar.text != nil) {
    [self startActivityIndicator];
    [[APSearchForArticles alloc] initwithSearchText:searchBar.text
                                      updateArticle:false];
  }
  [self.searchController setActive:NO];
}

// ********************************************************************************************************
#pragma mark - NSNotification Observer Methods

- (void)articleSearchComplete:(NSNotification *)notification {
  NSDictionary *responeDictionary = [notification userInfo];
  if ([responeDictionary isKindOfClass:[NSDictionary class]] &&
      [[responeDictionary articleList] count] != 0) {
    APSaveArticles *saveArticle = [[APSaveArticles alloc] init];
    saveArticle.managedObjectContext = self.managedObjectContext;
    dispatch_async(dispatch_get_main_queue(), ^{
      [saveArticle saveNewArticles:responeDictionary forSearchTerm:_searchTerm];
      [self stopActivityIndicator];
      [self presentDetailViewControllerForSearchTerm:self.searchTerm];
    });
  } else if ([[responeDictionary articleList] count] == 0) {
    [self noResultsFound];
  }
}

- (void)noInternetConnectivity {

  [self stopActivityIndicator];
  UIAlertView *alertView =
      [[UIAlertView alloc] initWithTitle:apAlertViewTitle
                                 message:apNoInternetConnectivityAlertMessage
                                delegate:self
                       cancelButtonTitle:apAlertViewOkButton
                       otherButtonTitles:nil];
  [alertView show];
}

//**********************************************************************************************************
#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
  if (_fetchedResultsController != nil) {
    return _fetchedResultsController;
  }

  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  // Edit the entity name as appropriate.
  NSEntityDescription *entity =
      [NSEntityDescription entityForName:apEntitySearchTerm
                  inManagedObjectContext:self.managedObjectContext];
  [fetchRequest setEntity:entity];

  // Set the batch size to a suitable number.
  [fetchRequest setFetchBatchSize:20];

  // Edit the sort key as appropriate.
  NSSortDescriptor *sortDescriptor =
      [[NSSortDescriptor alloc] initWithKey:apLastSearchDate ascending:NO];
  NSArray *sortDescriptors = @[ sortDescriptor ];

  [fetchRequest setSortDescriptors:sortDescriptors];

  // Edit the section name key path and cache name if appropriate.
  // nil for section name key path means "no sections".
  NSFetchedResultsController *aFetchedResultsController =
      [[NSFetchedResultsController alloc]
          initWithFetchRequest:fetchRequest
          managedObjectContext:self.managedObjectContext
            sectionNameKeyPath:nil
                     cacheName:@"Master"];
  aFetchedResultsController.delegate = self;
  self.fetchedResultsController = aFetchedResultsController;

  NSError *error = nil;
  if (![self.fetchedResultsController performFetch:&error]) {
    // Replace this implementation with code to handle the error appropriately.
    // abort() causes the application to generate a crash log and terminate. You
    // should not use this function in a shipping application, although it may
    // be useful during development.
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
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
    [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
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
