//
//  M3U8Manager.m
//  PlayProject
//
//  Created by 鲍娟 on 14-4-3.
//  Copyright (c) 2014年 鲍娟. All rights reserved.
//

#import "M3U8Manager.h"
#import "NSString+Hashing.h"
#import "DownloadFinishedManager.h"

static M3U8Manager * gl_manager = Nil;

@implementation M3U8Manager

+ (M3U8Manager *)sharedManager
{
    if (gl_manager == Nil) {
        gl_manager = [[M3U8Manager alloc] init];
    }
    return gl_manager;
}

- (id)init
{
    if (self = [super init]) {
        self.downloadDictionary = [[NSMutableDictionary alloc] init];
        self.allTaskArray = [[NSMutableArray alloc] init];
        self.deleteArray = [[NSMutableArray alloc] init];
        self.finishNumber = 0;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteArrayBegin) name:@"deleteBegin" object:Nil];
    }
    return self;
}

- (void)addTargetForUrl:(NSString *)url name:(NSString *)name category:(NSString *)category
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        M3U8Handler* m_handler;
        m_handler =  [[M3U8Handler alloc]init];
        m_handler.delegate = self;
        
        VideoInfoModel *item = [[VideoInfoModel alloc] init];
        item.name = name;
        item.category = category;
        item.url = url;
        
        [m_handler parseUrl:url infoItem:item];
    });
}

- (void)parseM3U8Finished:(M3U8Handler *)handler
{
    NSLog(@"parse finished");
    M3U8VideoDownloader* m_downloader;
    handler.playList.uuid = [handler.url MD5Hash];//建立的文件夹名称
    m_downloader = [[M3U8VideoDownloader alloc]initWithM3U8List:handler.playList url:handler.url];
    m_downloader.delegate = self;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0",@"state",m_downloader,@"downloader",handler.infoItem,@"infoItem",nil];//0表示开始 1表示暂停
    [self.downloadDictionary setObject:dict forKey:handler.url];
    [self.allTaskArray addObject:handler.url];
    if (self.finishNumber == 0) {
        [self OnClickStartDownload:handler.url];
        self.finishNumber = 1;
    }
    
}

- (void)parseM3u8Failed:(M3U8Handler *)handler{
    NSLog(@"parseM3u8Failed");
}


-(void)OnClickStartDownload:(NSString *)url
{
    M3U8VideoDownloader *downloader = [[self.downloadDictionary objectForKey:url] objectForKey:@"downloader"];
    self.nowDownloading = downloader;
    NSLog(@"click start");
    if(downloader)
    {
        [downloader startDownloadVideo];
    }
}

-(void)OnClickStopDownload:(NSString *)url
{
    M3U8VideoDownloader *downloader = [[self.downloadDictionary objectForKey:url] objectForKey:@"downloader"];
    if(downloader)
    {
        [downloader pauseDownloadVideo];
        self.finishNumber = 0;
    }
}


-(void)videoDownloaderFinished:(M3U8VideoDownloader*)request
{
    self.finishNumber = 0;
    NSString *url = request.url;
    NSString *m3u8url = [request createLocalM3U8File:[NSString stringWithFormat:@"%@.m3u8",[url MD5Hash]]];
    
    VideoInfoModel *item = [[self.downloadDictionary objectForKey:url] objectForKey:@"infoItem"];

    [[DownloadFinishedManager shareManager] addObjectToArrayFullpath:m3u8url url:url infoItem:item];
    
    
    [self.downloadDictionary removeObjectForKey:url];
    [self.allTaskArray removeObject:request.url];
    
    NSString *beginUrl = [self startTask];
    [self OnClickStartDownload:beginUrl];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DownLoadFinished" object:Nil];
}


- (NSString *)startTask
{
    for (NSString *url in self.allTaskArray) {
        NSMutableDictionary *dict = [[M3U8Manager sharedManager].downloadDictionary objectForKey:url];
        if ([[dict objectForKey:@"state"] isEqualToString:@"0"]) {
            return url;
        }
    }
    return Nil;
}


- (void)setProgress:(float)newProgress
{
    _progress = newProgress;
    NSLog(@"newprogress :%f",newProgress);
    if (newProgress >= 1) {
        self.nowDownloading.finishNumber ++;
        self.finishNumber ++;
    }
}


- (CGFloat)getProgress:(NSString *)url
{
    M3U8VideoDownloader *downloader = [[self.downloadDictionary objectForKey:url] objectForKey:@"downloader"];

    if (downloader.totalNumber == 0) {
        return 0;
    }
    
    return ((downloader.finishNumber) * 1.0 /downloader.totalNumber) * 100;
}

- (CGFloat)getSpeedFromUrl:(NSString *)url
{
    M3U8VideoDownloader *downloader = [[self.downloadDictionary objectForKey:url] objectForKey:@"downloader"];
    return [downloader getSpeedForUrl];
}


- (void)deleteArrayBegin
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (NSString *url in self.deleteArray) {
            
            M3U8VideoDownloader *downloader = [[self.downloadDictionary objectForKey:url] objectForKey:@"downloader"];

            [downloader cancelDownloadVideo];
            
            [[M3U8Manager sharedManager].downloadDictionary removeObjectForKey:downloader.url];
        }
        [self.deleteArray removeAllObjects];
    });
}

- (void)addObjectToDownloadingArray:(NSArray *)array
{
    for (NSString *url in array) {
        NSDictionary *dict = [self.downloadDictionary objectForKey:url];
        if ([[dict objectForKey:@"state"] isEqualToString:@"1"]) {
            NSMutableDictionary *dd = [[NSMutableDictionary alloc] initWithDictionary:dict];
            [dd setObject:@"0" forKey:@"state"];
        }
    }
}
- (NSInteger)getNowDownloadingIndex
{
    return [self.allTaskArray indexOfObject:self.nowDownloading.url];
}

- (NSMutableDictionary *)getDictionaryFromDownloadDictionaryBasedUrl:(NSString *)url
{
    return [self.downloadDictionary objectForKey:url];
}


@end
