//
//  FV4ViewController.h
//  MKProject
//
//  Created by baojuan on 14-6-16.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

/**
 *  淘宝
 */
#import <UIKit/UIKit.h>
#import "GAI.h"

@interface FV4ViewController : GAITrackedViewController
@property (nonatomic, strong) NSString *navTitle;

+ (NSString *)getTypeId;
@property (nonatomic, strong) NSString *url;
- (id)initWithUrl:(NSString *)url;
- (void)getCenterViewUrl:(NSString *)url;

@end
