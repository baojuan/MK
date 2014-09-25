//
//  M3U8Playlist.m
//  M3U8Demo
//
//  Created by 韩傻傻 on 14-3-19.
//  Copyright (c) 2014年 mofang. All rights reserved.
//

#import "M3U8Playlist.h"

@implementation M3U8Playlist

@synthesize segmentArray=_segmentArray;
@synthesize length=_length;
@synthesize uuid=_uuid;

- (id)initWithSegments:(NSMutableArray *)segmentList{
    if(self==[super init]){
        _segmentArray=segmentList;
        _length=[segmentList count];
    }
    return self;
}

- (M3U8SegmentInfo *)getSegment:(NSInteger)index{
    if(index>=0 && index<_length){
        return (M3U8SegmentInfo *)[_segmentArray objectAtIndex:index];
    }
    else
    {
        return nil;
    }
}

@end
