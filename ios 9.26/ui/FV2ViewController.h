//
//  FV2ViewController.h
//  MKProject
//
//  Created by baojuan on 14-6-16.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

/**
 *  图片
 */
#import <UIKit/UIKit.h>
#import "GAI.h"

@interface FV2ViewController : GAITrackedViewController
@property (nonatomic, assign) int page;
@property (nonatomic, strong) NSString *navTitle;

+ (NSString *)getTypeId;
- (void)getCenterViewData:(NSString *)title;

@end
