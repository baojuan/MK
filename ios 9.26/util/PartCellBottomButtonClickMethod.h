//
//  PartCellBottomButtonClickMethod.h
//  MKProject
//
//  Created by baojuan on 14-7-15.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PartCellBottomButtonClickMethod <NSObject>
- (void)partCellBottomButtonShareButtonClick:(UIButton *)button;
- (void)partCellBottomButtonReportButtonClick:(UIButton *)button;
- (void)partCellBottomButtonTalkClick:(UIButton *)button;
- (void)partCellBottomButtonCollectButtonClick:(UIButton *)button;
- (void)partCellBottomButtonGoodButtonClick:(UIButton *)button;

@end
