//
//  MKTabbarViewController.h
//  MKProject
//
//  Created by baojuan on 14-6-17.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKTabbar.h"
#import "MKTabbarDelegate.h"
@interface MKTabbarViewController : UITabBarController<MKTabbarDelegate>
@property (nonatomic, strong) MKTabbar *mkTabbar;

@end
