//
//  ArticleDetailstableViewCell.h
//  ArticlePreview
//
//  Created by Saket on 22/06/15.
//  Copyright (c) 2015 Saket. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleDetailsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *articleImageView;
@property (weak, nonatomic) IBOutlet UILabel *publishDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *headlinesLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;

@end
