//
//  ScanPictureView.h
//  ImageScanViewController
//
//  Created by 鲍娟 on 14-7-2.
//  Copyright (c) 2014年 鲍娟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleModel.h"
@interface ScanPictureView : UIView<UIScrollViewDelegate>
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) MKNavigationView *navigationView;
@property (nonatomic, strong) NSString *changyanId;
@property (nonatomic, weak) UIViewController *delegate;
- (id)initWithUrl:(NSString *)string rect:(CGRect)rect ArticleModel:(ArticleModel *)model;
- (void)setScrollViewProperty;
- (void)setHeadView;

- (void)viewAnimationComplete;


@end
