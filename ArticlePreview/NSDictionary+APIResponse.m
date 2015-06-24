//
//  NSDictionary+APIResponse.m
//  ArticlePreview
//
//  Created by Saket on 22/06/15.
//  Copyright (c) 2015 Saket. All rights reserved.
//

#import "APConstants.h"
#import "NSDictionary+APIResponse.h"

@implementation NSDictionary (APIResponse)


- (NSDictionary *)metaData {
    NSDictionary *dict = self.getResponseObject[apDMeta];
    return dict;
}


- (NSArray *)articleList {
    return self.getResponseObject[apDdocs];
}


- (NSDictionary *)getResponseObject {
    return self[apDResponse];
}

@end
