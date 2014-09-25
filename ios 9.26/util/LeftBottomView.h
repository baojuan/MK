//
//  LeftBottomView.h
//  MKProject
//
//  Created by baojuan on 14-8-16.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftBottomView : UIView
@property (nonatomic, assign) id delegate;

@property (nonatomic, strong) UIButton *historyButton;
@property (nonatomic, strong) UIButton *collectionButton;
@property (nonatomic, strong) UIButton *subscriptionButton;
@property (nonatomic, strong) UIButton *sortButton;
@property (nonatomic, strong) UIButton *searchButton;


- (void)sortButtonState:(BOOL)selected;

@end
