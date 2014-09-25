//
//  UIView+ReportView.m
//  MKProject
//
//  Created by baojuan on 14-8-14.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "UIView+ReportView.h"

@implementation UIView (ReportView)
- (void)appearReportView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"不良信息举报" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"不实信息",@"敏感信息",@"淫秽色情",@"抄袭内容", nil];
    alert.delegate = self;
    [alert show];
}
- (void)reportForIndex:(NSInteger)index
{
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

@end
