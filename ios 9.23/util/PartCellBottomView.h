//
//  PartCellBottomView.h
//  MKProject
//
//  Created by baojuan on 14-7-15.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PartCellBottomButtonClickMethod.h"
#import "PartBottomButton.h"
@interface PartCellBottomView : UIView
@property (nonatomic, strong) PartBottomButton *goodButton;
@property (nonatomic, strong) PartBottomButton *talkButton;
@property (nonatomic, strong) UIButton *collectButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *reportButton;

@property (nonatomic, assign) id <PartCellBottomButtonClickMethod> delegate;

@property (nonatomic, strong) NSString *changyanId;

- (id)initWithSimple:(BOOL)simple;

- (void)insertIntoDataGoodNumber:(NSString *)goodNumber commentNumber:(NSString *)commentNumber isCollect:(BOOL)isCollect;


@end
