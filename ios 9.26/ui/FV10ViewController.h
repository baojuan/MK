//
//  FV10ViewController.h
//  MKProject
//
//  Created by baojuan on 14-6-16.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

/**
 *  段子
 */
#import <UIKit/UIKit.h>

@interface FV10ViewController : GAITrackedViewController
@property (nonatomic, assign) int page;
@property (nonatomic, strong) NSString *navTitle;

+ (NSString *)getTypeId;
- (void)getCenterViewData:(NSString *)title;
@end
