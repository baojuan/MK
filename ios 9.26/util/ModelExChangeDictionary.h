//
//  ModelExChangeDictionary.h
//  MKProject
//
//  Created by baojuan on 14-7-4.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArticleModel.h"



@interface ModelExChangeDictionary : NSObject

/**
 *  将model转换成dictionary
 *
 *  @param model model
 *
 *  @return dictionary
 */
+ (NSDictionary *)modelChangeToDictionary:(ArticleModel *)model;

/**
 *  将dictionary转换成model
 *
 *  @param dict dict
 *
 *  @return model
 */
+ (ArticleModel *)dictionaryChangeToModel:(NSDictionary *)dict;


/**
 *  存播放历史
 *
 *  @param model model
 *  @param typeid 视频|图片|新闻|段子
 */
+ (void)modelIntoUserDefaultToHistory:(ArticleModel *)model Typeid:(NSString *)typeId;


/**
 *  存阅读过的model
 *
 *  @param model model
 *  @param typeid 视频|图片|新闻|段子
 */
+ (void)modelIntoUserDefaultToRead:(ArticleModel *)model Typeid:(NSString *)typeId;

/**
 *  判断文章是否读过
 *
 *  @param articleId id
 *  @param typeId typeId 视频|图片|新闻|段子
 *
 *  @return boolean
 */
+ (BOOL)modelIsInUserDefaultToRead:(NSString *)articleId Typeid:(NSString *)typeId;

@end
