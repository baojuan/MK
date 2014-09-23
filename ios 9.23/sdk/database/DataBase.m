//
//  DataBase.m
//  MoFangAPP_PVZ
//
//  Created by 韩傻傻 on 13-8-21.
//  Copyright (c) 2013年 鲍娟. All rights reserved.
//

#import "DataBase.h"
static DataBase *singleton_DB=nil;
@implementation DataBase

- (id)init{
    if(self=[super init]){
        _fmDataBase=[FMDatabase databaseWithPath:FILE_PATH(DB_FILENAME)];
        if([_fmDataBase open]){
            [self createTable];
        }
    }
    return self;
}
+ (DataBase *)sharedDataBase{
    if(!singleton_DB){
        singleton_DB=[[DataBase alloc]init];
    }
    return singleton_DB;
}


- (void)createTable{
    NSString *createLeftTable = @"CREATE TABLE IF NOT EXISTS leftTable (serial integer PRIMARY KEY AUTOINCREMENT DEFAULT NULL,typeId TEXT(1024) DEFAULT NULL,title TEXT(1024) DEFAULT NULL,image TEXT(1024) DEFAULT NULL,link TEXT(1024) DEFAULT NULL,sortId TEXT(1024) DEFAULT NULL)";
    
    
    NSArray *tableSql = @[createLeftTable];
    for(NSString *str in tableSql){
        if(![_fmDataBase executeUpdate:str]){
            NSLog(@"create table error:%@",[_fmDataBase lastErrorMessage]);
        }
        NSLog(@"create table success");
    }
}
#pragma mark - left data

- (void)insertData:(NSArray *)array
{
    [self insertDataIntoLeftTable:array];
    if ([array count] > 0) {
        LeftModel *model = array[0];
        [self deleteNoUseModel:array TypeId:model.typeId];

    }
}

- (void)deleteNoUseModel:(NSArray *)array TypeId:(NSString *)typeId
{
    NSArray *arr = [self readLeftTableAllDataFromTypeId:typeId];
    NSMutableArray *deleteArray = [[NSMutableArray alloc] init];
    for (LeftModel *checkModel in arr) {
        BOOL flag = NO;
        for (LeftModel *model in array) {
            if ([checkModel.title isEqualToString:model.title]) {
                flag = YES;
                break;
            }
        }
        if (!flag) {
            [deleteArray addObject:checkModel];
        }
    }
    
    [_fmDataBase beginTransaction];
    for (LeftModel *model in deleteArray) {
        [self deleteDataIntoLeftTable:model];
    }
    [_fmDataBase commit];

}

- (void)insertDataIntoLeftTable:(NSArray *)array
{
    [_fmDataBase beginTransaction];
    for (int i = 0; i < [array count]; i ++) {
        LeftModel *model = [array objectAtIndex:i];
        if (![self readLeftTableFromTitle:model.title typeId:model.typeId]) {
            [self insertDataIntoLeftTableForOneModel:model sortId:[NSString stringWithFormat:@"%2d",i]];
        }
    }
    [_fmDataBase commit];
}

- (void)insertDataIntoLeftTableForOneModel:(LeftModel *)model sortId:(NSString *)sortId
{
    NSString *sql = @"INSERT INTO leftTable (typeId,title,image,link,sortId) VALUES (?,?,?,?,?)";
    if (![_fmDataBase executeUpdate:sql, model.typeId, model.title, model.image, model.link, sortId]) {
        MKLog(@"insert into leftTable error:%@",[_fmDataBase lastErrorMessage]);
    }
}

- (BOOL)readLeftTableFromTitle:(NSString *)title typeId:(NSString *)typeid
{
    NSString *sql=@"SELECT image,link,sortId FROM leftTable WHERE title=? AND typeId=?";
    FMResultSet *rs=[_fmDataBase executeQuery:sql,title,typeid];
    if([rs next]){
        return YES;
    }
    return NO;
}

- (void)updateDataIntoLeftTable:(NSArray *)array
{
    [_fmDataBase beginDeferredTransaction];
    for (int i = 0; i < [array count]; i ++) {
        LeftModel *model = [array objectAtIndex:i];
        [self updateDataIntoLeftTableForOneModel:model sortId:[NSString stringWithFormat:@"%2d",i]];
    }
    [_fmDataBase commit];
}

- (void)updateDataIntoLeftTableForNoComfirm:(NSArray *)array
{
    [_fmDataBase beginDeferredTransaction];
    for (int i = 0; i < [array count]; i ++) {
        LeftModel *model = [array objectAtIndex:i];
        [self updateDataIntoLeftTableForOneModel:model sortId:@"-1"];
    }
    [_fmDataBase commit];

}


- (void)updateDataIntoLeftTableForOneModel:(LeftModel *)model sortId:(NSString *)sortId
{
    NSString *sql=@"UPDATE leftTable SET sortId = ? WHERE title = ?";
    if (![_fmDataBase executeUpdate:sql, sortId, model.title]) {
        MKLog(@"update into leftTable error:%@",[_fmDataBase lastErrorMessage]);
    }
}

- (NSArray *)readLeftTableAllDataFromTypeId:(NSString *)typeId
{
    NSString *sql=@"SELECT title,image,link,sortId FROM leftTable WHERE typeId = ? ORDER BY sortId";
    FMResultSet *rs=[_fmDataBase executeQuery:sql,typeId];
    NSMutableArray *result=[NSMutableArray array];
    while ([rs next]) {
        LeftModel *item=[[LeftModel alloc]init];
        item.title = [rs stringForColumn:@"title"];
        item.image = [rs stringForColumn:@"image"];
        item.link = [rs stringForColumn:@"link"];
        item.typeId = typeId;
        item.sortId = [rs stringForColumn:@"sortId"];
        [result addObject:item];
    }
    return result;
    
}


- (NSArray *)readLeftTableFromTypeId:(NSString *)typeId
{
    NSString *sql=@"SELECT title,image,link,sortId FROM leftTable WHERE typeId = ? AND sortId NOT IN (-1) ORDER BY sortId";
    FMResultSet *rs=[_fmDataBase executeQuery:sql,typeId];
    NSMutableArray *result=[NSMutableArray array];
    while ([rs next]) {
        LeftModel *item=[[LeftModel alloc]init];
        item.title = [rs stringForColumn:@"title"];
        item.image = [rs stringForColumn:@"image"];
        item.link = [rs stringForColumn:@"link"];
        item.typeId = typeId;
        item.sortId = [rs stringForColumn:@"sortId"];
        [result addObject:item];
    }
    return result;

}

- (void)deleteDataIntoLeftTable:(LeftModel *)model
{
    [self updateDataIntoLeftTableForOneModel:model sortId:[NSString stringWithFormat:@"%2d",-1]];
}


#pragma mark - end left data


//- (NSArray *)readCollectTypeDate
//{
//    NSString *sql=[NSString stringWithFormat:@"SELECT idLevelStrategy,specialid,title,style,typeidLevelStrategy,thumb,keywords,descriptionLevelStrategy,url,curl,listorder,useid,username,inputtime,updatetime,searchid,isdata,islink,videoid,short_title FROM collectItem"];
//    FMResultSet *rs=[_fmDataBase executeQuery:sql];
//    NSMutableArray *result=[NSMutableArray array];
//    while ([rs next]) {
//        ModelItem *item=[[ModelItem alloc]init];
//        
//        [result addObject:item];
//    }
//    return result;
//}
//
//
//
//
//
//- (void)insertTopicTypeData:(NSArray *)array{
//    //准备批量插入
//    [_fmDataBase beginTransaction];
//    for (ModelItem *item in array) {
//        [self insertTopicItem:item];
//    }
//    [_fmDataBase commit];
//}
//
//- (void)insertTopicItem:(ModelItem *)item{
//    NSString *sql=[NSString stringWithFormat:@"INSERT INTO levelStrategy (idLevelStrategy,specialid,title,style,typeidLevelStrategy,thumb,keywords,descriptionLevelStrategy,url,curl,listorder,useid,username,inputtime,updatetime,searchid,isdata,islink,videoid,short_title) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];
////    if (![_fmDataBase executeUpdate:sql,item.idLevelStrategy,item.specialid,item.title,item.style,item.typeidLevelStrategy,item.thumb,item.keywords,item.descriptionLevelStrategy,item.url,item.curl,item.listorder,item.useid,item.username,item.inputtime,item.updatetime,item.searchid,item.isdata,item.islink,item.videoid,item.short_title]) {
////        NSLog(@"insert into topic error : %@",[_fmDataBase lastErrorMessage]);
////    }
//}
//
//- (NSArray *)readTopicTypeDate:(NSString *)typeidStrategy{
//    NSString *sql=[NSString stringWithFormat:@"SELECT idLevelStrategy,specialid,title,style,typeidLevelStrategy,thumb,keywords,descriptionLevelStrategy,url,curl,listorder,useid,username,inputtime,updatetime,searchid,isdata,islink,videoid,short_title FROM levelStrategy WHERE typeidLevelStrategy = ?"];
//    FMResultSet *rs=[_fmDataBase executeQuery:sql,typeidStrategy];
//    NSMutableArray *result=[NSMutableArray array];
//    while ([rs next]) {
//        ModelItem *item=[[ModelItem alloc]init];
//        
//        [result addObject:item];
//    }
//    return result;
//}
//
//- (BOOL)queryCollectHaveDateWiteType:(NSString *)idStrategy{
//    NSString *sql=[NSString stringWithFormat:@"SELECT COUNT(*) FROM collectItem WHERE idLevelStrategy=?"];
//    FMResultSet *rs=[_fmDataBase executeQuery:sql,idStrategy];
//    if([rs next]){
//        int count=[rs intForColumn:@"COUNT(*)"];
//        NSLog(@"query item count:%d",count);
//        if(count>0){
//            return YES;
//        }
//    }
//    return NO;
//}
//
//- (BOOL)queryTopicHaveDateWiteType:(NSString *)typeidStrategy{
//    NSString *sql=[NSString stringWithFormat:@"SELECT COUNT(*) FROM levelStrategy WHERE typeidLevelStrategy=?"];
//    FMResultSet *rs=[_fmDataBase executeQuery:sql,typeidStrategy];
//    if([rs next]){
//        int count=[rs intForColumn:@"COUNT(*)"];
//        NSLog(@"query item count:%d",count);
//        if(count>0){
//            return YES;
//        }
//    }
//    return NO;
//}
//
//- (void)deleteCollectData:(NSString *)idLevelStrategy
//{
//    NSString *sql = [NSString stringWithFormat:@"DELETE FROM collectItem WHERE idLevelStrategy=?"];
//    [_fmDataBase executeUpdate:sql,idLevelStrategy];
//}

@end
