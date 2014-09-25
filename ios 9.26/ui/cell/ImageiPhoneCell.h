//
//  ImageiPhoneCell.h
//  MKProject
//
//  Created by baojuan on 14-6-21.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageiPhoneCell : UITableViewCell
@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) BOOL isSpecial;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier ForSmall:(BOOL)small;

@end
