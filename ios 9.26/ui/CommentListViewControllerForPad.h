//
//  CommentListViewControllerForPad.h
//  MKProject
//
//  Created by baojuan on 14-7-10.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentListViewControllerForPad : GAITrackedViewController
- (id)initWithArticle:(ArticleModel *)item articleId:(NSString *)articleId;
@property (nonatomic, assign) BOOL isPresent;

@end
