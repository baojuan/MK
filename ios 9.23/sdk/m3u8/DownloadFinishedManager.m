//
//  DownloadFinishedManager.m
//  PlayProject
//
//  Created by 鲍娟 on 14-4-9.
//  Copyright (c) 2014年 鲍娟. All rights reserved.
//

#import "DownloadFinishedManager.h"
#import "NSString+Hashing.h"

#define UserDefaultForDownloadVideoInfoArrayName @"videoDownload"


static DownloadFinishedManager *gl_manager = Nil;
@implementation DownloadFinishedManager

+ (DownloadFinishedManager *)shareManager
{
    if (!gl_manager) {
        gl_manager = [[DownloadFinishedManager alloc] init];
    }
    return gl_manager;
}

- (id)init
{
    if (self = [super init]) {
        self.finishedArray = [[NSMutableArray alloc] init];
        self.finishedInfoDictionary = [[NSMutableDictionary alloc] init];
        [self getArrayFromUserDefault];
    }
    return self;
}

- (void)getArrayFromUserDefault
{
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultForDownloadVideoInfoArrayName];
    if ([array count]) {
        for (NSDictionary *dict in array) {
            VideoInfoModel *item = [VideoInfoModel changeDictToModel:[dict objectForKey:@"infoItem"]];
            NSMutableDictionary *dd = [NSMutableDictionary dictionaryWithDictionary:dict];
            [dd setObject:item forKey:@"infoItem"];
            [self.finishedArray addObject:item.url];
            [self.finishedInfoDictionary setObject:dd forKey:item.url];
        }
    }
}

- (void)addObjectToArrayFullpath:(NSString *)fullpath url:(NSString *)url infoItem:(VideoInfoModel *)infoItem
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"http://127.0.0.1:12345/%@/%@.m3u8",[url MD5Hash],[url MD5Hash]] forKey:[url MD5Hash]];
    
    [self.finishedArray addObject:url];
    
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:fullpath, @"fullpath", [self getFileCache:fullpath],@"totalCached",infoItem,@"infoItem",nil];
    
    [[DownloadFinishedManager shareManager].finishedInfoDictionary setObject:dict forKey:url];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{//将下载好的保存到本地
        [self saveIntoAFile:dict];
    });

}

- (NSString *)getFileCache:(NSString *)fullPath
{
    NSString *string;
    NSError *error;
    NSDictionary* dictFile = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:&error];
    if (error)
    {
        NSLog(@"getfilesize error: %@", error);
        return NO;
    }
    unsigned long long nFileSize = [dictFile fileSize]; //得到文件大小
    if (nFileSize > 1024) {
        nFileSize = nFileSize / 1024;
        if (nFileSize > 1024) {
            nFileSize = nFileSize / 1024;
            if (nFileSize > 1024) {
                nFileSize = nFileSize / 1024;
                if (nFileSize > 1024) {
                    nFileSize = nFileSize / 1024;
                    string = [NSString stringWithFormat:@"%lluG",nFileSize];
                }
            }
            else
            {
                string = [NSString stringWithFormat:@"%lluM",nFileSize];
            }
        }
        else
        {
            string = [NSString stringWithFormat:@"%lluK",nFileSize];
        }
    }
    else
    {
        string = [NSString stringWithFormat:@"%lluB",nFileSize];
    }
    return string;
}

- (void)saveIntoAFile:(NSDictionary *)dict
{
    //userdefault 的key 是 UserDefaultForDownloadVideoInfoArrayName
    //结构是最外层为array 每个array其中是dict
    //dict里面的key有fullpath、totalCached、infoItem
    //其中infoItem是dict类型 其他都是string
    //infoItem是由VideoInfoModel生成的dict
    
    VideoInfoModel *item = [dict objectForKey:@"infoItem"];
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultForDownloadVideoInfoArrayName]];
    
    NSMutableDictionary *saveDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    
    [saveDict setObject:[VideoInfoModel changeModelToDict:item] forKey:@"infoItem"];
    [array addObject:saveDict];
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:UserDefaultForDownloadVideoInfoArrayName];
    
}

- (void)deleteVideo:(NSString *)url
{
    NSDictionary *deleteDict;
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultForDownloadVideoInfoArrayName]];
    for (NSDictionary *dict in array) {
        NSString *uurl = [[dict objectForKey:@"infoItem"] objectForKey:@"url"];
        if ([uurl isEqualToString:url]) {
            [[NSFileManager defaultManager] removeItemAtPath:[dict objectForKey:@"fullpath"] error:Nil];//删除文件
            deleteDict = dict;
            break;
        }
    }
    [array removeObject:deleteDict];
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:UserDefaultForDownloadVideoInfoArrayName];
    
    
    [self.finishedInfoDictionary removeObjectForKey:url];
    [self.finishedArray removeObject:url];
    
}

- (BOOL)searchLocationHaveThisFile:(NSString *)url
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultForDownloadVideoInfoArrayName]];

    for (NSDictionary *dict in array) {
        NSString *uurl = [[dict objectForKey:@"infoItem"] objectForKey:@"url"];
        if ([uurl isEqualToString:url]) {
            return YES;
        }
    }
    return NO;
}

@end
