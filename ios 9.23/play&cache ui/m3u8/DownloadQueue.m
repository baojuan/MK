//
//  DownloadQueue.m
//  猫咪物语
//
//  Created by 鲍娟 on 14-4-16.
//  Copyright (c) 2014年 et. All rights reserved.
//

#import "DownloadQueue.h"
static DownloadQueue *gl_queue = Nil;
@implementation DownloadQueue

+ (DownloadQueue *)shareQueue
{
    if (!gl_queue) {
        gl_queue = [[DownloadQueue alloc] init];
        gl_queue.maxConcurrentOperationCount = 2;
    }
    return gl_queue;
}

@end
