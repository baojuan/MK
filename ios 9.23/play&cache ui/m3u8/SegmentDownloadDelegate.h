//
//  SegmentDownloadDelegate.h
//  M3U8Demo
//
//  Created by 韩傻傻 on 14-3-19.
//  Copyright (c) 2014年 mofang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SegmentDownloader;
@protocol SegmentDownloadDelegate <NSObject>

@optional
- (void)segmentDownloadFinished:(SegmentDownloader *)request;

- (void)segmentDownloadFailed:(SegmentDownloader *)request;

@end

@class M3U8VideoDownloader;
@protocol VideoDownloadDelegate <NSObject>

@optional
-(void)videoDownloaderFinished:(M3U8VideoDownloader*)request;
-(void)videoDownloaderFailed:(M3U8VideoDownloader*)request;

@end

