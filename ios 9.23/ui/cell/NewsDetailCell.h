//
//  NewsDetailCell.h
//  MKProject
//
//  Created by baojuan on 14-8-3.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewsDetailCellDelegate <NSObject>

- (void)refreshCellAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface NewsDetailCell : UITableViewCell
@property (nonatomic, weak)id <NewsDetailCellDelegate> delegate;
@property (nonatomic, strong) UIImageView *detailImageView;
@property (nonatomic, strong) UILabel *detailLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier ForPad:(BOOL)forPad;


- (void)insertIntoData:(NSMutableDictionary *)dict complete:(void(^)(void))success;

- (void)insertIntoDataComplete:(NSMutableDictionary *)dict complete:(void(^)(void))success;

@end
