//
//  NSDictionary+ArticleDetails.m
//  ArticlePreview
//
//  Created by Saket on 22/06/15.
//  Copyright (c) 2015 Saket. All rights reserved.
//

#import "APConstants.h"
#import "NSDictionary+ArticleDetails.h"

@implementation NSDictionary (ArticleDetails)


- (NSDate *)publishDate {
    
    if (self[apDPublishDate]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-DD'T'HH-mm-ss'Z'"];
        NSDate *publishDate = [dateFormatter dateFromString:self[@"pub_date"]];
        return publishDate;
    }
    NSDate *defaultDate = [NSDate date];
    return defaultDate;
}


- (NSString *)articleLink {
    
    if (self[apDwebUrl]) {
        return self[apDwebUrl];
    }
    return apNoURLFound;
}


- (NSDictionary *)multimediaLinks {
    
    NSArray *multimediaLinks = self[apDMultimedia];
    if([multimediaLinks count]) {
        return multimediaLinks[0];
    }
    else {
        return nil;
    }
    
}


- (NSString *)imageLink {
    
    if (self.multimediaLinks) {
        return self.multimediaLinks[apDURL];
    }
    else {
        return nil;
    }
    
}


- (NSString *)leadParagraph {
    
    NSString *leadParagraph = self[apLeadParagraph];
    NSString *snippet = self[apDSnippet];
    
    if (leadParagraph != (id)[NSNull null]) {
        return leadParagraph;
    }
    else if(snippet != (id)[NSNull null]) {
        return snippet;
    }
    else {
        return @"No details Found";
    };
}


- (NSDictionary *)headlines {
    NSDictionary *headlines = self[apDheadline];
    return headlines;
}


- (NSString *)mainHeadlines {
    
    NSString *mainHeadlines = self.headlines[apDMain];
    return mainHeadlines;

}


- (NSDictionary *)byLine {
    NSDictionary *byLine = self[apDbyline];
    if (byLine != (id)[NSNull null]) {
        if ([byLine count]) {
            return byLine;
        }
        return @{apDOriginal  : @"REUTERS"};
    }
    return @{apDOriginal  : @"REUTERS"};
}


- (NSString *)leadAuthor {
        return self.byLine[apDOriginal];
}

@end
