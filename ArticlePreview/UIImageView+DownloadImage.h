//
//  UIImageView+DownloadImage.h
//  ArticlePreview
//
//  Created by Saket on 22/06/15.
//  Copyright (c) 2015 Saket. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (DownloadImage)

- (void) downloadImageFromURL: (NSString *)url operateWithKey:(NSString *)key;

@property (nonatomic, copy) NSString *imageURL;


@end
