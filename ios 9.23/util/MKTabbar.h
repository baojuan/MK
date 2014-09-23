//
//  MKTabbar.h
//  MKProject
//
//  Created by baojuan on 14-7-6.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKTabbarDelegate.h"

@interface MKTabbar : UITabBar

@property(nonatomic,weak) id<MKTabbarDelegate> tabbarDelegate;

- (void)setViewControllers:(NSArray *)array;

@end
