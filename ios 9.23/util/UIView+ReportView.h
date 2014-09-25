//
//  UIView+ReportView.h
//  MKProject
//
//  Created by baojuan on 14-8-14.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ReportView)<UIAlertViewDelegate>
- (void)appearReportView;
- (void)reportForIndex:(NSInteger)index;
@end
