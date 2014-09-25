//
//  ShareView.h
//  MKProject
//
//  Created by baojuan on 14-7-10.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleModel.h"
@interface ShareView : UIView
@property (nonatomic, assign) id delegate;
- (id)initForHorizontal:(BOOL)Horizontal;
- (void)getArticleModel:(ArticleModel *)model;
@end
