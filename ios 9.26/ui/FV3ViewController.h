//
//  FV3ViewController.h
//  MKProject
//
//  Created by baojuan on 14-6-16.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

/**
 *  新闻
 */
#import <UIKit/UIKit.h>
#import "GAI.h"

@interface FV3ViewController : GAITrackedViewController
@property (nonatomic, assign) int page;
@property (nonatomic, strong) NSString *navTitle;

+ (NSString *)getTypeId;
- (void)getCenterViewData:(NSString *)title;

@end
