//
//  M3U8Handler.m
//  M3U8Demo
//
//  Created by 韩傻傻 on 14-3-19.
//  Copyright (c) 2014年 mofang. All rights reserved.
//

#import "M3U8Handler.h"
#define EXTINF_NODE @"#EXTINF:"

@implementation M3U8Handler

@synthesize delegate=_delegate;
@synthesize playList=_playList;

- (void)parseUrl:(NSString *)urlStr infoItem:(VideoInfoModel *)infoItem
{
    self.url = urlStr;
    self.infoItem = infoItem;
    NSRange range = [urlStr rangeOfString:@"m3u8"];
    if(range.length <= 0){
        NSLog(@" Invalid url");
        if(_delegate!=nil && [_delegate respondsToSelector:@selector(parseM3u8Failed:)]){
            [_delegate parseM3u8Failed:self];
        }
        return;
    }
    
    NSURL *url=[[NSURL alloc]initWithString:urlStr];
    NSError *error=nil;
    NSStringEncoding encoding;
    NSString *data=[[NSString alloc]initWithContentsOfURL:url usedEncoding:&encoding error:&error];
    
    if(!data){
        NSLog(@"data is nil");
        if (_delegate !=nil && [_delegate respondsToSelector:@selector(parseM3u8Failed:)]){
            [_delegate parseM3u8Failed:self];
        }
        return;
    }
    
    NSMutableArray *segments=[[NSMutableArray alloc]init];
    NSString *remainData=data;
    NSRange segmentRange=[remainData rangeOfString:EXTINF_NODE];
    while (segmentRange.location!=NSNotFound) {
        M3U8SegmentInfo *segment=[[M3U8SegmentInfo alloc]init];
        
        //获取片段时长
        NSRange commRange=[remainData rangeOfString:@","];
        NSString *value=[remainData substringWithRange:
                         NSMakeRange(segmentRange.location + EXTINF_NODE.length,
                                      commRange.location -(segmentRange.location+EXTINF_NODE.length))];
        segment.duration=[value intValue];
        
        //读取片段url
        remainData=[remainData substringFromIndex:commRange.location];
        NSRange lingRangeBegin=[remainData rangeOfString:@"http"];
        NSRange lingRangeEnd=[remainData rangeOfString:@"#"];
        NSString *linkUrl=[remainData substringWithRange:NSMakeRange(lingRangeBegin.location, lingRangeEnd.location-lingRangeBegin.location)];
        segment.locationUrl=linkUrl;
        
        
        [segments addObject:segment];
        remainData=[remainData substringFromIndex:lingRangeEnd.location];
        segmentRange=[remainData rangeOfString:EXTINF_NODE];
    }
    _playList=[[M3U8Playlist alloc]initWithSegments:segments];
    if(_delegate!=nil && [_delegate respondsToSelector:@selector(parseM3U8Finished:)]){
        [_delegate parseM3U8Finished:self];
    }
}
@end
