//
//  PlayViewController.h
//  MKProject
//
//  Created by baojuan on 14-6-28.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleModel.h"

@interface PlayViewController : GAITrackedViewController
@property (nonatomic, strong)    UIButton *playButton;


/**
 *  init
 *
 *  @param array     清晰度URL array
 *  @param islocal   是否本地播放
 *  @param listArray 视频列表
 *  @param item      视频信息
 *  @param page      该刷新第几页
 *  @param nowNumber 视频在列表中第几个
 *  @param isCollect 是否收藏
 *  @param category  属于哪个类
 *
 *  @return return
 */
- (id)initWithUrlArray:(NSArray *)array isLocal:(BOOL)islocal list:(NSArray *)listArray item:(ArticleModel *)item page:(NSInteger)page nowNumber:(NSInteger)nowNumber isCollect:(BOOL)isCollect category:(NSString *)category;

- (void)hiddenShareButton;


- (void)playButtonClick:(UIButton *)button;

@end
