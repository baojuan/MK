//
//  M3U8VideoDownloader.m
//  M3U8Demo
//
//  Created by 韩傻傻 on 14-3-19.
//  Copyright (c) 2014年 mofang. All rights reserved.
//

#import "M3U8VideoDownloader.h"
#import "DownloadQueue.h"
@implementation M3U8VideoDownloader
{
    NSMutableArray *tempArray;
}
@synthesize downloadArray=_downloadArray,playList=_playList,totalprogress=_totalprogress,
delegate=_delegate,bDownloading=_bDownloading;

- (id)initWithM3U8List:(M3U8Playlist *)list url:(NSString *)url
{
    if(self == [super init]){
        _playList=list;
        _totalprogress=0.0;
        self.url = url;
        tempArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)startDownloadVideo{
    NSLog(@"start Download video");
    if(_downloadArray == nil)
    {
        _downloadArray = [[NSMutableArray alloc]init];
        for(int i = 0;i< _playList.length;i++)
        {
            NSString* filename = [NSString stringWithFormat:@"id%d",i];
            M3U8SegmentInfo* segment = [_playList getSegment:i];
            SegmentDownloader* sgDownloader = [[SegmentDownloader alloc]initWithUrl:segment.locationUrl andFilePath:_playList.uuid andFileName:filename];
            sgDownloader.delegate = self;
            [_downloadArray addObject:sgDownloader];
        }
        self.totalNumber = [_downloadArray count];
    }
    for(SegmentDownloader* obj in _downloadArray)
    {
        [obj start:self.delegate];
        self.scanNumber ++;
    }
    _bDownloading = YES;
    
//     [[DownloadQueue shareQueue] setSuspended:NO];
}

-(void)pauseDownloadVideo
{
    NSLog(@"stop Download Video");
    if(_bDownloading && _downloadArray != nil)
    {
        for(SegmentDownloader *obj in _downloadArray)
        {
            [obj stop];
        }
        _bDownloading = NO;
    }
}

-(void)cancelDownloadVideo
{
    NSLog(@"cancel download video");
    if(_bDownloading && _downloadArray != nil)
    {
        for(SegmentDownloader *obj in _downloadArray)
        {
            [obj clean];
        }
    }
    [self cleanDownloadFiles];
}


- (void)cleanDownloadFiles{
    NSLog(@"cleanDownloadFiles");
    
    
    for(int i = 0;i< _playList.length;i++)
    {
        NSString* filename = [NSString stringWithFormat:@"id%d",i];
        NSString* tmpfilename = [filename stringByAppendingString:kTextDownloadingFileSuffix];
        NSString *pathPrefix = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) objectAtIndex:0];
        NSString *savePath = [[pathPrefix stringByAppendingPathComponent:kPathDownload] stringByAppendingPathComponent:_playList.uuid];
        NSString* fullpath = [savePath stringByAppendingPathComponent:filename];
        NSString* fullpath_tmp = [savePath stringByAppendingPathComponent:tmpfilename];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        
        if ([fileManager fileExistsAtPath:fullpath]) {
            NSError *removeError = nil;
            [fileManager removeItemAtPath:fullpath error:&removeError];
            if (removeError)
            {
                NSLog(@"delete file=%@ err, err is %@",fullpath,removeError);
            }
        }
        
        if ([fileManager fileExistsAtPath:fullpath_tmp]) {
            NSError *removeError = nil;
            [fileManager removeItemAtPath:fullpath_tmp error:&removeError];
            if (removeError)
            {
                NSLog(@"delete file=%@ err, err is %@",fullpath_tmp,removeError);
            }
        }
        
    }

}

- (CGFloat)getSpeedForUrl
{
    return [ASIHTTPRequest averageBandwidthUsedPerSecond];
}




#pragma mark - SegmentDownloadDelegate
-(void)segmentDownloadFailed:(SegmentDownloader *)request
{
    NSLog(@"a segment Download Failed");
    
    if(_delegate && [_delegate respondsToSelector:@selector(videoDownloaderFailed:)])
    {
        [_delegate videoDownloaderFailed:self];
    }
}

-(void)segmentDownloadFinished:(SegmentDownloader *)request
{
    NSLog(@"a segment Download Finished");
    
    
    if (self.scanNumber == self.totalNumber) {
        if ([tempArray count] != 0) {
            [self removeAll];
        }
        [_downloadArray removeObject:request];

    }
    else
    {
        [tempArray addObject:request];
    }
    if([_downloadArray count] == 0)
    {
        _totalprogress = 1;
        NSLog(@"all the segments downloaded. video download finished");
        if(_delegate && [_delegate respondsToSelector:@selector(videoDownloaderFinished:)])
        {
            [_delegate videoDownloaderFinished:self];
        }
    }
}

- (void)removeAll
{
    for (SegmentDownloader *downloader in tempArray) {
        [_downloadArray removeObject:downloader];
    }
    [tempArray removeAllObjects];
    tempArray = Nil;
}

#define M3U8_HEAD @"#EXTM3U\n#EXT-X-TARGETDURATION:30\n#EXT-X-VERSION:2\n#EXT-X-DISCONTINUITY\n"
#define M3U8_TAIL @"#EXT-X-ENDLIST"
-(NSString*)createLocalM3U8File:(NSString *)filename
{
    if(_playList !=nil)
    {
        NSString *pathPrefix = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) objectAtIndex:0];
        NSString *saveTo = [[pathPrefix stringByAppendingPathComponent:kPathDownload] stringByAppendingPathComponent:_playList.uuid];
        NSString *fullpath = [saveTo stringByAppendingPathComponent:filename];
        NSLog(@"createLocalM3U8file:%@",fullpath);
        
        //创建文件头部
        NSString* head = M3U8_HEAD;
        
        NSString* segmentPrefix = [NSString stringWithFormat:@"http://127.0.0.1:12345/%@/",_playList.uuid];
        //填充片段数据
        for(int i = 0;i< _playList.length;i++)
        {
            NSString* filename = [NSString stringWithFormat:@"id%d",i];
            M3U8SegmentInfo* segInfo = [_playList getSegment:i];
            NSString* length = [NSString stringWithFormat:@"#EXTINF:%ld,\n",(long)segInfo.duration];
            NSString* url = [segmentPrefix stringByAppendingString:filename];
            head = [NSString stringWithFormat:@"%@%@%@\n",head,length,url];
        }
        //创建尾部
        NSString* end = @"#EXT-X-ENDLIST";
        head = [head stringByAppendingString:end];
        NSMutableData *writer = [[NSMutableData alloc] init];
        [writer appendData:[head dataUsingEncoding:NSUTF8StringEncoding]];
        
        BOOL bSucc =[writer writeToFile:fullpath atomically:YES];
        if(bSucc)
        {
            NSLog(@"create m3u8file succeed; fullpath:%@, content:%@",fullpath,head);
            return  fullpath;
        }
        else
        {
            NSLog(@"create m3u8file failed");
            return  nil;
        }
    }
    return nil;
}



@end
