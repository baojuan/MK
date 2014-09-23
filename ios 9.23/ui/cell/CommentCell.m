//
//  CommentCell.m
//  MKProject
//
//  Created by baojuan on 14-7-6.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell
{
    UIImageView *scoreImageView;
    UIImageView *scoreBackgroundImageView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            self.frame = RECT(0, 0, 1026 / 2.0 - 200 - 10, 44);

        }
        else {
            self.frame = RECT(0, 0, SCREEN_WIDTH, 44);

        }
        
        self.icon = [[UIImageView alloc] initWithFrame:RECT(10, 10, 28, 28)];
        [self.contentView addSubview:self.icon];
        
        self.name = [[UILabel alloc] initWithFrame:RECT(10 + self.icon.frame.size.width + self.icon.frame.origin.x, 10, 200, 20)];
        self.name.font = FONTBOLDSIZE(14);
        self.name.backgroundColor = [UIColor clearColor];
        self.name.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.name];
        
        
        scoreBackgroundImageView = [[UIImageView alloc] initWithImage:IMAGENAMED(@"commentstar1")];
        scoreBackgroundImageView.frame = RECT(self.name.frame.origin.x + self.name.frame.size.width, self.name.frame.origin.y + 3, scoreBackgroundImageView.frame.size.width, scoreBackgroundImageView.frame.size.height);
        [self.contentView addSubview:scoreBackgroundImageView];
        
        
        
        scoreImageView = [[UIImageView alloc] init];
        scoreImageView.frame = RECT(self.name.frame.origin.x + self.name.frame.size.width, self.name.frame.origin.y, scoreBackgroundImageView.frame.size.width, scoreBackgroundImageView.frame.size.height);
        scoreImageView.clipsToBounds = YES;
        [self.contentView addSubview:scoreImageView];
        
        
        UIImageView *ii = [[UIImageView alloc] initWithImage:IMAGENAMED(@"commentstar")];
        ii.frame = RECT(0, 0, scoreImageView.frame.size.width, scoreImageView.frame.size.height);
        [scoreImageView addSubview:ii];
        
        
        self.date = [[UILabel alloc] initWithFrame:RECT(10 + self.icon.frame.size.width + self.icon.frame.origin.x, self.name.frame.origin.y + self.name.frame.size.height, 200, 20)];
        self.date.font = FONTSIZE(11);
        self.date.backgroundColor = [UIColor clearColor];
        self.date.textColor = RGBCOLOR(147, 147, 147);
        [self.contentView addSubview:self.date];
        
        
        self.comment = [[UILabel alloc] initWithFrame:RECT(10, self.date.frame.size.height + self.date.frame.origin.y + 10, self.frame.size.width - 20, 20)];
        self.comment.font = FONTSIZE(15);
        self.comment.numberOfLines = 0;
        self.comment.backgroundColor = [UIColor clearColor];
        self.comment.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.comment];
        
        self.commentGoodImageView = [[UIImageView alloc] initWithImage:IMAGENAMED(@"commentgood1")];
        self.commentGoodImageView.frame = RECT(self.frame.size.width - self.commentGoodImageView.frame.size.width - 10, scoreImageView.frame.origin.y, self.commentGoodImageView.frame.size.width, self.commentGoodImageView.frame.size.height);
        [self.contentView addSubview:self.commentGoodImageView];
        
        self.commentGoodNumberLabel = [[UILabel alloc] initWithFrame:RECT(self.commentGoodImageView.frame.origin.x - 30, self.commentGoodImageView.frame.origin.y, 30, self.commentGoodImageView.frame.size.height)];
        self.commentGoodNumberLabel.textAlignment = NSTextAlignmentRight;
        self.commentGoodNumberLabel.textColor = RGBCOLOR(147, 147, 147);
        self.commentGoodNumberLabel.font = FONTSIZE(11);
        [self.contentView addSubview:self.commentGoodNumberLabel];
        
    }
    return self;
}

- (void)setScore:(int)score
{
    _score = score;
    
    CGRect rect = scoreImageView.frame;
    rect.size.width = scoreBackgroundImageView.frame.size.width * score / 5.0;
    scoreImageView.frame = rect;
}


- (void)insertIntoDataIcon:(NSURL *)urlImage name:(NSString *)name date:(NSString *)date comment:(NSString *)comment score:(int)score
{
    [self.icon setImageWithURL:urlImage placeholderImage:IMAGENAMED(@"placeholderImage") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image == nil) {
            return ;
        }
    }];
    self.name.text = name;
    
    CGRect rect = scoreBackgroundImageView.frame;
    CGSize size = [self.name.text sizeWithFont:self.name.font constrainedToSize:self.name.frame.size];
    rect.origin.x = size.width + self.name.frame.origin.x;
    scoreBackgroundImageView.frame = rect;
    
    scoreImageView.frame = scoreBackgroundImageView.frame;
    
    self.date.text = date;
    self.comment.text = comment;
    
    rect = self.comment.frame;
    size = [self.comment.text sizeWithFont:self.comment.font constrainedToSize:SIZE(self.frame.size.width - 20, 1000)];
    rect.size = size;
    self.comment.frame = rect;
    
    self.score = score;

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
