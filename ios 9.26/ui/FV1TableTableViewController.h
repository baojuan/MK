//
//  FV1TableTableViewController.h
//  MKProject
//
//  Created by baojuan on 14-9-25.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FV1TableTableViewController : UITableViewController
@property (nonatomic, assign) int page;
@property (nonatomic, copy) NSString *classTitle;

//type :1最新 16最热
//classTitle url参数之一
- (id)initWithType:(NSString *)type ClassTitle:(NSString *)classTitle Delegate:(UIViewController *)delegate;
- (void)getCenterViewData;

@end
