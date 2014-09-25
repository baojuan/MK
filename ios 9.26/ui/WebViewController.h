//
//  WebViewController.h
//  MKProject
//
//  Created by baojuan on 14-6-28.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleModel.h"
@interface WebViewController : GAITrackedViewController
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *articleId;
@property (nonatomic, strong) NSString *navTitle;
- (id)initWithUrl:(NSString *)url articleId:(NSString *)articleId title:(NSString *)title ArticleModel:(ArticleModel *)model;
- (id)initWithUrl:(NSString *)url articleId:(NSString *)articleId title:(NSString *)title ArticleModel:(ArticleModel *)model fromUrl:(BOOL)fromUrl;
- (void)hiddenShareButton;

@end
