
#import <Foundation/Foundation.h>
#import "APConstants.h"


const float apSearchBarControllerheight = 44.0;
NSString* const apAPI_KEY = @"3ef6449be84bcd9081a5e9f6050b770c:19:72330647";
NSString* const apArticleSearchCompleteNotification = @"com.saket.ArticlePreview.ArticleSearchComplete";
NSString* const apArticleUpdatedNotitifcation = @"com.saket.ArticlePreview.ArticleUpdated";
NSString* const apMoreArticlesAddedNotification = @"com.saket.ArticlePreview.MoreArticleAdded";
NSString* const apNoInternetConnectivityNotification = @"com.saket.ArticlePreview.noInternetConnectivity";
NSString* const apMainStoryBoardName = @"Main";
NSString* const apDetailViewControllerIdentifier = @"ArticleListView";
NSString* const apRecentlySearchedKeywords = @"Recently Searched Keywords";
NSString* const apAlertViewTitle = @"Alert";
NSString* const apNoInternetConnectivityAlertMessage = @"We are unable to make a internet connection at this time. Some functionality will be limited until a connection is made.";
NSString* const apAlertViewOkButton = @"Ok";
NSString* const apNoURLFound = @"No URL Found";
NSString* const apImageURLPrefix = @"http://static01.nyt.com/";
NSString* const apNoResultsFoundTitle = @"No Results Found";
NSString* const apNoResultsFoundMessage = @"Try searching with some other search term";
NSString* const apArticleDetailViewControllerIdentifier = @"WebView";

//------------------------------------------------------------------
// Query Strings
NSString* const apBaseQuery = @"http://api.nytimes.com/svc/search/v2/articlesearch.json?q=%@&sort=newest&api-key=%@";
NSString* const apQueryForPageNumber = @"http://api.nytimes.com/svc/search/v2/articlesearch.json?q=%@&sort=newest&page=%lu&api-key=%@";


//------------------------------------------------------------------
//NSDictionary Keys

NSString* const apDPublishDate = @"pub_date";
NSString* const apDwebUrl = @"web_url";
NSString* const apDMultimedia = @"multimedia";
NSString* const apDURL = @"url";
NSString* const apDheadline = @"headline";
NSString* const apDLeadParagraph = @"lead_paragraph";
NSString* const apDMain = @"main";
NSString* const apDbyline = @"byline";
NSString* const apDOriginal = @"original";
NSString* const apDMeta = @"meta";
NSString* const apDdocs = @"docs";
NSString* const apDResponse = @"response";
NSString* const apDSnippet = @"snippet";

//------------------------------------------------------------------
// core data entity keywords

// attribute names
NSString* const apArticleLink = @"articleLink";
NSString* const apAuthorName = @"authorName";
NSString* const apHeadline = @"headline";
NSString* const apImageLink = @"imageLink";
NSString* const apKeyword = @"keyword";
NSString* const apLastSearchDate = @"lastSearchDate";
NSString* const apLeadParagraph = @"leadParagraph";
NSString* const apPublishDate = @"publishDate";

// entity names
NSString* const apEntityArticleDetails = @"ArticleDetails";
NSString* const apEntitySearchTerm = @"SearchTerm";


// relationship names
NSString* const apRelationshipSearchTerm = @"searchTerm";
NSString* const apRelationshipArticleDetails = @"articleDetails";

//----------------------------------------------------------------------------------------------------

// for landscape view

NSString* const apHorizonatlSubview =  @"H:|-[_imageView(==200)]-[_paragraphView]-|";
NSString* const apVerticalImageViewSubview = @"V:|-[_imageView]-|";
NSString* const apVerticalParagraphSubview = @"V:|-[_paragraphView]-|";
NSString* const apVerticalMainViewLandscape = @"V:|-(==50)-[_headlinesLabel(==40)]-[_containerView]-|";
NSString* const apHorizontalHeadlineMainLandscape = @"H:|-[_headlinesLabel]-|";
NSString* const apHorizontalSubviewMainlandscape = @"H:|-[_containerView]-|";

//for Potrait view

NSString* const apVerticalPotrait =
@"V:|-(==70)-[_headlinesLabel(>=50)]-[_imageView(<=300)]-[_paragraphView(>=100)]-(>=10)-|";

NSString* const apHorizontalHeadlinePotrait = @"H:|-[_headlinesLabel]-|";
NSString* const apHorizontalImageViewPotrait = @"H:|-[_imageView]-|";
NSString* const apHorizontalParagraphPotrait = @"H:|-[_paragraphView]-|";


