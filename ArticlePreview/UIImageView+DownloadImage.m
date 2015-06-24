//
//  UIImageView+DownloadImage.m
//  ArticlePreview
//
//  Created by Saket on 22/06/15.
//  Copyright (c) 2015 Saket. All rights reserved.
//

#import "UIImageView+DownloadImage.h"
#import "APConstants.h"

#import <objc/runtime.h>

static char URL_KEY;

@implementation UIImageView (DownloadImage)

@dynamic imageURL;

- (void)downloadImageFromURL:(NSString *)url operateWithKey:(NSString *)keyString {
    
    self.imageURL = url;
    
    UIImage* image = [UIImage imageWithContentsOfFile:[self getImageSearchPathWithKey:keyString]];
    if (image != nil) {
        self.imageURL   = nil;
        self.image = image;
    }
    else {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_async(queue, ^{
            NSString* completeUrl = [apImageURLPrefix
                                     stringByAppendingString:url];
            
            NSData *data = [NSData dataWithContentsOfURL:
                            [NSURL URLWithString:completeUrl]];
            
            UIImage *imageFromData = [UIImage imageWithData:data];
            
            [self saveImageToDiskWithKey:keyString withImage:imageFromData];
            
            if (imageFromData) {
                if ([self.imageURL isEqualToString:url]) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        self.image = imageFromData;
                    });
                } else {
                    NSLog(@"url are not matching!! Cannot proceed");
                }
            }
            self.imageURL = nil;
        });
    }
}

- (NSString *)getImageSearchPathWithKey: (NSString *)keyString {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:keyString];
    return path;
}

- (void)saveImageToDiskWithKey: (NSString *)keyString withImage:(UIImage *)image {
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    [imageData writeToFile:[self getImageSearchPathWithKey:keyString] atomically:YES];
    
}


- (void) setImageURL:(NSURL *)newImageURL {
    objc_setAssociatedObject(self, &URL_KEY, newImageURL, OBJC_ASSOCIATION_COPY);
}

- (NSURL*) imageURL {
    return objc_getAssociatedObject(self, &URL_KEY);
}


@end
