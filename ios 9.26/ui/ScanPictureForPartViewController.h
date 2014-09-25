//
//  ScanPictureForPartViewController.h
//  MKProject
//
//  Created by baojuan on 14-7-15.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleModel.h"

@interface ScanPictureForPartViewController : UIViewController<UIScrollViewDelegate>
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) MKNavigationView *navigationView;
@property (nonatomic, strong) NSString *changyanId;
@property (nonatomic, weak) UIViewController *delegate;
- (id)initWithArray:(NSArray *)array title:(NSString *)title;
- (void)setScrollViewProperty;
- (void)setHeadView;


@end
