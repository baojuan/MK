//
//  ModelExChangeDictionary.m
//  MKProject
//
//  Created by baojuan on 14-7-4.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "ModelExChangeDictionary.h"
#import "FV1ViewController.h"
#import "FV2ViewController.h"
#import "FV3ViewController.h"




@implementation ModelExChangeDictionary

+ (NSDictionary *)modelChangeToDictionary:(ArticleModel *)model
{
    return @{@"title": [ModelExChangeDictionary judgeStringIsNil:model.title], @"image": [ModelExChangeDictionary judgeStringIsNil:model.image], @"articleId": [ModelExChangeDictionary judgeStringIsNil:model.articleId], @"date":[ModelExChangeDictionary judgeStringIsNil:model.date], @"detail": [ModelExChangeDictionary judgeStringIsNil:model.detail], @"link": [ModelExChangeDictionary judgeStringIsNil:model.link],@"video_count":[ModelExChangeDictionary judgeStringIsNil:model.video_count],@"video_length":[ModelExChangeDictionary judgeStringIsNil:model.video_length],@"fromUrl":[ModelExChangeDictionary judgeStringIsNil:model.fromUrl],@"fromUrlName":[ModelExChangeDictionary judgeStringIsNil:model.fromUrlName],@"field1":[ModelExChangeDictionary judgeStringIsNil:model.field1],@"field2":[ModelExChangeDictionary judgeStringIsNil:model.field2],@"field3":[ModelExChangeDictionary judgeStringIsNil:model.field3],@"goodNumber":[ModelExChangeDictionary judgeStringIsNil:model.goodNumber],@"commentNumber":[ModelExChangeDictionary judgeStringIsNil:model.commentNumber]};

}

+ (ArticleModel *)dictionaryChangeToModel:(NSDictionary *)dict
{
    ArticleModel *item = [[ArticleModel alloc] init];
    item.title = [dict objectForKey:@"title"];
    item.image = [dict objectForKey:@"image"];
    item.articleId = [dict objectForKey:@"articleId"];
    item.date = [dict objectForKey:@"date"];
    item.detail = [dict objectForKey:@"detail"];
    item.link = [dict objectForKey:@"link"];
    item.video_count = [dict objectForKey:@"video_count"];
    item.video_length = [dict objectForKey:@"video_length"];
    item.fromUrl = [dict objectForKey:@"fromUrl"];
    item.fromUrlName = [dict objectForKey:@"fromUrlName"];
    item.field1 = [dict objectForKey:@"field1"];
    item.field2 = [dict objectForKey:@"field2"];
    item.field3 = [dict objectForKey:@"field3"];
    item.goodNumber = [dict objectForKey:@"goodNumber"];
    item.commentNumber = [dict objectForKey:@"commentNumber"];
    return item;
}

+ (NSString *)judgeStringIsNil:(NSString *)string
{
    if (!string) {
        return @"";
    }
    else {
        return string;
    }
}


+ (void)modelIntoUserDefaultToHistory:(ArticleModel *)model Typeid:(NSString *)typeId
{
    NSDictionary *dict = [ModelExChangeDictionary modelChangeToDictionary:model];
    NSMutableDictionary *userdefault = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:HISTORY_USERDEFAULT]];
    NSString *key;
    if ([typeId isEqualToString:[FV1ViewController getTypeId]]) {
        key = LOCAL_LANGUAGE(@"video");
    }
    if ([typeId isEqualToString:[FV2ViewController getTypeId]]) {
        key = LOCAL_LANGUAGE(@"picture");
    }
    if ([typeId isEqualToString:[FV3ViewController getTypeId]]) {
        key = LOCAL_LANGUAGE(@"news");
    }
    if ([typeId isEqualToString:[FV10ViewController getTypeId]]) {
        key = LOCAL_LANGUAGE(@"part");
    }
    NSArray *aa = [userdefault objectForKey:key];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:aa];
    for (NSDictionary *dd in aa) {
        if ([[dict objectForKey:@"articleId"] isEqualToString:[dd objectForKey:@"articleId"]]) {
            return;
        }
    }
    [array addObject:dict];
    [userdefault setObject:array forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:userdefault forKey:HISTORY_USERDEFAULT];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)modelIntoUserDefaultToRead:(ArticleModel *)model Typeid:(NSString *)typeId
{
    NSMutableDictionary *userdefault = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:READ_USERDEFAULT]];
    NSString *key;
    if ([typeId isEqualToString:[FV1ViewController getTypeId]]) {
        key = LOCAL_LANGUAGE(@"video");
    }
    if ([typeId isEqualToString:[FV2ViewController getTypeId]]) {
        key = LOCAL_LANGUAGE(@"picture");
    }
    if ([typeId isEqualToString:[FV3ViewController getTypeId]]) {
        key = LOCAL_LANGUAGE(@"news");
    }
    if ([typeId isEqualToString:[FV10ViewController getTypeId]]) {
        key = LOCAL_LANGUAGE(@"part");
    }
    NSDictionary *aa = [userdefault objectForKey:key];
    NSMutableDictionary *dd = [[NSMutableDictionary alloc] initWithDictionary:aa];
    [dd setObject:@"1" forKey:model.articleId];
    [userdefault setObject:dd forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:userdefault forKey:READ_USERDEFAULT];
    [[NSUserDefaults standardUserDefaults] synchronize];

}


+ (BOOL)modelIsInUserDefaultToRead:(NSString *)articleId Typeid:(NSString *)typeId
{
    NSDictionary *userdefault = [[NSUserDefaults standardUserDefaults] objectForKey:READ_USERDEFAULT];
    NSString *key;
    if ([typeId isEqualToString:[FV1ViewController getTypeId]]) {
        key = LOCAL_LANGUAGE(@"video");
    }
    if ([typeId isEqualToString:[FV2ViewController getTypeId]]) {
        key = LOCAL_LANGUAGE(@"picture");
    }
    if ([typeId isEqualToString:[FV3ViewController getTypeId]]) {
        key = LOCAL_LANGUAGE(@"news");
    }
    if ([typeId isEqualToString:[FV10ViewController getTypeId]]) {
        key = LOCAL_LANGUAGE(@"part");
    }
    if ([[[userdefault objectForKey:key] objectForKey:articleId] length] > 0) {
        return YES;
    }
    else {
        return NO;
    }
}


@end
