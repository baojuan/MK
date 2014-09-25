//
//  SegmentDownloader.m
//  M3U8Demo
//
//  Created by 韩傻傻 on 14-3-19.
//  Copyright (c) 2014年 mofang. All rights reserved.
//

#import "SegmentDownloader.h"
#import "DownloadQueue.h"

@implementation SegmentDownloader

@synthesize delegate=_delegate,fileName=_fileName,
filePath=_filePath,tmpFileName=_tmpFileName,downloadUrl=_downloadUrl,request=_request;

- (id)initWithUrl:(NSString *)url andFilePath:(NSString *)path andFileName:(NSString *)fileName{
    if(self==[super init]){
        _downloadUrl=url;
        _fileName=fileName;
        _filePath=path;
        
        NSString *pathPrefix = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) objectAtIndex:0];
        NSString *saveTo = [[pathPrefix stringByAppendingPathComponent:kPathDownload] stringByAppendingPathComponent:_filePath];
        NSString *downloadingFileName = [[NSString alloc] initWithString:[saveTo stringByAppendingPathComponent:[fileName stringByAppendingString:kTextDownloadingFileSuffix]]] ;
        
        _tmpFileName=downloadingFileName;
        BOOL isDir=NO;
        
        NSFileManager *fm=[NSFileManager defaultManager];
        if(!([fm fileExistsAtPath:saveTo isDirectory:&isDir] && isDir)){
            [fm createDirectoryAtPath:saveTo withIntermediateDirectories:YES attributes:nil error:nil];
        }
        _status=ESTOPPED;
    }
    return self;
}

- (void)start:(id)delegate// Num:(NSInteger)num
{
    
    NSLog(@"download segment start, fileName = %@,url = %@",self.fileName,self.downloadUrl);
    _request= [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[self.downloadUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    _request.shouldContinueWhenAppEntersBackground = YES;
    [_request setThreadPriority:0.0];
    
    [_request setTemporaryFileDownloadPath: self.tmpFileName];
    
    NSString *pathPrefix = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    NSString *saveTo = [[pathPrefix stringByAppendingPathComponent:kPathDownload] stringByAppendingPathComponent:self.filePath];
    [_request setDownloadDestinationPath:[saveTo stringByAppendingPathComponent:self.fileName]];
    [_request setDelegate:self];
    [_request setDownloadProgressDelegate:delegate];
    _request.allowResumeForFileDownloads = YES;
    [_request setNumberOfTimesToRetryOnTimeout:2];
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setValue:[NSString stringWithFormat:@"%d",num] forKey:@"name"];
//    [_request setUserInfo:dic];
    [_request startAsynchronous];
   
//    [[DownloadQueue shareQueue] addOperation:_request];

  
    _status = ERUNNING;
}

- (void)stop{
    NSLog(@"download stoped");
    if(_request && _status == ERUNNING)
    {
        _request.delegate = nil;
        [_request cancelAuthentication];
    }
    _status = ESTOPPED;
}

-(void)clean
{
    NSLog(@"download clean");
    if(_request && _status == ERUNNING)
    {
        _request.delegate = nil;
        [_request cancelAuthentication];
        [_request removeTemporaryDownloadFile];
        NSError *Error = nil;
        if (![ASIHTTPRequest removeFileAtPath:[_request downloadDestinationPath] error:&Error]) {
            NSLog(@"clean file err:%@",Error);
        }
    }
    _status = ESTOPPED;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"download finished!");
    if(_delegate && [_delegate respondsToSelector:@selector(segmentDownloadFinished:)])
    {
        [_delegate segmentDownloadFinished:self];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)aRequest
{
    NSError *err = aRequest.error;
    if (err.code != 3)
    {
        [self stop];
        NSLog(@"Download failed.");
        if(_delegate && [_delegate respondsToSelector:@selector(segmentDownloadFailed:)])
        {
            [_delegate segmentDownloadFailed:self];
        }
    }
}

@end


