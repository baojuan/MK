//
//  RightCell.m
//  MKProject
//
//  Created by baojuan on 14-6-22.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "RightCell.h"

@implementation RightCell
{
    AppDelegate *appdelegate;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        appdelegate = APPDELEGATE;
        self.backgroundColor = [UIColor clearColor];
        
        self.videoImageView = [[UIImageView alloc] initWithFrame:RECT(20, (50 - 58 / 2.0) / 2.0, 58 / 2.0, 58 / 2.0)];
        [self.contentView addSubview:self.videoImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:RECT(self.videoImageView.frame.size.width + self.videoImageView.frame.origin.x + 15, 0, 100, 50)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = appdelegate.s1Color;
        self.titleLabel.font = FONTSIZE(appdelegate.s1FontSize);
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
