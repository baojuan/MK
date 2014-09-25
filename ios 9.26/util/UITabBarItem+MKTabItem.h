//
//  UITabBarItem+MKTabItem.h
//  MKProject
//
//  Created by baojuan on 14-7-6.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarItem (MKTabItem)
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *title;
- (void)setSelectedImage:(UIImage *)selectedImage UnSelectedImage:(UIImage *)unselectedImage Title:(NSString *)title;
- (void)isSelect:(BOOL)isSelect;
@end
