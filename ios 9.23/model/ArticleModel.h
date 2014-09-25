//
//  ArticleModel.h
//  MKProject
//
//  Created by baojuan on 14-6-27.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleModel : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *articleId;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *video_count;
@property (nonatomic, strong) NSString *video_length;
@property (nonatomic, strong) NSString *fromUrl;
@property (nonatomic, strong) NSString *fromUrlName;
@property (nonatomic, strong) NSString *field1;
@property (nonatomic, strong) NSString *field2;
@property (nonatomic, strong) NSString *field3;
@property (nonatomic, strong) NSString *goodNumber;
@property (nonatomic, strong) NSString *commentNumber;
@property (nonatomic, assign) BOOL isgood;
@property (nonatomic, assign) BOOL isRead;



@end
