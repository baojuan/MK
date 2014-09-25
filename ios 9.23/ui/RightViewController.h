//
//  RightViewController.h
//  MKProject
//
//  Created by baojuan on 14-6-17.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
- (void)tableViewSelectWhichViewControllerIndexPath:(NSIndexPath *)indexPath;
- (void)setType;

@end
