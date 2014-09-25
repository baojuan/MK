//
//  M3U8Playlist.h
//  M3U8Demo
//
//  Created by 韩傻傻 on 14-3-19.
//  Copyright (c) 2014年 mofang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "M3U8SegmentInfo.h"

@interface M3U8Playlist : NSObject

@property(nonatomic, strong)NSMutableArray *segmentArray;

@property(nonatomic, assign)NSInteger length;

@property(nonatomic, strong)NSString *uuid;


- (id)initWithSegments:(NSMutableArray *)segmentList;

- (M3U8SegmentInfo *)getSegment:(NSInteger) index;

@end
