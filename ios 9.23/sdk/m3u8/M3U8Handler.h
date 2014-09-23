//
//  M3U8Handler.h
//  M3U8Demo
//
//  Created by 韩傻傻 on 14-3-19.
//  Copyright (c) 2014年 mofang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "M3U8Playlist.h"
#import "VideoInfoModel.h"

@class M3U8Handler;
@protocol M3U8HandlerDelegate <NSObject>

@optional

- (void)parseM3U8Finished:(M3U8Handler *)handler;

- (void)parseM3u8Failed:(M3U8Handler *)handler;

@end

@interface M3U8Handler : NSObject

@property(nonatomic, weak) id<M3U8HandlerDelegate> delegate;

@property(nonatomic, strong)M3U8Playlist *playList;
@property (nonatomic, strong)VideoInfoModel *infoItem;

@property (nonatomic, strong) NSString *url;

- (void)parseUrl:(NSString *)urlStr infoItem:(VideoInfoModel *)infoItem;

@end
