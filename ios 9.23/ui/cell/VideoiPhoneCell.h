//
//  VideoiPhoneCell.h
//  MKProject
//
//  Created by baojuan on 14-6-21.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoiPhoneCell : UITableViewCell
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *duringLabel;
@property (nonatomic, strong) UILabel *playCountLabel;
@property (nonatomic, strong) UILabel *dateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier ForSmall:(BOOL)small ForRight:(BOOL)right;
@end
