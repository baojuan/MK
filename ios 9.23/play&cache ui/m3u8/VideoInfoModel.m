//
//  VideoInfoModel.m
//  PlayProject
//
//  Created by 鲍娟 on 14-4-10.
//  Copyright (c) 2014年 鲍娟. All rights reserved.
//

#import "VideoInfoModel.h"

@implementation VideoInfoModel

+ (NSDictionary *)changeModelToDict:(VideoInfoModel *)model
{
    return [NSDictionary dictionaryWithObjectsAndKeys:model.name,@"name",model.category,@"category",model.url,@"url",nil];
}
+ (VideoInfoModel *)changeDictToModel:(NSDictionary *)dict
{
    VideoInfoModel *model = [[VideoInfoModel alloc] init];
    model.name = [dict objectForKey:@"name"];
    model.category = [dict objectForKey:@"category"];
    model.url = [dict objectForKey:@"url"];
    return model;
}

@end
