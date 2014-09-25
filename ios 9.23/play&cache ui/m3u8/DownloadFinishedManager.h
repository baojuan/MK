//
//  DownloadFinishedManager.h
//  PlayProject
//
//  Created by 鲍娟 on 14-4-9.
//  Copyright (c) 2014年 鲍娟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoInfoModel.h"
@interface DownloadFinishedManager : NSObject
@property (nonatomic, strong)NSMutableArray *finishedArray;//存url
@property (nonatomic, strong)NSMutableDictionary *finishedInfoDictionary;//存info

+ (DownloadFinishedManager *)shareManager;
- (void)addObjectToArrayFullpath:(NSString *)fullpath url:(NSString *)url infoItem:(VideoInfoModel *)infoItem;
- (void)saveIntoAFile:(NSDictionary *)dict;
- (void)deleteVideo:(NSString *)url;

- (BOOL)searchLocationHaveThisFile:(NSString *)url;

@end
