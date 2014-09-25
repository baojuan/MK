//
//  CommentViewController.h
//  MKProject
//
//  Created by baojuan on 14-7-6.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : GAITrackedViewController
- (id)initWithArticle:(ArticleModel *)item articleId:(NSString *)articleId;
@end
