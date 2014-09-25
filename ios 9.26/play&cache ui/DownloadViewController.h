//
//  DownloadViewController.h
//  PlayProject
//
//  Created by 鲍娟 on 14-4-4.
//  Copyright (c) 2014年 鲍娟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#define SCREEN ([UIScreen mainScreen].bounds.size)
#define SCREEN_EXTRA_HEIGHT (UIScreen mainScreen].bounds.size.height - 480.0f)
#define EXTRA_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue]>=7?20.0f:0.0f)




@interface DownloadViewController : UIViewController
@property (strong, nonatomic) AppDelegate *appDelegate;

@end
