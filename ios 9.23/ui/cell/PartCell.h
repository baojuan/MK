//
//  PartCell.h
//  MKProject
//
//  Created by baojuan on 14-7-14.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PartCellBottomView.h"
@interface PartCell : UITableViewCell
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *dataLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) PartCellBottomView *bottomView;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) UIImageView *playImageView;
@property (nonatomic, strong) UIImageView *placeholderImageView;
@property (nonatomic, strong) UIImageView *picstateImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier ForBig:(BOOL)big;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Simple:(BOOL)simple;

- (void)insertIntoDataToPartCell:(ArticleModel *)item;

- (void)setTagWithButtons:(NSInteger)tag;

@end
