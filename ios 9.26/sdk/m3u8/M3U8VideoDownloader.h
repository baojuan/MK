//
//  M3U8VideoDownloader.h
//  M3U8Demo
//
//  Created by 韩傻傻 on 14-3-19.
//  Copyright (c) 2014年 mofang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SegmentDownloader.h"
#import "M3U8Playlist.h"

@interface M3U8VideoDownloader : NSObject<SegmentDownloadDelegate>

@property(nonatomic, strong)NSMutableArray *downloadArray;
@property(nonatomic, strong)M3U8Playlist *playList;
@property(nonatomic, assign)float totalprogress;
@property(nonatomic, weak)id<VideoDownloadDelegate> delegate;
@property(nonatomic, assign)BOOL bDownloading;
@property (nonatomic, strong)NSString *url;
@property (nonatomic, assign)NSInteger totalNumber;
@property (nonatomic, assign)NSInteger finishNumber;



@property (nonatomic, assign)NSInteger scanNumber;
- (id)initWithM3U8List:(M3U8Playlist *)list url:(NSString *)url;

//开始下载
- (void)startDownloadVideo;

//暂停下载
- (void)pauseDownloadVideo;

//取消下载
- (void)cancelDownloadVideo;

- (NSString *)createLocalM3U8File:(NSString *)filename;

- (CGFloat)getSpeedForUrl;

@end
