//
//  GetVideoUrlAndPresentViewPlayViewController.m
//  MKProject
//
//  Created by baojuan on 14-7-3.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "GetVideoUrlAndPresentViewPlayViewController.h"
#import "PlayViewController.h"
@implementation GetVideoUrlAndPresentViewPlayViewController
{
    ArticleModel *playVideoItem;
    NSInteger playVideoNumber;
    BOOL islocal;
    NSArray *array;
    __weak UIViewController * playDelegate;
    NSInteger playPage;
    NSString *playCategory;
}

- (void)getItem:(ArticleModel *)item nowNumber:(NSInteger)nowNumber page:(NSInteger)page listArray:(NSArray *)listArray isLocal:(BOOL)isLocal delegate:(id)delegate category:(NSString *)category
{
    playCategory = category;
    playVideoItem = item;
    playVideoNumber = nowNumber;
    array = listArray;
    islocal = isLocal;
    playDelegate = delegate;
    playPage = page;

    UrlRequest *request = [[UrlRequest alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/flashinterface/getmovieurl.ashx?movieid=%@&typeid=2&level=10",HOST,item.articleId];
    [request urlRequestWithGetUrl:url delegate:self finishMethod:@"finishVideoMethod:" failMethod:@"failVideoMethod:"];
}


- (void)finishVideoMethod:(NSData *)data
{
    NSArray *arr = [[[NSUserDefaults standardUserDefaults] objectForKey:COLLECT_USERDEFAULT] objectForKey:LOCAL_LANGUAGE(@"video")];
    BOOL isCollect = NO;
    for (NSDictionary *dd in arr) {
        if ([playVideoItem.articleId isEqualToString: [dd objectForKey:@"articleId"]]) {
            isCollect = YES;
            break;
        }
    }
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *aa = [string componentsSeparatedByString:@"^"];
    if ([aa count] < 2 && (!islocal)) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:APPDELEGATE.mainNavigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"该视频暂时无法播放";
        [hud hide:YES afterDelay:1];
        return;
    }
    else {
        PlayViewController *playViewController = [[PlayViewController alloc] initWithUrlArray:aa isLocal:islocal list:array item:playVideoItem page:playPage nowNumber:playVideoNumber isCollect:isCollect category:playCategory];
        [playDelegate presentViewController:playViewController animated:YES completion:^{
            ;
        }];

    }
}

- (void)failVideoMethod:(NSError *)error
{
    MKLog(@"error:%@",error);
}


@end
