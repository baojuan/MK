//
//  DataBase.h
//  MoFangAPP_PVZ
//
//  Created by 韩傻傻 on 13-8-21.
//  Copyright (c) 2013年 鲍娟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "LeftModel.h"

@interface DataBase : NSObject{
    FMDatabase *_fmDataBase;
}

//获取当前类的唯一对象
+ (DataBase *)sharedDataBase;


/**
 *  插入左侧数据
 *
 *  @param array array
 */
- (void)insertDataIntoLeftTable:(NSArray *)array;

/**
 *  修改左侧数据  主要是修改sortId
 *
 *  @param array array
 */
- (void)updateDataIntoLeftTable:(NSArray *)array;

/**
 *  修改左侧数据  array中的sortId都为-1
 *
 *  @param array array
 */
- (void)updateDataIntoLeftTableForNoComfirm:(NSArray *)array;



/**
 *  删除左侧列表数据    事实上是把sortId改成-1
 *
 *  @param model model
 *
 */
- (void)deleteDataIntoLeftTable:(LeftModel *)model;

/**
 *  读取typeid 对应的数据
 *
 *  @param typeId typeId
 *
 *  @return array
 */
- (NSArray *)readLeftTableAllDataFromTypeId:(NSString *)typeId;

/**
 *  读取typeId对应的数据 并且把sortId=-1的去掉
 *
 *  @param typeId typeId
 *
 *  @return array
 */
- (NSArray *)readLeftTableFromTypeId:(NSString *)typeId;


- (void)insertData:(NSArray *)array;

////插入收藏
//- (void)insertCollectItem:(ModelItem *)item;
//
////写入各个专题的数据
//- (void)insertTopicTypeData:(NSArray *)array;
//
//
////读取专题数据
//- (NSArray *)readTopicTypeDate:(NSString *)typeidStrategy;
//
////读取收藏数据
//- (NSArray *)readCollectTypeDate;
//
////查询专题是否有数据
//- (BOOL)queryTopicHaveDateWiteType:(NSString *)typeidStrategy;
//
////查询是否收藏
//- (BOOL)queryCollectHaveDateWiteType:(NSString *)typeidStrategy;
//
////删除收藏数据
//- (void)deleteCollectData:(NSString *)idLevelStrategy;
//



@end
