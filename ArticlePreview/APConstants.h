//
//  APConstants.h
//  ArticlePreview
//
//  Created by Saket on 22/06/15.
//  Copyright (c) 2015 Saket. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef ArticlePreview_APConstants_h
#define ArticlePreview_APConstants_h

extern const float apSearchBarControllerheight;
extern NSString* const apAPI_KEY;
extern NSString* const apArticleSearchCompleteNotification;
extern NSString* const apArticleUpdatedNotitifcation;
extern NSString* const apMoreArticlesAddedNotification;
extern NSString* const apNoInternetConnectivityNotification;
extern NSString* const apMainStoryBoardName;
extern NSString* const apDetailViewControllerIdentifier;
extern NSString* const apRecentlySearchedKeywords;
extern NSString* const apAlertViewTitle;
extern NSString* const apNoInternetConnectivityAlertMessage;
extern NSString* const apAlertViewOkButton;
extern NSString* const apNoURLFound;
extern NSString* const apImageURLPrefix;
extern NSString* const apNoResultsFoundTitle;
extern NSString* const apNoResultsFoundMessage;
extern NSString* const apArticleDetailViewControllerIdentifier;
//------------------------------------------------------------------
// Query Strings
extern NSString* const apBaseQuery;
extern NSString* const apQueryForPageNumber;

//------------------------------------------------------------------
//NSDictionary Keys

extern NSString* const apDPublishDate;
extern NSString* const apDwebUrl;
extern NSString* const apDMultimedia;
extern NSString* const apDURL;
extern NSString* const apDheadline;
extern NSString* const apDLeadParagraph;
extern NSString* const apDMain;
extern NSString* const apDbyline;
extern NSString* const apDOriginal;
extern NSString* const apDMeta;
extern NSString* const apDdocs;
extern NSString* const apDResponse;
extern NSString* const apDSnippet;

//------------------------------------------------------------------
// core data entity keywords

// attribute names
extern NSString* const apArticleLink;
extern NSString* const apAuthorName;
extern NSString* const apHeadline;
extern NSString* const apImageLink;
extern NSString* const apKeyword;
extern NSString* const apLastSearchDate;
extern NSString* const apLeadParagraph;
extern NSString* const apPublishDate;

// entity names
extern NSString* const apEntityArticleDetails;
extern NSString* const apEntitySearchTerm;


// relationship names
extern NSString* const apRelationshipSearchTerm;
extern NSString* const apRelationshipArticleDetails;


//------------------------------------------------------------------
//

extern NSString* const apHorizonatlSubview;
extern NSString* const apVerticalImageViewSubview;
extern NSString* const apVerticalParagraphSubview;
extern NSString* const apVerticalMainViewLandscape;
extern NSString* const apHorizontalHeadlineMainLandscape;
extern NSString* const apHorizontalSubviewMainlandscape;


extern NSString* const apVerticalPotrait;
extern NSString* const apHorizontalHeadlinePotrait;
extern NSString* const apHorizontalImageViewPotrait;
extern NSString* const apHorizontalParagraphPotrait;

#endif