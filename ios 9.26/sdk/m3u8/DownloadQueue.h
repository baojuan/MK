//
//  DownloadQueue.h
//  猫咪物语
//
//  Created by 鲍娟 on 14-4-16.
//  Copyright (c) 2014年 et. All rights reserved.
//

#import "ASINetworkQueue.h"

@interface DownloadQueue : ASINetworkQueue
+ (DownloadQueue *)shareQueue;
@end
