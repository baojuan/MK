//
//  SegmentDownloader.h
//  M3U8Demo
//
//  Created by 韩傻傻 on 14-3-19.
//  Copyright (c) 2014年 mofang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "SegmentDownloadDelegate.h"

typedef enum
{
    ERUNNING=0,
    ESTOPPED=1,
}eTaskStatus;

#define kPathDownload @"Downloads"
#define kTextDownloadingFileSuffix @"_etc"

@interface SegmentDownloader : NSObject<ASIProgressDelegate>

@property(nonatomic ,assign)eTaskStatus status;
@property(nonatomic, weak)id<SegmentDownloadDelegate> delegate;
@property(nonatomic, strong)NSString *fileName;
@property(nonatomic, strong)NSString *filePath;
@property(nonatomic, strong)NSString *tmpFileName;
@property(nonatomic, strong)NSString *downloadUrl;
@property(nonatomic, strong)ASIHTTPRequest *request;

- (void)start:(id)delegate;// Num:(NSInteger)num;

- (void)stop;

- (void)clean;

- (id)initWithUrl:(NSString *)url andFilePath:(NSString *)path andFileName:(NSString *)fileName;

@end
