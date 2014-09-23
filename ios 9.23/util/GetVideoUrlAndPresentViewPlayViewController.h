//
//  GetVideoUrlAndPresentViewPlayViewController.h
//  MKProject
//
//  Created by baojuan on 14-7-3.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArticleModel.h"


//http://app.hbook.us/flashinterface/getmovieurl.ashx?movieid=31032&typeid=2&level=10


@interface GetVideoUrlAndPresentViewPlayViewController : NSObject

- (void)getItem:(ArticleModel *)item nowNumber:(NSInteger)nowNumber page:(NSInteger)page listArray:(NSArray *)listArray isLocal:(BOOL)isLocal delegate:(id)delegate category:(NSString *)category;

@end
