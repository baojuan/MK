//
//  SegmentView.h
//  PlayProject
//
//  Created by 鲍娟 on 14-4-4.
//  Copyright (c) 2014年 鲍娟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentView : UIView

@property (nonatomic, strong)NSArray *buttonArray;

- (id)initWithFrame:(CGRect)frame buttonArray:(NSArray *)array;

//style 1 用于下载缓存界面
//style 0 用于播放历史界面
//- (id)initWithFrame:(CGRect)frame buttonArray:(NSArray *)array Style:(NSInteger)style;

@end
