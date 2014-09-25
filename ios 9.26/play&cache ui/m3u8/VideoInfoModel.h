//
//  VideoInfoModel.h
//  PlayProject
//
//  Created by 鲍娟 on 14-4-10.
//  Copyright (c) 2014年 鲍娟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoInfoModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *videoSpace;

+ (VideoInfoModel *)changeDictToModel:(NSDictionary *)dict;
+ (NSDictionary *)changeModelToDict:(VideoInfoModel *)model;


@end
