//
//  M3U8Manager.h
//  PlayProject
//
//  Created by 鲍娟 on 14-4-3.
//  Copyright (c) 2014年 鲍娟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "M3U8Handler.h"
#import "M3U8VideoDownloader.h"

@interface M3U8Manager : NSObject<M3U8HandlerDelegate,VideoDownloadDelegate>

@property (nonatomic, strong)NSMutableDictionary *downloadDictionary;//对应的详细信息
@property (nonatomic, strong)NSMutableArray *allTaskArray;//array 中存的是url
@property(nonatomic ,assign)float progress;
@property (nonatomic, assign)NSInteger finishNumber;
@property (nonatomic, strong)NSMutableArray *deleteArray;
@property (nonatomic, weak)M3U8VideoDownloader *nowDownloading;//正在下载的downloader

+ (M3U8Manager *)sharedManager;

-(void)OnClickStartDownload:(NSString *)url;
-(void)OnClickStopDownload:(NSString *)url;

- (CGFloat)getProgress:(NSString *)url;

- (void)addTargetForUrl:(NSString *)url name:(NSString *)name category:(NSString *)category;

- (CGFloat)getSpeedFromUrl:(NSString *)url;

- (void)addObjectToDownloadingArray:(NSArray *)array;

- (NSInteger)getNowDownloadingIndex;

- (NSString *)startTask;

- (NSMutableDictionary *)getDictionaryFromDownloadDictionaryBasedUrl:(NSString *)url;

@end
