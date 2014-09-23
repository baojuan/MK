//
//  CommentCell.h
//  MKProject
//
//  Created by baojuan on 14-7-6.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *date;
@property (nonatomic, strong) UILabel *comment;
@property (nonatomic, strong) UILabel *commentGoodNumberLabel;
@property (nonatomic, strong) UIImageView *commentGoodImageView;

@property (nonatomic, assign) int score;

- (void)insertIntoDataIcon:(NSURL *)urlImage name:(NSString *)name date:(NSString *)date comment:(NSString *)comment score:(int)score;

@end
