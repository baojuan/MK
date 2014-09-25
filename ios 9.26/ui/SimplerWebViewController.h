//
//  SimplerWebViewController.h
//  MKProject
//
//  Created by baojuan on 14-7-11.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimplerWebViewController : GAITrackedViewController
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *navTitle;
- (id)initWithUrl:(NSString *)url title:(NSString *)title;

@end
