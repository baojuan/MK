//
//  LeftViewController.h
//  MKProject
//
//  Created by baojuan on 14-6-17.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
//- (void)firstGetDataArray;
- (void)firstGetDataArray:(NSDictionary *)dict;

@end
